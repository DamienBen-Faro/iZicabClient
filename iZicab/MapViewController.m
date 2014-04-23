//
//  MapViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "MapViewController.h"
#import "CustomNavBar.h"
#import "ReservationViewController.h"
#import "DashboardViewController.h"
#import "SearchAddressTableViewController.h"

@implementation MapViewController

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
  

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.startAddress.delegate = self;
    self.endAddress.delegate = self;
    
    self.startAddress.tag = 1001;
    self.endAddress.tag = 1002;
    self.latLng = [[NSMutableArray alloc] init];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cibleMap"]];
    
    
    float coef = 1.1833333;
    if (!IS_IPHONE_5)
        coef = 1;
    [imgV setFrame:CGRectMake(self.mapView.frame.size.width / 2 - 12 ,
                              (self.mapView.frame.size.height / 2) * coef - [UIImage imageNamed:@"cibleMap"].size.height / 2 + 16 ,
                              imgV.frame.size.width / 1.5, imgV.frame.size.height / 1.5)];
    
    [self.mapView addSubview:imgV];
    self.startAddress.font     = [UIFont fontWithName:@"Roboto-Light" size:20.0];
    self.endAddress.font     = [UIFont fontWithName:@"Roboto-Light" size:20.0];
 
    

    
    if (self.fromResa)
        [self infoFromResa];


    [self.startAddress addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.endAddress addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];

    
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    
}

- (void)textFieldBegin:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    SearchAddressTableViewController* ctrl = (SearchAddressTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchAddressTableViewController"];
    
    if ([sender tag] == 1001)
    {
        ctrl.isStartAddr = YES;
        ctrl.memoryFromReservation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.end ,@"addr",  self.endLat, @"lat",  self.endLng, @"lng" , nil];
    }
    else
        ctrl.memoryFromReservation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.start ,@"addr",  self.startLat, @"lat",  self.startLng, @"lng" , nil];
    
    ctrl.isFromMap = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}



- (void)offAll
{

    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
}




- (void)infoFromResa
{
    CLLocationCoordinate2D  ctrpointStart;
    CLLocationCoordinate2D  ctrpointEnd;
    
    self.startAddress.text = self.start;
    self.endAddress.text = self.end;
    NSLog(@"%@/%@", self.start, self.end);
        [self.mapView removeAnnotation:self.annotationFirst];
        [self.mapView removeAnnotation:self.annotationSecond];
    
    ctrpointStart.latitude = [self.startLat floatValue];
        ctrpointStart.longitude = [self.startLng floatValue];
    
        ctrpointEnd.latitude = [self.endLat floatValue];
        ctrpointEnd.longitude = [self.endLng floatValue];
    
        NSLog(@"%@/%@/%@/%@", self.startLat, self.startLng, self.endLat, self.endLng);
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *locStart = [[CLLocation alloc]initWithLatitude:ctrpointStart.latitude longitude:ctrpointStart.longitude];
    CLLocation *locEnd = [[CLLocation alloc]initWithLatitude:ctrpointEnd.latitude longitude:ctrpointEnd.longitude];
    
    UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
    [spin startAnimating];
    spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [spin startAnimating];
    [self.view addSubview:spin];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [ceo reverseGeocodeLocation: locStart completionHandler:
     ^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.startAddress.text =locatedAt;
         self.annotationFirst = [[MKPointAnnotation alloc] init];
         [self.annotationFirst setCoordinate:ctrpointStart];
         [self.annotationFirst setTitle:locatedAt];
         [self.annotationFirst setSubtitle:@"Départ"];
         [self.mapView addAnnotation:self.annotationFirst];
         
         

         
         [ceo reverseGeocodeLocation: locEnd completionHandler:
          ^(NSArray *placemarks, NSError *error) {
              CLPlacemark *placemark = [placemarks objectAtIndex:0];
              NSLog(@"placemark %@",placemark);
              //String to hold address
              NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
              self.annotationSecond = [[MKPointAnnotation alloc] init];
              [self.annotationSecond setCoordinate:ctrpointEnd];
              [self.annotationSecond setTitle:locatedAt];
              [self.annotationSecond setSubtitle:@"Arrivée"];
              
              
              [self.mapView addAnnotation:self.annotationSecond];
              self.endAddress.text =locatedAt;
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              [spin stopAnimating];
              [spin removeFromSuperview];
              [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
              
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              [spin stopAnimating];
              [spin removeFromSuperview];
              
          }
          
          ];
     }
  ];

}


