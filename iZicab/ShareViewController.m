//
//  ShareViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ShareViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"

@implementation ShareViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}


- (void) goToDash
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}

- (void)goBack
{
              [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton@2x.png"];
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"backButton@2x.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [backButtonView setFrame:CGRectMake(0, 20, 50, 70)];//25, 75
    [backButtonView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeBtnImage = [UIImage imageNamed:@"menuButton@2X.png"];
    UIImage *homeBtnImagePressed = [UIImage imageNamed:@"menuButton@2X.png"];
    [homeBtn setBackgroundImage:homeBtnImage forState:UIControlStateNormal];
    [homeBtn setBackgroundImage:homeBtnImagePressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(goToDash) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *homeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [homeButtonView setFrame:CGRectMake(270, 20, 50, 70)];//25, 75
    [homeButtonView addSubview:homeBtn];
    
    
    
    
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
        navigationBar.isDash = YES;
    [navigationBar addSubview:backButtonView];
    [navigationBar addSubview:homeButtonView];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"PARTAGER"];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
