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
   //   [ConnectionData sendReq: @"auth/log": [self checkCo]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"login", @"0610755306", @"idDevice", @"ios", @"password",  @"izicab", @"userType", @"privateUser", nil]];

    
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
    [ConnectionData sendReq: @"auth/log": [self checkCo]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"login", @"0610755306", @"idDevice", @"ios", @"password",  @"izicab", @"userType", @"privateUser", nil]];
}


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))checkCo
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            
            
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
