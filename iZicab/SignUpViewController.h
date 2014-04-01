//
//  SignUpViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (strong) IBOutlet UITextField *familyName;
@property (strong) IBOutlet UITextField *firstName;
@property (strong) IBOutlet UITextField *phone;
@property (strong) IBOutlet UITextField *email;
@property (strong) IBOutlet UITextField *password;

- (IBAction)sendSubscribe:(id)sender;

@end
