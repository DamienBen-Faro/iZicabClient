//
//  AccountViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "AccountViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"

@implementation AccountViewController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.name.text = [defaults objectForKey:@"userName"];
    self.phone.text = [defaults objectForKey:@"phone"];
    self.email.text = [defaults objectForKey:@"email"];
    
    self.passBtn.titleLabel.text = [defaults objectForKey:@"passBtn"] ?  [defaults objectForKey:@"passBtn"] : @"1";
    self.luggBtn.titleLabel.text = [defaults objectForKey:@"luggBtn"] ?  [defaults objectForKey:@"luggBtn"] : @"1";
    
    self.babySeat.selected = [[defaults objectForKey:@"babySeat"] boolValue] ?  [[defaults objectForKey:@"babySeat"] boolValue]: NO;
    self.paper.selected = [[defaults objectForKey:@"paper"] boolValue] ?  [[defaults objectForKey:@"paper"] boolValue]: NO;
    self.wifi.selected = [[defaults objectForKey:@"wifi"] boolValue] ?  [[defaults objectForKey:@"wifi"] boolValue]: NO;
    
    
    //UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    //[self.view addGestureRecognizer:dismissKeyboard];
}

- (void)dismissKeyboard
{
    /*[self.email resignFirstResponder];
    [self.familyName resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.firstName resignFirstResponder];*/
}


- (void)goBack
{
              [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
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
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"ACCOUNT"];
    
    
    [self setLeftV:self.name :@"perso"];
    [self setLeftV:self.phone :@"phone"];
    [self setLeftV:self.email :@"mailAcc"];

    
}

- (void)setLeftV: (UITextField *)textF
                :(NSString *)imgName
{
    
    textF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    textF.leftView.frame = CGRectMake(0, 0, 60, 40);
    textF.leftViewMode = UITextFieldViewModeAlways;
}


- (IBAction)more:(id)sender
{
    if ([sender tag] == 7878)
    {
        int i =  [((NSString *)self.passBtn.titleLabel.text) intValue];
        if (i < 8)
            i++;
        [self.passBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
    else
    {
        int i =  [((NSString *)self.luggBtn.titleLabel.text) intValue];
        if (i < 8)
            i++;
        [self.luggBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
}

- (IBAction)less:(id)sender
{
    if ([sender tag] == 7878)
    {
        int i =  [((NSString *)self.passBtn.titleLabel.text) intValue];
        if (i > 1)
            i--;
        [self.passBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
    else
    {
        int i =  [((NSString *)self.luggBtn.titleLabel.text) intValue];
        if (i > 1)
            i--;
        [self.luggBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
    
}


- (IBAction)setOption:(id)sender
{
    if (((UIButton *)sender).selected)
        ((UIButton *)sender).selected = NO;
    else
        ((UIButton *)sender).selected = YES;
}


- (IBAction)save:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:self.passBtn.titleLabel.text forKey:@"passBtn"];
    [defaults setValue:self.luggBtn.titleLabel.text forKey:@"luggBtn"];
    
    [defaults setValue:[NSString stringWithFormat:@"%i",self.babySeat.selected] forKey:@"babySeat"];
    [defaults setValue:[NSString stringWithFormat:@"%i",self.paper.selected] forKey:@"paper"];
    [defaults setValue:[NSString stringWithFormat:@"%i",self.wifi.selected] forKey:@"wifi"];
    [defaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"Options sauvegardée"
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
