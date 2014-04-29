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

- (void)viewDidLoad
{
    [super viewDidLoad];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    self.password.delegate = self;
    self.phone.delegate = self;
    
    self.phone.tag = 50;
    self.password.tag = 60;
    
    self.phone.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.password.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];

        [self setCustomTitle:@"CONNEXION"];
    self.fieldArr = [[NSArray alloc] initWithObjects:
                     self.phone,  self.password,nil];
  
    
}

- (void)viewDidAppear:(BOOL)animated
{
       [self.homeButtonView removeFromSuperview];
}

-(void)createInputAccessoryView
{
    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [self.inputAccView setBackgroundColor:[UIColor whiteColor]];
    [self.inputAccView setAlpha: 0.8];
    
    
    self.btnPrev = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.btnPrev setFrame: CGRectMake(0.0, 0.0, 40.0, 40.0)];
    [self.btnPrev setBackgroundImage:[UIImage imageNamed:@"keyboardPrevious"] forState:UIControlStateNormal];
    [self.btnPrev addTarget: self action: @selector(gotoPrevTextfield) forControlEvents: UIControlEventTouchUpInside];
    
    self.btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnNext setFrame:CGRectMake(45.0f, 0.0f, 40.0f, 40.0f)];
    [self.btnNext setBackgroundImage:[UIImage imageNamed:@"keyboardNext"] forState:UIControlStateNormal];
    [self.btnNext addTarget:self action:@selector(gotoNextTextfield) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDone setFrame:CGRectMake(260.0, 0.0f, 40.0f, 40.0f)];
    [self.btnDone setBackgroundImage:[UIImage imageNamed:@"keyboardDone"] forState:UIControlStateNormal];
    [self.btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputAccView addSubview:self.btnPrev];
    [self.inputAccView addSubview:self.btnNext];
    [self.inputAccView addSubview:self.btnDone];
}




- (void)dismissKeyboard
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextView: YES:textField.tag];

    [self createInputAccessoryView];
    [textField setInputAccessoryView:self.inputAccView];
    
    self.txtActiveField = textField;

}


-(void)gotoPrevTextfield
{
    
    for (int i = 0; i < [self.fieldArr count]; i++)
    {
        if (i - 1 == 0 )
            [self.txtActiveField resignFirstResponder];
        
        if (self.txtActiveField == self.fieldArr[i])
        {
            if (i - 1 >= 0)
            {
                self.txtActiveField = self.fieldArr[i - 1];
                [self.txtActiveField becomeFirstResponder];
                break;
            }
        }
    }
    
    
}

-(void)gotoNextTextfield
{
    for (int i = 0; i < [self.fieldArr count]; i++)
    {
        if (i + 1 ==  [self.fieldArr count] )
            [self.txtActiveField resignFirstResponder];
        
        if (self.txtActiveField == self.fieldArr[i])
        {
            if (i + 1 < [self.fieldArr count])
            {
                self.txtActiveField = self.fieldArr[i + 1];
                [self.txtActiveField becomeFirstResponder];
                break;
            }
            
        }
    }
    
    
}

-(void)doneTyping
{
    
    [self.txtActiveField resignFirstResponder];
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
    const int movementDistance = tag;
    const float movementDuration = 0.3f;
    int movement= movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y + movement, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showCodeView:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    CodeViewController* pointVC = (CodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
   
    pointVC.isForgotten = YES;
    [self.navigationController pushViewController:pointVC animated:YES];

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

     [self setCustomTitle:@"CONNEXION"];

}



@end
