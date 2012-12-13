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
@end
@implementation Authorizer

-(void) authorizeUser {
    NSURL *authURL = [NSURL URLWithString:@"http://atkritka.com/auth/index.php?json=Y"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"zopik", @"zopa1234"];
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
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    if (cookie) {
        
        [[NSUserDefaults standardUserDefaults] setValue:cookie forKey:@"auth-cookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSWindowsCP1251StringEncoding];
}
@end
