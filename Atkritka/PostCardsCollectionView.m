//
//  PostCardsCollectionViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/7/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardsCollectionView.h"
#import "PostCardObject.h"

@interface PostCardsCollectionView ()
@property CGPoint startSwipePoint;
@property UIGestureRecognizer *gesture;
@property NSIndexPath *lastSwipedCollectionViewCell;
@end

@implementation PostCardsCollectionView

-(void) registerGestures {
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerHandler:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeftGesture.delegate = self;
    [self addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerHandler:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightGesture];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.arrayOfPostCards.count;
    return 20;
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"postCardCell" forIndexPath:indexPath];
    UIScrollView *scrollView = [cell.contentView viewWithTag:1];

    UIView *view = [scrollView viewWithTag:3];
    UILabel *label = (UILabel*) [view viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%i", indexPath.row];
    /*UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 450, 187)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 187)];
    imageView.image = [UIImage imageNamed:@"iTunesArtwork"];
    imageView.tag = 2;
    [scrollView addSubview:imageView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(300, 0, 244, 187)];
    containerView.backgroundColor = [UIColor grayColor];
    
    [scrollView addSubview:containerView];
    
    scrollView.tag = 1;
    [cell.contentView addSubview:scrollView];
    */

    /*
     PostCardObject *postCardObj = self.arrayOfPostCards[indexPath.row];
     UIImageView *imageViewFromCell = (UIImageView *) [cell viewWithTag:1];
     if (postCardObj.imageCard) {
     imageViewFromCell.image = postCardObj.imageCard;
     }
     else {
     imageViewFromCell.image = [UIImage imageNamed:@"logo.png"];
     }
     if (indexPath.row == self.arrayOfPostCards.count-2) {
     [self downloadCards:++self.popularCounter];
     //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:NSIndex, nil]];
     [StatusLabel showLabelWithStatusOfAction:@"Обновляем" forView:self.view];
     //[self addDummyPostCardsAndUpdateTableView];
     }*/
    return cell;
}

- (void) swipeGestureRecognizerHandler:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swiped to: %i", sender.direction);
    CGPoint swipePoint = [sender locationInView:self];
    NSIndexPath *swipedAtIndexPath = [self indexPathForItemAtPoint:swipePoint];
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:swipedAtIndexPath];
    UIScrollView *scrollView = (UIScrollView *) [cell viewWithTag:1];
    CGPoint scrollContentOffset = scrollView.contentOffset;
    CGPoint scrollToPoint;
    NSLog(@"scrollview contentoffset: %@", NSStringFromCGPoint(scrollContentOffset));
    
    if (scrollContentOffset.x == 200 && sender.direction == UISwipeGestureRecognizerDirectionRight) {
        scrollToPoint = CGPointMake(0, 0);
        [scrollView setContentOffset:scrollToPoint animated:YES];
       // [self scrollLastSwipedCellAtIndexPath:swipedAtIndexPath];
    }
    else if (scrollContentOffset.x == 0 && sender.direction == UISwipeGestureRecognizerDirectionLeft){
        scrollToPoint = CGPointMake(200, 0);
        [scrollView setContentOffset:scrollToPoint animated:YES];
       // [self scrollLastSwipedCellAtIndexPath:swipedAtIndexPath];
    }
    
    NSLog(@"swiped cell %i", swipedAtIndexPath.row);
}

-(void) scrollLastSwipedCellAtIndexPath:(NSIndexPath *) newIndexPathForSwiped {
    if (self.lastSwipedCollectionViewCell) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.lastSwipedCollectionViewCell];
        UIScrollView *scroll = (UIScrollView *) [cell viewWithTag:1];
        [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        self.lastSwipedCollectionViewCell = newIndexPathForSwiped;
    }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self scrollLastSwipedCellAtIndexPath:self.lastSwipedCollectionViewCell];
    self.lastSwipedCollectionViewCell = nil;
}

@end