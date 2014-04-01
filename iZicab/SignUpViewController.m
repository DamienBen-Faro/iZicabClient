//
//  SignUpViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "UserInfoSingleton.h"
#import "DashboardViewController.h"

@implementation SignUpViewController

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


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))checkAcc
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:_phone.text forKey:@"phone"];
            [defaults setValue:[dict objectForKey:@"data"] forKey:@"userId"];
            [defaults setValue:@"NO" forKey:@"isActivated"];
            [[UserInfoSingleton sharedUserInfo] setUserId:[dict objectForKey:@"data"]];
            [defaults synchronize];
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Vous allez recevoir un code d'enregistrement d'ici quelques secondes."
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendSubscribe:(id)sender
{
        [ConnectionData sendReq: @"account/createPrivateUser": [self checkAcc]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"login", _phone.text, @"idDevice", @"ios", @"password", _password.text, @"email", _email.text, @"name", _firstName.text, @"familyName", _familyName.text ,nil]];
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
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"SIGN UP"];
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}







@end
