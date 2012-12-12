//
//  PopularDownloader.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardDownloader.h"
#import "PostCardObject.h"

@interface PostCardDownloader()
@property NSMutableData *receivedData;
@property NSMutableArray *arrayOfPostCards;
@end

@implementation PostCardDownloader

-(void) getCardsDelegate:(id <DownloadCallBack>) callBackDelegate section:(NSString *)section forPageId:(NSInteger)pageId {
    self.callBackDelegate = callBackDelegate;
    NSURL *popularJsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://atkritka.com/?%@json=Y&PAGEN_1=%i", section, pageId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:popularJsonURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else {
        self.receivedData = nil;
    }
}

-(void) getRandomCard: (id <DownloadCallBack>) callBackDelegate {
    self.callBackDelegate = callBackDelegate;
    NSURL *popularJsonURL = [NSURL URLWithString:@"http://atkritka.com/random_ok/?json=Y"];
    NSURLRequest *request = [NSURLRequest requestWithURL:popularJsonURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else {
        self.receivedData = nil;
    }
}

-(void) getCard:(NSString *) cardId {
    NSURL *cardJsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://atkritka.com/%@/?json=Y", cardId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:cardJsonURL];
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
    self.arrayOfPostCards = [[NSMutableArray alloc] init];
    NSJSONSerialization *serialization = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *root = (NSDictionary *) serialization;
    
    //check if we called random post card link and we got response only with its id
    if ([[[root allKeys] lastObject] isEqualToString:@"random"]) {
        [self getCard:[root valueForKey:@"random"]];
        return;
    }
    
    //deal with single post card in json
    if ([root allKeys].count == 1) {
        NSDictionary *dictCard = (NSDictionary *) [root objectForKey:[[root allKeys] lastObject]];
        PostCardObject *obj = [[PostCardObject alloc] init];
        obj.imageURL = [dictCard valueForKey:@"pic"];
        obj.uniqueId = (NSString *) [[root allKeys] lastObject];
        obj.rating = [dictCard valueForKey:@"rating"];
        obj.creationDate = [dictCard valueForKey:@"date"];
        obj.author = [dictCard valueForKey:@"author"];
        [self.arrayOfPostCards addObject:obj];
    }
    
    //deal with list of cards
    NSDictionary *dictOfCards = (NSDictionary *) [root objectForKey:@"cards"];
    NSEnumerator *key = dictOfCards.keyEnumerator;
    NSString *currentKey;
    while ( currentKey = [key nextObject]) {
        NSDictionary *dictCard = (NSDictionary *) [dictOfCards valueForKey:currentKey];
        PostCardObject *obj = [[PostCardObject alloc] init];
        obj.imageURL = [dictCard valueForKey:@"pic"];
        obj.uniqueId = currentKey;
        obj.rating = [dictCard valueForKey:@"rating"];
        obj.creationDate = [dictCard valueForKey:@"date"];
        obj.author = [dictCard valueForKey:@"author"];
        [self.arrayOfPostCards addObject:obj];
    }
    [self.callBackDelegate postCardsDownloaded:self.arrayOfPostCards];
}

@end
