//
//  MapViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


@property (strong)IBOutlet MKMapView *mapView;
@property (strong) MKPointAnnotation *annotationFirst;
@property (strong) MKPointAnnotation *annotationSecond;
@property (strong)IBOutlet UITextField *startAddress;
@property (strong)IBOutlet UITextField *endAddress;
@property (strong)IBOutlet UIView *addrView;
@property (strong) UITableView *autocompleteTableView;
@property (assign)BOOL      isFirstPlacement;
@property (strong)MKPolyline *line;


@property (strong)         NSMutableArray *autocompleteUrls;
@property (assign)         BOOL isStartAddr;
@property (strong)         NSMutableArray *latLng;
@property (assign)          CLLocationCoordinate2D userLocation;
@property (strong)                  CLLocationManager   *locationManager;

//from resa
@property (strong) NSString *start;
@property (strong) NSString *end;
@property (strong) NSString  *startLng;
@property (strong) NSString  *startLat;
@property (strong) NSString  *endLat;
@property (strong) NSString  *endLng;
@property (assign) BOOL       fromResa;


@end
