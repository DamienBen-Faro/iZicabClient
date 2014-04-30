//
//  ReservationViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomViewController.h"

@interface ReservationViewController : CustomViewController<UIScrollViewDelegate, CLLocationManagerDelegate, UITextViewDelegate>


@property (strong)IBOutlet UIScrollView *scrollView;
@property (strong)IBOutlet UITextField *name;
@property (strong)IBOutlet UITextField *phone;
@property (strong)IBOutlet UIButton *startAddress;
@property (strong)IBOutlet UIButton *endAddress;
@property (strong)IBOutlet UIButton    *tiers;
@property (strong)IBOutlet UIButton    *startDate;
@property (strong)IBOutlet UIButton    *passBtn;
@property (strong)IBOutlet UIButton    *luggBtn;
@property (strong)IBOutlet UIButton    *babySeat;
@property (strong)IBOutlet UIButton    *paper;
@property (strong)IBOutlet UIView      *nameView;
@property (strong)IBOutlet UITextView  *comment;
@property (strong)IBOutlet UIButton    *wifi;
@property (strong)IBOutlet NSLayoutConstraint *commentConstraint;
@property (strong)IBOutlet UIButton    *card;
@property (strong)IBOutlet UIButton    *bill;
@property (strong)         UIDatePicker*datePicker;
@property (assign)         BOOL isStartAddr;
@property (strong)         NSString *startAddr;
@property (strong)         NSString *endAddr;
@property (assign)         float startLat;
@property (assign)         float startLng;
@property (assign)         float endLat;
@property (assign)         float endLng;
@property (strong)         NSMutableArray *latLng;
@property (assign)         BOOL isResa;
@property (strong)         NSMutableDictionary *resaUpdate;
@property (strong)         UIButton *dpBtn;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) UIView *inputAccView;
@property (nonatomic, retain) UIButton *btnDone;



- (IBAction)goToMap:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)more:(id)sender;
- (IBAction)less:(id)sender;
- (IBAction)setOption:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)tiersAct:(id)sender;


@end
