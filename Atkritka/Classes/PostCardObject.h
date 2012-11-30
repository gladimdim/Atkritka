//
//  PostCardObject.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/25/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostCardObject : NSObject
@property UIImage *imageCard;
@property NSString *imageURL;
@property NSString *author;
@property NSString *uniqueId;
@property NSString *creationDate;
@property NSString *rating;
@end
