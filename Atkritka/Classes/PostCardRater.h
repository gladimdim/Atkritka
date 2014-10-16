//
//  PostCardRater.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/13/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostCardObject.h"
#import "Authorizer.h"

@protocol PostCardRaterCallBack <NSObject>

-(void) postCard:(PostCardObject *) postCard ratedUp:(BOOL) rated;
@end

@interface PostCardRater : NSObject <NSURLConnectionDelegate>
-(void) rateCard:(PostCardObject *) postCard goodRating:(BOOL) rating;
@property id <PostCardRaterCallBack> callBackDelegate;
@end
