//
//  ActuViewController.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h" 

@interface ActuViewController : CustomViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong) IBOutlet UITableView *tableView;
@property(strong) NSMutableArray *arr;
@property(strong) UIActivityIndicatorView *spin;

@end
