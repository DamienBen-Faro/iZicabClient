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
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.firstName.delegate = self;
    self.phone.delegate = self;
    self.familyName.delegate = self;
    self.password.delegate = self;
      self.passwordConfirm.delegate = self;
    self.email.delegate = self;
    
    self.familyName.tag = 40;
    self.firstName.tag = 60;
    self.phone.tag = 70;
    self.email.tag = 100;
    self.password.tag = 130;
        self.passwordConfirm.tag = 160;
    
    self.familyName.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.firstName.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.phone.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.email.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
        self.password.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
       self.passwordConfirm.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];

    
    self.fieldArr = [[NSArray alloc] initWithObjects:
                      self.familyName,  self.firstName, self.phone, self.email, self.password, self.passwordConfirm,nil];
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.homeButtonView removeFromSuperview];
}

-(void)createInputAccessoryView
{
     self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [self.inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    [self.inputAccView setAlpha: 0.8];
    
    
    self.btnPrev = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.btnPrev setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    [self.btnPrev setTitle: @"Previous" forState: UIControlStateNormal];
    [self.btnPrev setBackgroundColor: [UIColor blueColor]];
    [self.btnPrev addTarget: self action: @selector(gotoPrevTextfield) forControlEvents: UIControlEventTouchUpInside];
    
    self.btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnNext setFrame:CGRectMake(85.0f, 0.0f, 80.0f, 40.0f)];
    [self.btnNext setTitle:@"Next" forState:UIControlStateNormal];
    [self.btnNext setBackgroundColor:[UIColor blueColor]];
    [self.btnNext addTarget:self action:@selector(gotoNextTextfield) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [self.btnDone setBackgroundColor:[UIColor greenColor]];
    [self.btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputAccView addSubview:self.btnPrev];
    [self.inputAccView addSubview:self.btnNext];
    [self.inputAccView addSubview:self.btnDone];
}




- (void)dismissKeyboard {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self createInputAccessoryView];
    
    [textField setInputAccessoryView:self.inputAccView];
    
    self.txtActiveField = textField;
    [self animateTextView: YES:textField.tag];
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
        if (i + 1 == [self.fieldArr count] )
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
    if ([self.password.text isEqualToString:self.passwordConfirm.text])
    {
    [[ConnectionData sharedConnectionData] beginService: @"account/createPrivateUser": [[NSMutableDictionary alloc] initWithObjectsAndKeys:_phone.text, @"login" , @"ios" ,@"idDevice", _password.text, @"password", _email.text, @"email", _firstName.text,  @"name", _familyName.text,  @"familyName" ,nil] :@selector(callBackController:):self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"Mot de passe et confirmation différent."
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
        [self setCustomTitle:@"INSCRIPTION"];
    
    
}






@end
