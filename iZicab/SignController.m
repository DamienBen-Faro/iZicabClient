//
//  ViewController.m
//  iZicab
//
//  Created by Damien  on 3/26/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SignController.h"
#import "DashboardViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "UserInfoSingleton.h"

@implementation SignController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    [ConnectionData sendReq: @"auth/checkUserActivated": [self checkAcc]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"phone", [defaults objectForKey:@"phone"] ? [defaults objectForKey:@"phone"] : @"", @"idDevice", @"ios", nil]];

}


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))checkAcc
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (((NSString *)[defaults objectForKey:@"phone"]).length  != 0 && [[defaults objectForKey:@"isActivated"] isEqualToString:@"YES"])
                [self noNeedToSign];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
         /*   if ([dict objectForKey:@"error"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
                [self.navigationController pushViewController:ctrl animated:YES];
            }*/
        }

    };
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)noNeedToSign
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{

    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"IZICAB"];
    
}

@end
