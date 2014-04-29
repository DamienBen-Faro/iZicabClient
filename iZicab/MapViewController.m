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
#import "ConnectionData.h"

@implementation MapViewController

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];


    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    
    self.address.tag = 1001;
    if (self.isStart)
    self.address.tag = 1002;
    self.latLng = [[NSMutableArray alloc] init];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cibleMap"]];
    
    
    float coef = 1.1833333;
    if (!IS_IPHONE_5)
        coef = 1;
    [imgV setFrame:CGRectMake(self.mapView.frame.size.width / 2 - 12 ,
                              (self.mapView.frame.size.height / 2) * coef - [UIImage imageNamed:@"cibleMap"].size.height / 2 + 16 ,
                              imgV.frame.size.width / 1.5, imgV.frame.size.height / 1.5)];
    
    [self.mapView addSubview:imgV];
    self.address.font     = [UIFont fontWithName:@"Roboto-Light" size:20.0];

    if (self.fromResa)
        [self infoFromResa];


    [self.address addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];

    self.address.font = [UIFont fontWithName:@"Roboto-Thin" size:16.0];

    
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

    [self.address resignFirstResponder];

}




- (void)infoFromResa
{
    self.isFirstPlacement = YES;
    CLLocationCoordinate2D  ctrpointStart;
    [self.mapView removeAnnotation:self.annotationFirst];

    self.address.text = self.end;
    ctrpointStart.latitude = [self.endLat floatValue];
    ctrpointStart.longitude = [self.endLng floatValue];

    
    if (self.isStart)
    {
        [self.pinBtn setBackgroundImage:[UIImage imageNamed:@"mapStart@2x.png"] forState:UIControlStateNormal];
        self.address.text = self.start;
        ctrpointStart.latitude = [self.startLat floatValue];
        ctrpointStart.longitude = [self.startLng floatValue];

    }


    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *locStart = [[CLLocation alloc]initWithLatitude:ctrpointStart.latitude longitude:ctrpointStart.longitude];
    
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
         self.address.text = locatedAt;
         self.annotationFirst = [[MKPointAnnotation alloc] init];
         [self.annotationFirst setCoordinate:ctrpointStart];
         [self.annotationFirst setTitle:locatedAt];
         [self.annotationFirst setSubtitle:@"Départ"];
         [self.mapView addAnnotation:self.annotationFirst];

         MKCoordinateRegion region;
         MKCoordinateSpan span;
         span.latitudeDelta = 0.005;
         span.longitudeDelta = 0.005;
         
         region.span = span;
         region.center = ctrpointStart;
              [self.mapView setRegion:region animated:YES];
         
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         [spin stopAnimating];
         [spin removeFromSuperview];
     }
  ];

}


- (void)backToInitialPosition:(MKUserLocation *)aUserLocation
{
    if (aUserLocation)
        self.keepLoc = aUserLocation;
    
    if (!self.isFirstPlacement)
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
    

    
   
        [self.mapView setRegion:region animated:YES];
        self.isFirstPlacement = YES;
        
      
        if (!self.fromResa)
        {
           
            self.endLat = [NSString stringWithFormat:@"%f", location.latitude ];
            self.endLng =  [NSString stringWithFormat:@"%f", location.longitude];

             {
                 self.startLat = [NSString stringWithFormat:@"%f", location.latitude ];
                 self.endLng =  [NSString stringWithFormat:@"%f", location.longitude];
                 
             }
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

   
    
    if ([[annotation subtitle]  isEqual: @"Arrivée" ] || [[annotation subtitle]  isEqual: @"Départ" ])
        pinView.image = [UIImage imageNamed:@"pinMapArrive"];
    //else if ([[annotation subtitle]  isEqual: @"Départ" ])
     //   pinView.image = [UIImage imageNamed:@"pinDepart"];
    else
        return nil;
    return pinView;



}

- (void) putVTC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[ConnectionData sharedConnectionData] beginService: @"map/getRefresh":[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                          [defaults  objectForKey:@"userId"], @"userId",
                                                                                          [NSString stringWithFormat:@"%f", self.keepLoc.coordinate.latitude],  @"lat",
                                                                                         [NSString stringWithFormat:@"%f", self.keepLoc.coordinate.longitude],  @"lng"
                                                                                          ,nil] :@selector(callBackController:):self];

}


