//
//  ViewController.h
//  iZicab
//
//  Created by Damien  on 3/26/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h" 

@interface SignController : CustomViewController

@property (assign) BOOL fromDash;
@property (strong) IBOutlet UIButton *codeBtn;


-(void)noNeedToSign;

@end
