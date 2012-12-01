//
//  PostCardDetailedViewController.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/30/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCardObject.h"


@protocol ModalPostCardCallBack <NSObject>

-(void) closeModalPostCard;

@end

@interface PostCardDetailedViewController : UIViewController
@property id <ModalPostCardCallBack> delegate;
@property PostCardObject *postCardObj;
@end
