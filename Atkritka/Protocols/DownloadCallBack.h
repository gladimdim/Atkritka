//
//  DownloadCallBack.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/25/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostCardObject.h"

@protocol DownloadCallBack <NSObject>
-(void) postCardsDownloaded:(NSArray *) arrayOfPostCards;
-(void) imageDownloadedForCard:(PostCardObject *) postCard;
@end
