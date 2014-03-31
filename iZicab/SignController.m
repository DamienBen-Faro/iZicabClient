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

    [ConnectionData sendReq: @"auth/checkUserActdivated": [self checkAcc]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"phone", @"0610755306d", @"idDevice", @"ios", nil]];

}


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))checkAcc
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            [[UserInfoSingleton sharedUserInfo] setUserId:[dict objectForKey:@"id"]];
            [[UserInfoSingleton sharedUserInfo] setEmail:[dict objectForKey:@"email"]];

            if ([[UserInfoSingleton sharedUserInfo] userId].length != 0)
                [self noNeedToSign];
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
