//
//  SignInViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h" 

@interface SignInViewController : CustomViewController<UITextFieldDelegate>


@property (strong) IBOutlet UITextField *phone;
@property (strong) IBOutlet UITextField *password;
@property (strong) IBOutlet UIButton *conn;


@property (nonatomic, retain) UIView *inputAccView;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnPrev;
@property (nonatomic, retain) UITextField *txtActiveField;
@property (strong) NSArray *fieldArr;

- (IBAction)connexion:(id)sender;

@end
