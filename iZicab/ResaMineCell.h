//
//  ResaMineCell.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResaMineCell : UITableViewCell


@property (strong) IBOutlet  UILabel *date;
@property (strong) IBOutlet  UILabel *hour;
@property (strong) IBOutlet  UILabel *startAddress;
@property (strong) IBOutlet  UILabel *startEndress;

@property (strong) IBOutlet  UIButton *see;
@property (strong) IBOutlet  UIButton *modif;
@property (strong) IBOutlet  UIButton *deleteResa;



@end
