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
@end

@implementation PostCardRater

-(void) rateCard:(PostCardObject *) postCard goodRating:(BOOL)rating {
    NSString *action = rating ? @"plus" : @"minus";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://atkritka.com/vote.php?action=%@&id=%@&js", action, postCard.uniqueId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
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
    NSRange range = [string rangeOfString:@"error"];
    if (range.location == NSNotFound) {
        NSLog(@"ok rate");
    }
    else {
        NSLog(@"not ok rate");
    }
}

@end
