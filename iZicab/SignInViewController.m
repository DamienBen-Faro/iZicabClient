//
//  SignInViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SignInViewController.h"
#import "CodeViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"
#import "ConnectionData.h"
#import "UserInfoSingleton.h"

@implementation SignInViewController

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
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    self.password.delegate = self;
    self.phone.delegate = self;
    
    self.phone.tag = 50;
    self.password.tag = 60;
    
    self.phone.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.password.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
}

- (void)dismissKeyboard {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: YES:textView.tag];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO :textView.tag];
}

- (void) animateTextView:(BOOL) up: (int)tag
{
    
    const int movementDistance = tag; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y + movement, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (void)viewDidAppear:(BOOL)animated
{
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showCodeView:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    CodeViewController* pointVC = (CodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
    

    [self.view addSubview:pointVC.view];
    [pointVC didMoveToParentViewController:self];

}



- (IBAction)connexion:(id)sender
{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [ConnectionData sendReq: @"auth/log": [self checkCo]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys: _phone.text, @"login",  [defaults objectForKey:@"token"] , @"idDevice",  _password.text, @"password", @"privateUser", @"userType", nil]];
    
    
    

    [defaults setValue:_phone.text forKey:@"phone"];
     [defaults synchronize];
}


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))checkCo
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            dict = [dict objectForKey:@"data"];
            [[UserInfoSingleton sharedUserInfo] setUserId:[dict objectForKey:@"id"]];
            [[UserInfoSingleton sharedUserInfo] setEmail:[dict objectForKey:@"email"]];
            [[UserInfoSingleton sharedUserInfo] setName:[dict objectForKey:@"name"]];
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[dict objectForKey:@"id"] forKey:@"userId"];
            [defaults setValue:[dict objectForKey:@"name"] forKey:@"userName"];
            [defaults setValue:[dict objectForKey:@"email"] forKey:@"email"];
            [defaults setValue:@"YES" forKey:@"isActivated"];
            [defaults synchronize];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:ctrl animated:YES];

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            NSString* dataStr = [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
            NSLog(@"%@", dataStr);
            
        }
    };
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

	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"SIGN IN"];
    
    
    
    
    
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

@end
