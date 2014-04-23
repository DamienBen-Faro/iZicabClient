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
#import "CodeViewController.h"

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
    self.firstName.delegate = self;
    self.phone.delegate = self;
    self.familyName.delegate = self;
    self.password.delegate = self;
    self.email.delegate = self;
    
    self.familyName.tag = 60;
    self.firstName.tag = 80;
    self.phone.tag = 90;
    self.email.tag = 120;
    self.password.tag = 160;
    
    self.familyName.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.firstName.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.phone.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.email.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.password.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
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




- (void)callBackController:(NSDictionary *)dict
{
        NSError *error;
        
        
        NSLog(@"%@", dict);
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:_phone.text forKey:@"phone"];
            [defaults setValue:_email.text forKey:@"email"];
            [defaults setValue:[NSString stringWithFormat:@"%@ %@", _familyName.text , _firstName.text ] forKey:@"userName"];
            
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
            CodeViewController* ctrl = (CodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendSubscribe:(id)sender
{
    
    [[ConnectionData sharedConnectionData] beginService: @"account/createPrivateUser": [[NSMutableDictionary alloc] initWithObjectsAndKeys:_phone.text, @"login" , @"ios" ,@"idDevice", _password.text, @"password", _email.text, @"email", _firstName.text,  @"name", _familyName.text,  @"familyName" ,nil] :@selector(callBackController:):self];

}

- (void)viewWillAppear:(BOOL)animated
{
        [self setCustomTitle:@"INSCRIPTION"];
    
    
}






@end
