//
//  CodeViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "CodeViewController.h"
#import "DashboardViewController.h"
#import "ConnectionData.h"
#import "SignController.h"

@implementation CodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
    if (self.isForgotten)
        self.code.placeholder = @"Teléphone";
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offAll:)];
    tapGestureRecognize.numberOfTapsRequired = 1;

    [self.view addGestureRecognizer:tapGestureRecognize];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)callBackController:(NSDictionary *)dict
{
    
        NSError *error;
        
        
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:@"YES" forKey:@"isActivated"];
            [defaults synchronize];
            
            NSString *tmp = @"Compte créé";
            if (self.isForgotten)
                tmp = @"Vous allez recevoir un e-mail afin de recréer un nouveau mot de passe, si il n'apparait pas pensez à verifier les spams.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:tmp
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            if (self.isForgotten)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                SignController* ctrl = (SignController *)[storyboard instantiateViewControllerWithIdentifier:@"SignController"];
                [self.navigationController pushViewController:ctrl animated:YES];
                
            }
                else
                {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                        DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                        [self.navigationController pushViewController:ctrl animated:YES];
                }
            
            
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


-(IBAction)activateAccount:(id)sender
{
    if (self.isForgotten)
    {
        
             [[ConnectionData sharedConnectionData] beginService: @"account/passwordForgotten":  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _code.text , @"phone",nil] :@selector(callBackController:):self];
        

    }
    else
    {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
     [[ConnectionData sharedConnectionData] beginService: @"account/activePrivateUser":  [[NSMutableDictionary alloc] initWithObjectsAndKeys: [defaults objectForKey:@"userId"], @"userId", _code.text , @"code",nil] :@selector(callBackController:):self];
    }
}


- (IBAction)offAll:(id)sender
{
    [self.code resignFirstResponder];
}




@end
