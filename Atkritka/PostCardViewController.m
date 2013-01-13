//
//  PostCardViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardViewController.h"
#import "PostCardDownloader.h"
#import "PostCardObject.h"
#import "ImageDownloader.h"
#import "PostCardDetailedViewController.h"
#import "StatusLabel.h"
#import "PostCardsCollectionView.h"

@interface PostCardViewController ()
@property NSMutableArray *arrayOfPostCards;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSInteger popularCounter;
@property CGPoint startSwipePoint;
@property PostCardsCollectionView *postCardsCollectionView;
@property PostCardDownloader *postCardDownloader;
@property NSInteger selectSegmentControlIndex;
@end

@implementation PostCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"segment_background"]];
    self.popularCounter = 1; //setting this to 1 and not to 0: because for API 0=1. 
    self.arrayOfPostCards = [[NSMutableArray alloc] initWithCapacity:10];
    [self downloadCards:self.popularCounter];
    self.postCardsCollectionView = (PostCardsCollectionView *) self.collectionView;
    self.postCardsCollectionView.arrayOfData = self.arrayOfPostCards;
    self.postCardsCollectionView.callBackDelegate = self;
    self.collectionView.delegate = self.postCardsCollectionView;
    self.collectionView.dataSource = self.postCardsCollectionView;
    [self.postCardsCollectionView registerGestures];
    [self.segmentedControl setImage:[UIImage imageNamed:@"ico-user"] forSegmentAtIndex:3];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.selectSegmentControlIndex ? [self.segmentedControl setSelectedSegmentIndex:self.selectSegmentControlIndex] : [self.segmentedControl setSelectedSegmentIndex:0];
//    [self.segmentedControl setSelectedSegmentIndex:self.selectSegmentControlIndex];
    if (self.arrayOfPostCards.count == 0) {
        [self.segmentedControl setSelectedSegmentIndex:self.selectSegmentControlIndex];
          [self segmentedControlChanged:self.segmentedControl];
    }
    
}

