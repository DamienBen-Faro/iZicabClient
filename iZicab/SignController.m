//
//  ViewController.m
//  iZicab
//
//  Created by Damien  on 3/26/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SignController.h"
#import "DashboardViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "UserInfoSingleton.h"

@implementation SignController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[ConnectionData sharedConnectionData] beginService: @"auth/checkUserActivated" :[[NSMutableDictionary alloc] initWithObjectsAndKeys: [defaults objectForKey:@"phone"] ? [defaults objectForKey:@"phone"] : @"", @"phone",  [defaults objectForKey:@"token"] , @"idDevice", nil] :@selector(callBackController:):self];


}


- (void)callBackController:(NSDictionary *)dict
{

        NSError *error;
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (((NSString *)[defaults objectForKey:@"phone"]).length  != 0 && [[defaults objectForKey:@"isActivated"] isEqualToString:@"YES"])
                [self noNeedToSign];
        }

}

- (void)goBack
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
}



-(void)noNeedToSign
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];

//    [self.navigationController pushViewController:ctrl  animated:YES];
 //   [UIView transitionWithView:self.navigationController.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];

    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}



- (void)viewWillAppear:(BOOL)animated
{
  [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}

@end
