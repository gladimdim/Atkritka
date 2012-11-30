//
//  PopularDownloader.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
-(void) getCards:(id) callBackDelegate section:(NSString *) section forPageId:(NSInteger) pageId;

@end
