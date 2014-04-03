//
//  InvoiceViewController.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationViewController.h"


@interface InvoiceViewController : UIViewController
{}

@property (nonatomic, strong) ReservationViewController *resaCtrl;

@property (strong) IBOutlet UILabel*date;
@property (strong) IBOutlet UILabel*start;
@property (strong) IBOutlet UILabel*end;
@property (strong) IBOutlet UILabel*wifi;
@property (strong) IBOutlet UILabel*baby;
@property (strong) IBOutlet UILabel*passenger;
@property (strong) IBOutlet UILabel*paper;
@property (strong) IBOutlet UILabel*luggage;
@property (strong) IBOutlet UILabel*price;
@property (strong) IBOutlet UIButton*standard;
@property (strong) IBOutlet UIButton*premium;


@end
