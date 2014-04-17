//
//  ResaMineViewController.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResaMineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (strong) NSMutableArray *arr;
@property (strong) IBOutlet UITableView *tableView;
@property (assign) int idToDelete;
@property (strong) UISegmentedControl *segment;
@property (strong) IBOutlet UIView *whiteV;

@end
