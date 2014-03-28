//
//  DashboardViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DashboardViewController : UIViewController

@property(strong) IBOutlet UIButton *mapButton;
@property(strong) IBOutlet UIButton *actuButton;
@property(strong) IBOutlet UIButton *reservationMineButton;
@property(strong) IBOutlet UIButton *accountButton;
@property(strong) IBOutlet UIButton *decotButton;
@property(strong) IBOutlet UIButton *reservationButton;

@property(strong) IBOutlet MKMapView *mapView;
@property(strong) IBOutlet UIView *actuView;
@property(strong) IBOutlet UIView *resaMineView;


@end
