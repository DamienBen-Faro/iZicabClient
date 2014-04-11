//
//  MapViewController.h
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>


@property (strong)IBOutlet MKMapView *mapView;
@property (strong) MKPointAnnotation *annotationFirst;
@property (strong) MKPointAnnotation *annotationSecond;
@property (strong)IBOutlet UILabel *startAddress;
@property (strong)IBOutlet UILabel *endAddress;
@property (assign)BOOL      isFirstPlacement;
@property (strong)MKPolyline *line;

//from resa
@property (strong) NSString *start;
@property (strong) NSString *end;
@property (strong) NSString  *latStartCo;
@property (strong) NSString  *lngStartCo;
@property (strong) NSString  *latEndCo;
@property (strong) NSString  *lngEndCo;
@property (assign) BOOL       fromResa;
@end
