//
//  ReservationViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationViewController : UIViewController<UIScrollViewDelegate>


@property (strong)IBOutlet UIScrollView *scrollView;
@property (strong)IBOutlet UITextField *name;
@property (strong)IBOutlet UITextField *phone;
@property (strong)IBOutlet UITextField *startAddress;
@property (strong)IBOutlet UITextField *endAddress;
@property (strong)IBOutlet UISwitch    *tiers;
@property (strong)IBOutlet UIButton    *passBtn;
@property (strong)IBOutlet UIButton    *luggBtn;
@property (strong)IBOutlet UIButton    *babySeat;
@property (strong)IBOutlet UIButton    *paper;
@property (strong)IBOutlet UIButton    *wifi;

- (IBAction)goToMap:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)selectHour:(id)sender;
- (IBAction)more:(id)sender;
- (IBAction)less:(id)sender;
- (IBAction)setOption:(id)sender;
- (IBAction)send:(id)sender;

@end
