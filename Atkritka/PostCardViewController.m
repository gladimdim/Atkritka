//
//  PostCardViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/24/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardViewController.h"
#import "PopularDownloader.h"
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
@end

@implementation PostCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popularCounter = 0;
    self.arrayOfPostCards = [[NSMutableArray alloc] initWithCapacity:10];
    [self downloadCards:self.popularCounter];
    self.postCardsCollectionView = (PostCardsCollectionView *) self.collectionView;
    self.postCardsCollectionView.arrayOfData = self.arrayOfPostCards;
    self.postCardsCollectionView.callBackDelegate = self;
    self.collectionView.delegate = self.postCardsCollectionView;
    self.collectionView.dataSource = self.postCardsCollectionView;
    [self.postCardsCollectionView registerGestures];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) downloadCards:(NSInteger ) pageId {
    PopularDownloader *downloader = [[PopularDownloader alloc]init];
    if (self.segmentedControl.selectedSegmentIndex == 0 )
        [downloader getCardsDelegate:self section:@"" forPageId:pageId];
    else if (self.segmentedControl.selectedSegmentIndex == 1)
        [downloader getCardsDelegate:self section:@"new&" forPageId:pageId];
    else if (self.segmentedControl.selectedSegmentIndex == 2)
        [downloader getCardsDelegate:self section:@"all&" forPageId:pageId];
    else if (self.segmentedControl.selectedSegmentIndex == 3) {
        [downloader getRandomCard:self];
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

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCardDetailView"]) {
        PostCardDetailedViewController *pcVC = (PostCardDetailedViewController *) segue.destinationViewController;
        NSIndexPath *selectedIndex = [[self.collectionView indexPathsForSelectedItems] lastObject];
        
        pcVC.postCardObj = [self.arrayOfPostCards objectAtIndex:selectedIndex.row];
    }
}

- (IBAction)segmentedControlChanged:(id)sender {
    if (self.arrayOfPostCards.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    [self.arrayOfPostCards removeAllObjects];
    [self.collectionView reloadData];
    [self downloadCards:0];
}

-(void) closeModalPostCard {
    [self dismissViewControllerAnimated:YES completion:^ {
        NSLog(@"Closed modal view");
    }];
}
@end
