//
//  ReservationViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ReservationViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>


@property (strong)IBOutlet UIScrollView *scrollView;
@property (strong)IBOutlet UITextField *name;
@property (strong)IBOutlet UITextField *phone;
@property (strong)IBOutlet UITextField *startAddress;
@property (strong)IBOutlet UITextField *endAddress;
@property (strong)IBOutlet UISwitch    *tiers;
@property (strong)IBOutlet UIButton    *startDate;
@property (strong)IBOutlet UIButton    *passBtn;
@property (strong)IBOutlet UIButton    *luggBtn;
@property (strong)IBOutlet UIButton    *babySeat;
@property (strong)IBOutlet UIButton    *paper;
@property (strong)IBOutlet UIButton    *wifi;
@property (strong)IBOutlet UIDatePicker*datePicker;
@property (strong)         UITableView *autocompleteTableView;
@property (strong)         NSMutableArray *autocompleteUrls;
@property (assign)         BOOL isStartAddr;
@property (strong)         NSString *startAddr;
@property (strong)         NSString *endAddr;
@property (assign)         float startLat;
@property (assign)         float startLng;
@property (assign)         float endLat;
@property (assign)         float endLng;



- (IBAction)goToMap:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)more:(id)sender;
- (IBAction)less:(id)sender;
- (IBAction)setOption:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)tiersAct:(id)sender;


@end
