//
//  ImageDownloader.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/25/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostCardObject.h"
#import "DownloadCallBack.h"

@interface ImageDownloader : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property PostCardObject *card;
@property id <DownloadCallBack> callBackDelegate;
-(void) downloadImageForPostCardObject:(PostCardObject *) card;
@end
