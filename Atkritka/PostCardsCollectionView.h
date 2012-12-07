//
//  PostCardsCollectionViewController.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/7/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCardsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property NSMutableArray *arrayOfData;
-(void) registerGestures;
@end
