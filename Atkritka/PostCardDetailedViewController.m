//
//  PostCardDetailedViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 11/30/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "PostCardDetailedViewController.h"

@interface PostCardDetailedViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelAuthor;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UILabel *labelRating;
- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation PostCardDetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(300, 300);
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.image = self.postCardObj.imageCard;
    self.labelAuthor.text = self.postCardObj.author;
    self.labelDate.text = self.postCardObj.creationDate;
    self.labelRating.text = self.postCardObj.rating;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)closeButtonPressed:(id)sender {
    NSLog(@"Closing...");
    [self.delegate closeModalPostCard];
}
@end
