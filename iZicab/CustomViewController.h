//
//  CustomViewController.h
//  iZicab
//
//  Created by Damien  on 4/23/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomViewController : UIViewController

@property (strong)   UIView *homeButtonView ;

- (void)setCustomTitle:(NSString *)string;
- (void)goBack;
- (void) goToDash;

@end
