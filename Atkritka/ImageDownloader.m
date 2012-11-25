//
//  ImageDownloader.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/25/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()
@property NSMutableData *receivedData;
@end

@implementation ImageDownloader

-(void) downloadImageForPostCardObject:(PostCardObject *) card {
    self.card = card;
    NSURL *url = [NSURL URLWithString:card.imageURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
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
    self.receivedData.length = 0;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [UIImage imageWithData:self.receivedData];
    self.card.imageCard = image;
    [self.callBackDelegate imageDownloadedForCard:self.card];
}

@end
