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
    [ConnectionData sendReq: @"auth/log": [self checkCo]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"login", _phone.text, @"idDevice", @"ios", @"password",  _password.text, @"userType", @"privateUser", nil]];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
            [[UserInfoSingleton sharedUserInfo] setUserId:[dict objectForKey:@"id"]];
            [[UserInfoSingleton sharedUserInfo] setEmail:[dict objectForKey:@"email"]];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[dict objectForKey:@"id"] forKey:@"userId"];
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
    UIImage *backBtnImage = [UIImage imageNamed:@"buttonBack"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 97, 15);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"SIGN IN"];
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
