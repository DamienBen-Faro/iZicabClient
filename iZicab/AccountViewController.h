//
//  AccountViewController.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h" 

@interface AccountViewController : CustomViewController


@property (strong) IBOutlet UIScrollView *scrollView;
@property (strong) IBOutlet UITextField *firstName;
@property (strong) IBOutlet UITextField *familyName;
@property (strong) IBOutlet UITextField *name;
@property (strong) IBOutlet UITextField *phone;
@property (strong) IBOutlet UITextField *email;
@property (strong) IBOutlet UIButton    *passBtn;
@property (strong) IBOutlet UIButton    *luggBtn;
@property (strong) IBOutlet UIButton    *babySeat;
@property (strong) IBOutlet UIButton    *paper;
@property (strong) IBOutlet UIButton    *wifi;

@end