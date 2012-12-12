//
//  PostCardsCollectionViewController.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/7/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsManagementProtocol.h"

@interface PostCardsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout>
@property NSMutableArray *arrayOfData;
-(void) registerGestures;
@property id <CardsManagementProtocol> callBackDelegate;
@end
