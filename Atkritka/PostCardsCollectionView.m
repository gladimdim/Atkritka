//
//  PostCardsCollectionViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/7/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardsCollectionView.h"
#import "PostCardObject.h"
#import "StatusLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface PostCardsCollectionView ()
@property CGPoint startSwipePoint;
@property UIGestureRecognizer *gesture;
@property NSIndexPath *lastSwipedCollectionViewCell;
@property int popularCounter;
@end

#define TAG_SCROLLVIEW 1
#define TAG_IMAGEVIEW 2
#define TAG_AUTHOR_LABEL 5
#define TAG_VIEW_CONTAINTER 3
#define TAG_CREATEDAT_LABEL 6

@implementation PostCardsCollectionView

-(void) registerGestures {
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerHandler:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeftGesture.delegate = self;
    [self addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerHandler:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:tapGesture];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfData.count;
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"postCardCell" forIndexPath:indexPath];
    //get scrollview of cell and set its contentOffset point to 0,0.
    //this is done because UICollectionView dequeues and reuses the same view and scroll is not reset.
    //that is why we have several uiscrolls swiped 
    UIScrollView *scrollView = (UIScrollView *) [cell.contentView viewWithTag:TAG_SCROLLVIEW];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    /*
    UIView *view = [scrollView viewWithTag:3];
    UILabel *label = (UILabel*) [view viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%i", indexPath.row];
    NSLog(@"generated cell #%i", indexPath.row);*/
    
     PostCardObject *postCardObj = self.arrayOfData[indexPath.row];
     UIImageView *imageViewFromCell = (UIImageView *) [scrollView viewWithTag:TAG_IMAGEVIEW];
     if (postCardObj.imageCard) {
         imageViewFromCell.image = postCardObj.imageCard;
     }
     else {
         imageViewFromCell.image = [UIImage imageNamed:@"iTunesArtWork"];
     }
    
    //getting container view (view which is swipped to the left)
    //setting its background color and rounded corners
    UIView *containerView = (UIView *) [scrollView viewWithTag:TAG_VIEW_CONTAINTER];
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"custom_grouped"]];
    containerView.layer.cornerRadius = 5;
    UILabel *labelAuthor = (UILabel*) [containerView viewWithTag:TAG_AUTHOR_LABEL];
    labelAuthor.text = postCardObj.author;
    
    UILabel *labelCreatedAt = (UILabel *) [containerView viewWithTag:TAG_CREATEDAT_LABEL];
    labelCreatedAt.text = postCardObj.creationDate;
    
    if (indexPath.row == self.arrayOfData.count-2) {
         [self.callBackDelegate downloadCards:++self.popularCounter];
         //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:NSIndex, nil]];
        UIViewController *con = (UIViewController *) self.callBackDelegate;
        
         [StatusLabel showLabelWithStatusOfAction:@"Обновляем" forView:con.view];
         //[self.callBackDelegate addDummyPostCardsAndUpdateTableView];
    }
    
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
    NSLog(@"scrollview contentoffset: %@ and direction: %i", NSStringFromCGPoint(scrollContentOffset), sender.direction);
    if (scrollContentOffset.x == 150 && sender.direction == UISwipeGestureRecognizerDirectionRight) {
        scrollToPoint = CGPointMake(0, 0);
        [scrollView setContentOffset:scrollToPoint animated:YES];
      //  [self scrollLastSwipedCellAtIndexPath:swipedAtIndexPath];
    }
    else if (scrollContentOffset.x == 0 && sender.direction == UISwipeGestureRecognizerDirectionLeft){
        scrollToPoint = CGPointMake(150, 0);
        [scrollView setContentOffset:scrollToPoint animated:YES];
       // [self scrollLastSwipedCellAtIndexPath:swipedAtIndexPath];
    }
    [self scrollLastSwipedCellWithNewIndexPath:swipedAtIndexPath animated:YES];
    NSIndexPath *cheat = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self cellForItemAtIndexPath:cheat];
    scrollView = (UIScrollView *) [cell viewWithTag:1];
    scrollContentOffset = scrollView.contentOffset;
    NSLog(@"scroll log cheated: %@", NSStringFromCGPoint(scrollContentOffset));
    
    
    NSLog(@"swiped cell %i", swipedAtIndexPath.row);
}

-(void) scrollLastSwipedCellWithNewIndexPath:(NSIndexPath *) newIndexPathForSwiped animated:(BOOL) animated {
    if (self.lastSwipedCollectionViewCell == newIndexPathForSwiped) {
        return;
    }
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.lastSwipedCollectionViewCell];
    UIScrollView *scroll = (UIScrollView *) [cell viewWithTag:1];
    [scroll setContentOffset:CGPointMake(0, 0) animated:animated];
    self.lastSwipedCollectionViewCell = newIndexPathForSwiped;
}

-(void) tapGestureHandler:(UITapGestureRecognizer *)sender {
    [self scrollLastSwipedCellWithNewIndexPath:nil animated:YES];
}

@end
