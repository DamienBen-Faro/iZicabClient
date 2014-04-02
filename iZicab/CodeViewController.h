//
//  CodeViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeViewController : UIViewController

@property(strong) IBOutlet UIView *subCodeView;
@property (strong) IBOutlet UITextField *code;

-(IBAction)activateAccount:(id)sender;

@end
