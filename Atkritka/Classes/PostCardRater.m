//
//  PostCardRater.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/13/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardRater.h"
#import "Authorizer.h"

@interface PostCardRater ()
@property NSMutableData *receivedData;
@property NSString *cookie;
@property PostCardObject *postCard;
@property BOOL goodRating;
@end

@implementation PostCardRater

-(void) rateCard:(PostCardObject *) postCard goodRating:(BOOL)rating {
    self.postCard = postCard;
    self.goodRating = rating;
    NSString *action = rating ? @"plus" : @"minus";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://atkritka.com/vote.php?action=%@&id=%@&js", action, postCard.uniqueId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth-cookie"] forHTTPHeaderField:@"Cookie"];
    //[request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:YES];
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
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSWindowsCP1251StringEncoding];
    NSLog(@"response for rate: %@", string);
    NSRange range = [string rangeOfString:@"error"];
    if (range.location == NSNotFound) {
        NSLog(@"ok rate");
        [self.callBackDelegate postCard:self.postCard ratedUp:self.goodRating];
    }
    else {
        Authorizer *authorizer = [[Authorizer alloc] init];
        [authorizer authorizeUser:^(BOOL authorized) {
            NSLog(@"authorized user from PostCardRater:%@", authorized ? @"YES" : @"NO");
        }];
        NSLog(@"not ok rate");
    }
}

@end
