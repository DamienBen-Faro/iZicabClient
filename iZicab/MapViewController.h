//
//  MapViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>


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

//from resa
@property (strong) NSString *start;
@property (strong) NSString *end;
@property (strong) NSString  *latStartCo;
@property (strong) NSString  *lngStartCo;
@property (strong) NSString  *latEndCo;
@property (strong) NSString  *lngEndCo;
@property (assign) BOOL       fromResa;


@end