- (void)callBackController:(NSDictionary *)dict
{
    
    NSError *error;
    
    if (error == nil && [[dict objectForKey:@"error"] length] == 0)
    {
         NSString *tmpName = nil;
       
     if(dict[@"data"]
        &&  [dict[@"data"] isKindOfClass:[NSDictionary class]]
        && dict[@"data"][@"dataProvider"]
        && [dict[@"data"][@"dataProvider"] isKindOfClass:[NSArray class]])
     {
     
         
         for (id<MKAnnotation> annotation in self.mapView.annotations)
         {
             MKAnnotationView* anView = [self.mapView viewForAnnotation: annotation];
             if (anView && [[annotation subtitle]  isEqual: @"Chauffeur" ])
                 [self.mapView removeAnnotation:annotation];
         }
        
         
         for (NSDictionary *dic in dict[@"data"][@"dataProvider"])
         {
             CLLocationCoordinate2D  ctrpoint;
             ctrpoint.latitude = [dic[@"lat"] floatValue];
             ctrpoint.longitude = [dic[@"lng"] floatValue];
             
              MKPointAnnotation* anP = [[MKPointAnnotation alloc] init];
             [anP setCoordinate:ctrpoint];
             [anP setTitle: [NSString stringWithFormat:@"%@ %@ %@ ", dic[@"type"], dic[@"brand"], dic[@"model"] ]];
             [anP setSubtitle:dic[@"familyName"]];
             tmpName = dic[@"familyName"];
             [self.mapView addAnnotation:anP];
             
            }
   
        }

       
      
        for (id<MKAnnotation> annotation in self.mapView.annotations)
        {
            MKAnnotationView* anView = [self.mapView viewForAnnotation: annotation];
           
            if (anView && tmpName && [[annotation subtitle] isEqualToString:tmpName ])
                anView.image = [UIImage imageNamed:@"pinChauffeurOn"];
         }
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self sendResa:nil];
}


-(IBAction)setFirstPin:(id)sender
{
    CLLocationCoordinate2D  ctrpoint;
    

    ctrpoint = [self.mapView centerCoordinate];
    if(ctrpoint.latitude <= 0)
    {
        ctrpoint = self.mapView.userLocation.coordinate;
        [self.mapView setCenterCoordinate:ctrpoint];
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%f",  self.mapView.userLocation.coordinate.latitude] forKey:@"lat"];
    [defaults setObject:[NSString stringWithFormat:@"%f",  self.mapView.userLocation.coordinate.longitude] forKey:@"lng"];

    [self.mapView removeAnnotation:self.annotationFirst];
    for (id<MKAnnotation> annotation in self.mapView.annotations)
            [self.mapView removeAnnotation:annotation];
    
    
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
         self.annotationFirst = [[MKPointAnnotation alloc] init];
         [self.annotationFirst setCoordinate:ctrpoint];
         [self.annotationFirst setTitle:locatedAt];
         
         if (self.isStart)
         [self.annotationFirst setSubtitle:@"Départ"];
             else
         [self.annotationFirst setSubtitle:@"Arrivée"];
         
         
         [self.mapView addAnnotation:self.annotationFirst];
         
         
         
         self.address.text =locatedAt;
      /*   if (self.annotationSecond)
             [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
       */
         [spin stopAnimating];
         [spin removeFromSuperview];
         //[self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
       
         
         
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
    
    if (!self.fromResa && self.address.text.length == 0)
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
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             self.address.text =locatedAt;
             self.annotationFirst = [[MKPointAnnotation alloc] init];
             [self.annotationFirst setCoordinate:newLocation.coordinate];
             [self.annotationFirst setTitle:locatedAt];
             [self.annotationFirst setSubtitle:@"Départ"];
             [self.mapView addAnnotation:self.annotationFirst];
             
             
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             [spin stopAnimating];
             [spin removeFromSuperview];

             
            self.address.text = [[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             self.start = self.address.text;
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
    

    ctrl.endLat = self.annotationFirst.coordinate.latitude;
    ctrl.endLng = self.annotationFirst.coordinate.longitude;
    ctrl.startLat = [self.startLat floatValue];
    ctrl.startLng = [self.startLng floatValue];
    ctrl.endAddr = self.address.text;
    ctrl.startAddr = self.start;

    
    if (self.isStart)
    {
        
        ctrl.startLat = self.annotationFirst.coordinate.latitude;
        ctrl.startLng = self.annotationFirst.coordinate.longitude;
        ctrl.endLat = [self.endLat floatValue];
        ctrl.endLng = [self.endLng floatValue];
        ctrl.startAddr = self.address.text;
        ctrl.endAddr = self.end;
        
        
       }
    
    [self.navigationController pushViewController:ctrl animated:YES];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.address resignFirstResponder];

}



- (void)viewWillAppear:(BOOL)animated
{
    

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self getLocation];
    if (self.fromResa)
        self.isFirstPlacement = YES;
    else
      [self performSelector:@selector(userLoc:) withObject:nil afterDelay:2.0];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.fromResa)
     self.isFirstPlacement = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
              [self putVTC];
      [self performSelector:@selector(setFirstPin:) withObject:nil afterDelay:0.0];
}


@end
