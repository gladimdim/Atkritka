//
//  PopularDownloader.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PopularDownloader.h"
#import "PostCardObject.h"
#import "DownloadCallBack.h"

@interface PopularDownloader()
@property NSMutableData *receivedData;
@property NSMutableArray *arrayOfPostCards;
@property id <DownloadCallBack> callBackDelegate;
@end

@implementation PopularDownloader

-(void) getCards:(id <DownloadCallBack>) callBackDelegate {
    self.callBackDelegate = callBackDelegate;
    NSURL *popularJsonURL = [NSURL URLWithString:@"http://atkritka.com/?all&json=Y"];
    NSURLRequest *request = [NSURLRequest requestWithURL:popularJsonURL];
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
    NSError *err;
    NSJSONSerialization *serialization = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *root = (NSDictionary *) serialization;
   // NSLog(@"serialized: %@", serialization);
    NSDictionary *dictOfCards = (NSDictionary *) [root objectForKey:@"cards"];
    NSEnumerator *key = dictOfCards.keyEnumerator;
    self.arrayOfPostCards = [[NSMutableArray alloc] init];
    NSString *currentKey;
    while ( currentKey = [key nextObject]) {
        NSDictionary *dictCard = (NSDictionary *) [dictOfCards valueForKey:currentKey];
        PostCardObject *obj = [[PostCardObject alloc] init];
        obj.imageURL = [dictCard valueForKey:@"pic"];
        obj.uniqueId = currentKey;
        [self.arrayOfPostCards addObject:obj];
       // NSLog(@"array: %@", dictCard);
    }
    [self.callBackDelegate postCardsDownloaded:self.arrayOfPostCards];
}

@end