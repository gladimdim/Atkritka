//
//  PopularDownloader.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadCallBack.h"

@interface PostCardDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
-(void) getCardsDelegate:(id) callBackDelegate section:(NSString *) section forPageId:(NSInteger) pageId;
-(void) getRandomCard:(id <DownloadCallBack> ) callBackDelegate;
@property id <DownloadCallBack> callBackDelegate;
@end