- (void)backToInitialPosition:(MKUserLocation *)aUserLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    
    location.latitude = self.keepLoc.coordinate.latitude;
    location.longitude = self.keepLoc.coordinate.longitude;
    region.span = span;
    region.center = location;
    
    if (self.endLat.length > 0)
    {
        location.latitude = [self.endLat floatValue];
        location.longitude = [self.endLng floatValue];
        region.center = location;
    }
    
    if (!self.isFirstPlacement)
    {
        [self.mapView setRegion:region animated:YES];
        self.isFirstPlacement = YES;
        
        if (aUserLocation)
            self.keepLoc = aUserLocation;
        if (!self.fromResa)
        {
            self.startLat = [NSString stringWithFormat:@"%f", location.latitude ];
            self.startLng =  [NSString stringWithFormat:@"%f", location.longitude];
        }
        
    }

}


- (IBAction)goBack:(id)sender
{
    
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
    
}


- (IBAction)goToDash:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}


- (IBAction)userLoc:(id)sender
{
   self.isFirstPlacement = NO;
    [self backToInitialPosition:nil];
    
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
     [self backToInitialPosition:aUserLocation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] ;
        pinView.animatesDrop = NO;
        pinView.canShowCallout = YES;
    }
    else
    {
        pinView.annotation = annotation;
    }

   
    
    if ([[annotation subtitle]  isEqual: @"Arrivée" ])
        pinView.image = [UIImage imageNamed:@"pinMapArrive"];
    else if ([[annotation subtitle]  isEqual: @"Départ" ])
        pinView.image = [UIImage imageNamed:@"pinDepart"];
    else
        return nil;
    return pinView;



}


-(IBAction)setFirstPin:(id)sender
{
    CLLocationCoordinate2D  ctrpoint;

    ctrpoint = [self.mapView centerCoordinate];
    
    [self.mapView removeAnnotation:self.annotationFirst];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:ctrpoint.latitude longitude:ctrpoint.longitude];
    
    UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
    [spin startAnimating];
    spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [spin startAnimating];
    [self.view addSubview:spin];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error)
    {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.startAddress.text =locatedAt;
         self.annotationFirst = [[MKPointAnnotation alloc] init];
         [self.annotationFirst setCoordinate:ctrpoint];
         [self.annotationFirst setTitle:locatedAt];
         [self.annotationFirst setSubtitle:@"Départ"];
         [self.mapView addAnnotation:self.annotationFirst];
     

        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [spin stopAnimating];
        [spin removeFromSuperview];
         [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
        
        
     }
     
     ];
}


-(IBAction)setSecondPin:(id)sender
{
    CLLocationCoordinate2D  ctrpoint;


    ctrpoint = [self.mapView centerCoordinate];
    if(ctrpoint.latitude <= 0.000000)
    {
        CLLocationCoordinate2D coo;
        coo.latitude = 48.8566140;
        coo.longitude = 2.3522219;
        [self.mapView setCenterCoordinate:coo];

    }
    
    [self.mapView removeAnnotation:self.annotationSecond];
    
    
    UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
    [spin startAnimating];
    spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [spin startAnimating];
    [self.view addSubview:spin];


    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:ctrpoint.latitude longitude:ctrpoint.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.annotationSecond = [[MKPointAnnotation alloc] init];
         [self.annotationSecond setCoordinate:ctrpoint];
         [self.annotationSecond setTitle:locatedAt];
         [self.annotationSecond setSubtitle:@"Arrivée"];

         
         [self.mapView addAnnotation:self.annotationSecond];
         
      
         
         self.endAddress.text =locatedAt;
         if (self.annotationSecond)
         [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];

         [spin stopAnimating];
         [spin removeFromSuperview];
         [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
         

         
     }
     
     ];
    
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        MKAnnotationView* anView = [self.mapView viewForAnnotation: annotation];
        if (anView && [[annotation subtitle]  isEqual: @"Arrivée" ])
        {
            anView.image = [UIImage imageNamed:@"pinMapArrive"];
        }
    }
}

