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

@interface PostCardViewController ()
@property NSMutableArray *arrayOfPostCards;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSInteger popularCounter;
@end

@implementation PostCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popularCounter = 0;
    self.arrayOfPostCards = [[NSMutableArray alloc] initWithCapacity:10];
    [self downloadCards:self.popularCounter];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) downloadCards:(NSInteger ) pageId {
    PopularDownloader *downloader = [[PopularDownloader alloc]init];
    if (self.segmentedControl.selectedSegmentIndex == 0 )
        [downloader getCards:self section:@"" forPageId:pageId];
    else if (self.segmentedControl.selectedSegmentIndex == 1)
        [downloader getCards:self section:@"new&" forPageId:pageId];
    else if (self.segmentedControl.selectedSegmentIndex == 2)
        [downloader getCards:self section:@"all&" forPageId:pageId];
}

-(void) postCardsDownloaded:(NSArray *)arrayOfPostCards {
    [self.arrayOfPostCards addObjectsFromArray:arrayOfPostCards];
    for (int i = 0; i < self.arrayOfPostCards.count; i++) {
        ImageDownloader *downloader = [[ImageDownloader alloc] init];
        downloader.callBackDelegate = self;
        [downloader downloadImageForPostCardObject:self.arrayOfPostCards[i]];
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPostCards.count;
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
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
    }
    return cell;
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
        NSLog(@"Opening modal view");
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
