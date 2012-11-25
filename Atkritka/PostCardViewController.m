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

@interface PostCardViewController ()
@property NSArray *arrayOfPostCards;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation PostCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadPopular];
}

-(void) downloadPopular {
    PopularDownloader *downloader = [[PopularDownloader alloc]init];
    [downloader getCards:self];
}

-(void) postCardsDownloaded:(NSArray *)arrayOfPostCards {
    self.arrayOfPostCards = arrayOfPostCards;
    for (int i = 0; i < self.arrayOfPostCards.count; i++) {
        ImageDownloader *downloader = [[ImageDownloader alloc] init];
        downloader.callBackDelegate = self;
        [downloader downloadImageForPostCardObject:self.arrayOfPostCards[i]];
    }
}

- (IBAction)segmentedControlChanged:(id)sender {
    [self downloadPopular];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPostCards.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    /*if (!cell) {
        cell = [UICollectionViewCell alloc] 
    }*/
    PostCardObject *postCardObj = self.arrayOfPostCards[indexPath.row];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:postCardObj.imageCard];
    UIImageView *imageViewFromCell = (UIImageView *) [cell viewWithTag:1];
    imageViewFromCell.image = postCardObj.imageCard;
    //[cell.contentView addSubview:imageView];
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
@end
