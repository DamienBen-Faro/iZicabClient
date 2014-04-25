//
//  NavigationControlViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NavigationControlViewController : UINavigationController

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (strong) UILabel *alertModalView;
@property (strong) UILabel *notifModalView;

- (void)setNotifModal;

@end
