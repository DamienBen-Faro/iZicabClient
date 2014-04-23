//
//  ActuDetailViewController.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface ActuDetailViewController : CustomViewController

@property(strong) NSDictionary *arr;
@property (strong) IBOutlet UITextView *textView;
@property (strong) IBOutlet UILabel *date;
@property (strong) IBOutlet UILabel *hour;
@property (strong) IBOutlet UIImageView *img;
@end
