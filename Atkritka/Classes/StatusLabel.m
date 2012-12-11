//
//  StatusLabel.m
//  MEMobileReports
//
//  Created by Gladkyi, Dmytro on 11/5/12.
//  Copyright (c) 2012 Gladkyi, Dmytro. All rights reserved.
//

#import "StatusLabel.h"

@implementation StatusLabel
+(void) showLabelWithStatusOfAction:(NSString *) stringAction forView:(UIView *) view position:(NSString *)position{
    UILabel *statusLabel = (UILabel*) [view viewWithTag:5553];
    if (statusLabel) {
        [statusLabel removeFromSuperview];
    }
    
    CGSize winSize = view.bounds.size;
    int labelWidth = 150;
    CGRect labelRect;
    if ([position isEqualToString:@"left"]) {
        labelRect = CGRectMake(0, 0, labelWidth, 22);
    }
    else if ([position isEqualToString:@"right"]) {
        labelRect = CGRectMake(winSize.width - labelWidth, 0, labelWidth, 22);
    }
    else if ([position isEqualToString:@"center"]) {
        labelRect = CGRectMake(winSize.width /2 - labelWidth /2 , 0, labelWidth, 22);
    }
    statusLabel = [[UILabel alloc] initWithFrame:labelRect];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:13];
    statusLabel.backgroundColor = [UIColor blackColor];
    statusLabel.text = stringAction;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.tag = 5553;
    [view addSubview:statusLabel];
    statusLabel.alpha = 1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStatusLabelFinished:)];
    [UIView setAnimationDuration:5.0];
    statusLabel.alpha = 0;
    [UIView commitAnimations];
}
@end
