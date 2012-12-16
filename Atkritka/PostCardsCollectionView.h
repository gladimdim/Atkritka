//
//  PostCardsCollectionViewController.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/7/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsManagementProtocol.h"

#define TAG_SCROLLVIEW 1
#define TAG_IMAGEVIEW 2
#define TAG_AUTHOR_LABEL 5
#define TAG_VIEW_CONTAINTER 3
#define TAG_CREATEDAT_LABEL 6
#define TAG_RATING_LABEL 7

@interface PostCardsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout>
@property NSMutableArray *arrayOfData;
-(void) registerGestures;
@property id <CardsManagementProtocol> callBackDelegate;
@end
