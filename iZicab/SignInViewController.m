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
    
        [[ConnectionData sharedConnectionData] beginService: @"auth/log" :[[NSMutableDictionary alloc] initWithObjectsAndKeys: _phone.text, @"login",  [defaults objectForKey:@"token"] ? [defaults objectForKey:@"token"] : @"" , @"idDevice",  _password.text, @"password", @"privateUser", @"userType", nil] :@selector(callBackController:):self];
    

    [defaults setValue:_phone.text forKey:@"phone"];
     [defaults synchronize];
}


- (void)callBackController:(NSDictionary *)dict
{

        
        NSError *error;
        
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

            
        }
    
}



- (void)viewWillAppear:(BOOL)animated
{
            [self setCustomTitle:@"CONNECTION"];
    
}



@end
