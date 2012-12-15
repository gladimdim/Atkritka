//
//  LoginViewController.m
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/15/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import "LoginViewController.h"
#import "StatusLabel.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
- (IBAction)btnLoginPressed:(id)sender;

@end

@implementation LoginViewController 

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textFieldUsername.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    self.textFieldPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}

- (IBAction)btnLoginPressed:(id)sender {
    [StatusLabel showLabelWithStatusOfAction:@"Authorizing" forView:self.view position:@"center"];
    if ([self.textFieldPassword.text isEqualToString:@""] || [self.textFieldUsername.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter info" message:@"Enter username and password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:self.textFieldUsername.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:self.textFieldPassword.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        Authorizer *authorizer = [[Authorizer alloc] init];
        authorizer.callBackDelegate = self;
        [authorizer authorizeUser];
    }
}

-(void) userWasAuthorized:(BOOL)authorized {
    if (authorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter data" message:@"User authorized." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter data" message:@"Wrong username or password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
@end