-(void) downloadCards:(NSInteger ) pageId {
    self.postCardDownloader = [[PostCardDownloader alloc] init];
    if (self.segmentedControl.selectedSegmentIndex == 0 ) {
        self.selectSegmentControlIndex = self.segmentedControl.selectedSegmentIndex;
        [StatusLabel showLabelWithStatusOfAction:NSLocalizedString(@"Updating", nil) forView:self.view position:@"center"];
        [self.postCardDownloader getCardsDelegate:self section:@"" forPageId:self.popularCounter];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.selectSegmentControlIndex = self.segmentedControl.selectedSegmentIndex;
        [StatusLabel showLabelWithStatusOfAction:NSLocalizedString(@"Updating", nil) forView:self.view position:@"center"];
        [self.postCardDownloader getCardsDelegate:self section:@"new&" forPageId:self.popularCounter];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 2) {
        self.selectSegmentControlIndex = self.segmentedControl.selectedSegmentIndex;
        [StatusLabel showLabelWithStatusOfAction:NSLocalizedString(@"Updating", nil) forView:self.view position:@"center"];
        //[self.postCardDownloader getCardsDelegate:self section:@"all&" forPageId:pageId];
        [self.postCardDownloader getRandomCard:self];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 3) {
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

-(void) postCardsDownloaded:(NSArray *)arrayOfPostCards {
    [self.arrayOfPostCards addObjectsFromArray:arrayOfPostCards];
    for (int i = 0; i < self.arrayOfPostCards.count; i++) {
        ImageDownloader *downloader = [[ImageDownloader alloc] init];
        downloader.callBackDelegate = self;
        [downloader downloadImageForPostCardObject:self.arrayOfPostCards[i]];
    }
}

-(void) increasepageCounter {
    self.popularCounter = self.popularCounter + 1;
}

-(void) addDummyPostCardsAndUpdateTableView {
    NSMutableArray *arrayOfDummyIndexes = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [arrayOfDummyIndexes addObject:indexPath];
        [self.arrayOfPostCards addObject:[NSNull null]];
    }
    //[self.collectionView reloadItemsAtIndexPaths:arrayOfDummyIndexes];
}

-(void) imageDownloadedForCard:(PostCardObject *) postCard {
    NSEnumerator *enumerator = self.arrayOfPostCards.objectEnumerator;
    PostCardObject *card;
    while ( card = [enumerator nextObject]) {
        if ([card.uniqueId isEqualToString:postCard.uniqueId]) {
            card = postCard;
        }
    }
    [self.collectionView reloadData];
}

/*-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // [self performSegueWithIdentifier:@"showCardDetailView" sender:self];
    PostCardDetailedViewController *pcVC = [[PostCardDetailedViewController alloc] initWithNibName:@"PostCardDetailedlViewController" bundle:[NSBundle mainBundle]];
    NSIndexPath *selectedIndex = [[self.collectionView indexPathsForSelectedItems] lastObject];
    pcVC.postCardObj = [self.arrayOfPostCards objectAtIndex:selectedIndex.row];
    pcVC.delegate = self;
    UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:pcVC];
    [unc setNavigationBarHidden:YES];
    [self presentViewController:unc animated:YES completion:^{
        NSLog(@"Opefning modal view");
    }];
}*/

- (IBAction)segmentedControlChanged:(id)sender {
    //check that we did not select last segment to show login view.
    //we shall remove all objects if switching between different sources for postcards
    //but we shoudl remain all postcards if showing login view because in such case when we press back button
    //data will be restored by iOS back to view.
    UISegmentedControl *control = (UISegmentedControl *) sender;
    NSInteger selected = control.selectedSegmentIndex;
    if (selected == 3) {
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
        return;
    }
    else {
        self.popularCounter = 1;
        [self.arrayOfPostCards removeAllObjects];
        [self.collectionView reloadData];
        //reset current downloader so not yet loaded post cards are not loaded to new view
        self.postCardDownloader.callBackDelegate = nil;
        self.postCardDownloader = nil;
        self.postCardDownloader = [[PostCardDownloader alloc] init];
        [StatusLabel showLabelWithStatusOfAction:@"Updating" forView:self.view position:@"center"];
        /*  if (self.arrayOfPostCards.count > 0) {
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
         }*/
        [self downloadCards:0];
    }
}

-(void) ratePostCard:(PostCardObject *) postCard goodRating:(BOOL) rating {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //NSArray *array = [storage cookies];
    [storage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    PostCardRater *rater = [[PostCardRater alloc] init];
    rater.callBackDelegate = self;
    NSString *cookie = [[NSUserDefaults standardUserDefaults] stringForKey:@"auth-cookie"];
    
    if (cookie) {
        [rater rateCard:postCard goodRating:rating];
    }
    else {
        Authorizer *authorizer = [[Authorizer alloc] init];
        [authorizer authorizeUser:^(BOOL authorized) {
            if (!authorized) {
                [self performSegueWithIdentifier:@"showLoginView" sender:self];
            }
        }];
    }
}

-(BOOL) checkUsernameAndPasswordExist {
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    return !([username isEqualToString:@""] || [password isEqualToString:@""]);

}

- (IBAction)minusButtonPressed:(id)sender {
    if ([self checkUsernameAndPasswordExist]) {
        NSLog(@"superview: %@", [[[sender superview] superview] superview]);
        UICollectionViewCell *cell = (UICollectionViewCell *) [[[[sender superview] superview] superview] superview];
        NSIndexPath *touchedIndex = [self.collectionView indexPathForCell:cell];
        NSLog(@"touched %i", touchedIndex.row);
        [self ratePostCard:self.arrayOfPostCards[touchedIndex.row] goodRating:NO];
    }
    else {
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

- (IBAction)plusButtonPressed:(id)sender {
    /*Authorizer *authorizer = [[Authorizer alloc] init];
    [authorizer authorizeUser];
     */
    if ([self checkUsernameAndPasswordExist]) {
        NSLog(@"superview: %@", [[[sender superview] superview] superview]);
        UICollectionViewCell *cell = (UICollectionViewCell *) [[[[sender superview] superview] superview] superview];
        NSIndexPath *touchedIndex = [self.collectionView indexPathForCell:cell];
        NSLog(@"touched %i", touchedIndex.row);
        [self ratePostCard:self.arrayOfPostCards[touchedIndex.row] goodRating:YES];
    }
    else {
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

- (IBAction)btnRandomPressed:(id)sender {
    [self.arrayOfPostCards removeAllObjects];
    [self.collectionView reloadData];
    [self downloadCards:0];
}

-(void) postCard:(PostCardObject *)postCard ratedUp:(BOOL)rated {
    NSInteger rating = [postCard.rating integerValue];
    rated ? rating++ : rating--;
    postCard.rating = [NSString stringWithFormat:@"%i", rating];

    NSInteger index = [self.arrayOfPostCards indexOfObject:postCard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIScrollView *scrollView = (UIScrollView *) [cell.contentView viewWithTag:TAG_SCROLLVIEW];
    UIView *containerView = (UIView *) [scrollView viewWithTag:TAG_VIEW_CONTAINTER];
    UILabel *labelRating = (UILabel *) [containerView viewWithTag:TAG_RATING_LABEL];
    labelRating.text = postCard.rating;
    //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

@end
