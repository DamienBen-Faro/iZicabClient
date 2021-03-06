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
#import "CodeViewController.h"

@implementation SignController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[ConnectionData sharedConnectionData] beginService: @"auth/checkUserActivated" :[[NSMutableDictionary alloc] initWithObjectsAndKeys: [defaults objectForKey:@"phone"] ? [defaults objectForKey:@"phone"] : @"", @"phone",  [defaults objectForKey:@"token"] , @"idDevice", nil] :@selector(callBackController:):self];

    self.codeBtn.hidden = YES;
}


- (void)callBackController:(NSDictionary *)dict
{

        NSError *error;
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
          
            if (((NSString *)[defaults objectForKey:@"phone"]).length  != 0 && [[defaults objectForKey:@"isActivated"] isEqualToString:@"YES"] && !self.fromDash)
                [self noNeedToSign];
        }
    else
    {
        
        self.codeBtn.hidden = NO;
        static BOOL wasLoaded = NO;
        
        if ([defaults objectForKey:@"userId"] && ![defaults objectForKey:@"deco"] && !wasLoaded)
            [self goToCodeView:nil];
        wasLoaded = YES;
      
    }

}

- (IBAction)goToCodeView:(id)sender
{
    self.codeBtn.hidden = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    CodeViewController* ctrl = (CodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];

}


-(void)noNeedToSign
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];

//    [self.navigationController pushViewController:ctrl  animated:YES];
 //   [UIView transitionWithView:self.navigationController.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];

        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
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