- (void) getLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        return;
    }
    
    // if locationManager does not currently exist, create it.
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        self.locationManager.distanceFilter = 10.0f; //we don't need to be any more accurate than 10m
    }
    
    [self.locationManager startUpdatingLocation];
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:   (CLLocation*)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    if (!self.fromResa && self.startAddress.text.length == 0)
    {
    NSString * tLatitude  = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.latitude];
    NSString * tLongitude = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.longitude];
    
        UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
        [spin startAnimating];
        spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
        [spin startAnimating];
        [self.view addSubview:spin];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for(CLPlacemark *curString in placemarks)
         {
             
                 [self.mapView removeAnnotation:self.annotationFirst];
             [self.mapView removeAnnotation:self.annotationSecond];
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             self.startAddress.text =locatedAt;
             self.annotationFirst = [[MKPointAnnotation alloc] init];
             [self.annotationFirst setCoordinate:newLocation.coordinate];
             [self.annotationFirst setTitle:locatedAt];
             [self.annotationFirst setSubtitle:@"Départ"];
             [self.mapView addAnnotation:self.annotationFirst];
             
             
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             [spin stopAnimating];
             [spin removeFromSuperview];

             
             self.startAddress.text = [[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             self.start = self.startAddress.text;
             self.startLat = tLatitude;
             self.startLng = tLongitude;
             
         }

         
         
         MKCoordinateRegion region;
         MKCoordinateSpan span;
         span.latitudeDelta = 0.005;
         span.longitudeDelta = 0.005;
         CLLocationCoordinate2D location;
         region.span = span;
         region.center = location;
         
         if (self.endLat.length > 0)
         {
             location.latitude = [self.endLat floatValue];
             location.longitude = [self.endLng floatValue];
             region.center = location;
            [self.mapView setRegion:region animated:YES];
         }

         
         
     }];
    }
}


- (void)traceRoute:(CLLocationCoordinate2D)southWest:(CLLocationCoordinate2D)northEast
{
    MKPlacemark *source = [[MKPlacemark alloc] initWithCoordinate:southWest addressDictionary:nil ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:northEast addressDictionary:nil];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler: ^(MKDirectionsResponse *response, NSError *error)
     {
         NSLog(@"response = %@",response);
         NSArray *arrRoutes = [response routes];
         [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             MKRoute *rout = obj;
             
              [self.mapView removeOverlay:self.line];
             _line = [rout polyline];
             [self.mapView addOverlay:_line];
             NSLog(@"Rout Name : %@",rout.name);
             NSLog(@"Total Distance (in Meters) :%f",rout.distance);
             
             NSArray *steps = [rout steps];
             
             NSLog(@"Total Steps : %d",[steps count]);
             
             [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 NSLog(@"Rout Instruction : %@",[obj instructions]);
                 NSLog(@"Rout Distance : %f",[obj distance]);
             }];
         }];
     }];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{

    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {

        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay];
        aView.strokeColor = [[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1] colorWithAlphaComponent:1];
        aView.lineWidth = 10;
        return aView;
    }

    return nil;
}





-(IBAction)sendResa:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ReservationViewController* ctrl = (ReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
    ctrl.startLat = self.annotationFirst.coordinate.latitude;
    ctrl.startLng = self.annotationFirst.coordinate.longitude;
    ctrl.endLat = self.annotationSecond.coordinate.latitude;
    ctrl.endLng = self.annotationSecond.coordinate.longitude;
    ctrl.startAddr = self.startAddress.text;
    ctrl.endAddr = self.endAddress.text;


    [self.navigationController pushViewController:ctrl animated:YES];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];

}



- (void)viewWillAppear:(BOOL)animated
{
    

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self getLocation];
    self.isFirstPlacement = NO;
    
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
      [self performSelector:@selector(setSecondPin:) withObject:nil afterDelay:1.0];
}


@end
