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

@implementation MapViewController

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
  

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinDepart"]];
    NSLog(@"%f/%f", self.mapView.frame.size.width / 2 , self.mapView.layer.frame.size.height / 2 );
    
    float coef = 1.1833333;
    if (!IS_IPHONE_5)
        coef = 1;
    [imgV setFrame:CGRectMake(self.mapView.frame.size.width / 2 , (self.mapView.frame.size.height / 2) * coef, imgV.frame.size.width, imgV.frame.size.height)];
    [self.mapView addSubview:imgV];
   

    self.startAddress.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.endAddress.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];

    if (self.fromResa)
        [self infoFromResa];
}


- (void)infoFromResa
{
    CLLocationCoordinate2D  ctrpointStart;
    CLLocationCoordinate2D  ctrpointEnd;
    
    self.startAddress.text = self.start;
    self.endAddress.text = self.end;
    
    ctrpointStart.latitude = [self.latStartCo floatValue];
        ctrpointStart.longitude = [self.lngStartCo floatValue];
    
        ctrpointEnd.latitude = [self.latEndCo floatValue];
        ctrpointEnd.longitude = [self.lngEndCo floatValue];
    
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
              if (self.annotationSecond)
                  [self traceRoute:self.annotationFirst.coordinate:self.annotationSecond.coordinate];
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

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;

    if (!self.isFirstPlacement)
    {
        [aMapView setRegion:region animated:YES];
        self.isFirstPlacement = YES;
    }
    
    
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
        pinView.image = [UIImage imageNamed:@"pinArrive"];
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
    
    [self.mapView removeAnnotation:self.annotationSecond];
    
    
    
    
    // MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:self.annotationSecond reuseIdentifier:Nil];
    // result.pinColor = 244;
    
    UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
    [spin startAnimating];
    spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [spin startAnimating];
    [self.view addSubview:spin];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    
    
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
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
            anView.image = [UIImage imageNamed:@"pinArrive"];
        }
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




- (IBAction)goBack:(id)sender
{
    if (self.fromResa)
          [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    


    self.isFirstPlacement = NO;

}







@end
