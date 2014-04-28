//
//  MapViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomViewController.h"

@interface MapViewController : CustomViewController<MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>


@property (strong)IBOutlet  MKMapView *mapView;
@property (strong)          MKPointAnnotation *annotationFirst;
@property (strong)          MKPointAnnotation *annotationSecond;
@property (strong)IBOutlet  UITextField *address;
@property (strong)IBOutlet  UIView *addrView;
@property (strong)IBOutlet  UIButton *pinBtn;
@property (assign)          BOOL      isFirstPlacement;
@property (strong)          MKPolyline *line;


@property (strong)          NSMutableArray *autocompleteUrls;
@property (assign)          BOOL isStartAddr;
@property (strong)          NSMutableArray *latLng;
@property (assign)          CLLocationCoordinate2D userLocation;
@property (strong)          CLLocationManager   *locationManager;
@property (strong)          MKUserLocation *keepLoc;

//from resa
@property (strong)          NSString *start;
@property (strong)          NSString *end;
@property (strong)          NSString  *startLng;
@property (strong)          NSString  *startLat;
@property (strong)          NSString  *endLat;
@property (strong)          NSString  *endLng;
@property (assign)          BOOL       fromResa;
@property (assign)          BOOL       isStart;

@end
