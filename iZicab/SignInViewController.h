//
//  SignInViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate>


@property (strong) IBOutlet UITextField *phone;
@property (strong) IBOutlet UITextField *password;
@property (strong) IBOutlet UIButton *conn;

- (IBAction)connexion:(id)sender;

@end
