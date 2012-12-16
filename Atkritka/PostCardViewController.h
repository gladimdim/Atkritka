//
//  PostCardViewController.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCallBack.h"
#import "PostCardDetailedViewController.h"
#import "PostCardsCollectionView.h"
#import "CardsManagementProtocol.h"
#import "Authorizer.h"
#import "PostCardRater.h"

@interface PostCardViewController : UIViewController <DownloadCallBack, ModalPostCardCallBack, CardsManagementProtocol, AuthorizerCallBack, PostCardRaterCallBack >
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlChanged:(id)sender;
@end
