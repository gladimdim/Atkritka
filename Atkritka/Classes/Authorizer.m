//
//  Authorizer.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/13/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "Authorizer.h"
#import "NSData+Base64.h"

@interface Authorizer ()
@property NSMutableData *receivedData;
@property NSString *cookie;
@property (strong) void (^block) (BOOL);
@end
@implementation Authorizer

-(void) authorizeUser:(void (^)(BOOL))block {
    self.block = block;
    NSURL *authURL = [NSURL URLWithString:@"http://atkritka.com/auth/index.php?json=Y"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else {
        self.receivedData = nil;
    }
    
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *fields = [httpResponse allHeaderFields];
    self.cookie = [fields valueForKey:@"Set-Cookie"];
    
    if (self.cookie) {
        [[NSUserDefaults standardUserDefaults] setValue:self.cookie forKey:@"auth-cookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSWindowsCP1251StringEncoding];
    
    if ([string rangeOfString:@"error"].location == NSNotFound) {
        if (self.block)
            self.block(YES);
    }
    else {
        self.block(NO);
       // [self.callBackDelegate userWasAuthorized:NO];
    }
    
}
@end
