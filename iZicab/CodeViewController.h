//
//  CodeViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface CodeViewController : CustomViewController

@property(strong) IBOutlet UIView *subCodeView;
@property (strong) IBOutlet UITextField *code;
@property (assign) BOOL isForgotten;


-(IBAction)activateAccount:(id)sender;

@end
