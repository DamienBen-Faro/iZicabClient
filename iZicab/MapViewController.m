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
    self.startAddress.delegate = self;
    self.endAddress.delegate = self;
    
    self.startAddress.tag = 1001;
    self.endAddress.tag = 1002;
    self.latLng = [[NSMutableArray alloc] init];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinDepart"]];

    
    float coef = 1.1833333;
    if (!IS_IPHONE_5)
        coef = 1;
    [imgV setFrame:CGRectMake(self.mapView.frame.size.width / 2,
                              (self.mapView.frame.size.height / 2) * coef - [UIImage imageNamed:@"pinDepart"].size.height ,
                              imgV.frame.size.width, imgV.frame.size.height)];
    
    [self.mapView addSubview:imgV];
    self.startAddress.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.endAddress.font     = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
 

    //UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
   // [self.view addGestureRecognizer:dismissKeyboard];
    
    if (self.fromResa)
        [self infoFromResa];

    
    [self.startAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    [self.endAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];

    
    self.autocompleteUrls = [[NSMutableArray alloc] init];
 
     NSLog(@"delegate:%@ dataSource:%@", self.autocompleteTableView.delegate, self.autocompleteTableView.dataSource);
}

- (void)viewDidAppear:(BOOL)animated
{
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                                  CGRectMake(0, 0, 320, 500) style:UITableViewStylePlain];
    
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    self.autocompleteTableView.alpha = 0.8f;
    [self.autocompleteTableView setUserInteractionEnabled:YES];
       [self.view insertSubview:self.autocompleteTableView belowSubview:self.addrView];
}

- (void)offAll
{

    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
}



- (void) animateTextView:(BOOL) up
{
    if (up)
        self.autocompleteTableView.hidden = NO;
    else
        self.autocompleteTableView.hidden = YES;
    const int movementDistance = 215; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.addrView.frame = CGRectMake(0, self.addrView.frame.origin.y + movement, self.addrView.frame.size.width, self.addrView.frame.size.height);
    [UIView commitAnimations];
}


- (void)textFieldDidBeginEditing:(UITextView *)textView
{
    [self textFieldDidChange:textView];
    [self animateTextView: YES];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
    [self animateTextView:NO ];
}

- (void)dismissKeyboard {
    for (UIView *subView in self.addrView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}


- (void)textFieldDidChange:(UITextView *)sender
{
    NSString *fieldSelected = sender.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:fieldSelected completionHandler:^(NSArray *placemarks, NSError *error)
     {
    
        [self.autocompleteUrls removeAllObjects];
                [self.latLng removeAllObjects];
        for(CLPlacemark *curString in placemarks)
        {
            if(sender.tag == 1001)
                self.isStartAddr = YES;
            else
                self.isStartAddr = NO;

            NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:[ NSString stringWithFormat:@"%f", curString.region.center.latitude], @"lat",
                                 [ NSString stringWithFormat:@"%f", curString.region.center.longitude], @"lng",nil];
            
            [self.latLng addObject:tmp];
            [self.autocompleteUrls addObject:[[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
        }
        
        [self.autocompleteTableView reloadData];
    }];
}


- (void)infoFromResa
{
    CLLocationCoordinate2D  ctrpointStart;
    CLLocationCoordinate2D  ctrpointEnd;
    
    self.startAddress.text = self.start;
    self.endAddress.text = self.end;
        [self.mapView removeAnnotation:self.annotationFirst];
        [self.mapView removeAnnotation:self.annotationSecond];
    
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

- (IBAction)userLoc:(id)sender
{
    self.isFirstPlacement = NO;

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
        
        if (!self.fromResa)
        {
            self.latStartCo = [NSString stringWithFormat:@"%f", location.latitude ];
          self.lngStartCo =  [NSString stringWithFormat:@"%f", location.longitude];
        }
            
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

#pragma mark UITableViewDelegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.autocompleteUrls count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellz"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellz"] ;
    }
    [cell setExclusiveTouch:YES];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = [indexPath row];
    [button addTarget:self
               action:@selector(selectAddr:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = cell.frame;
    //[cell addSubview:button];
    cell.textLabel.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.autocompleteTableView.hidden = YES;
    [self offAll];
    if (self.isStartAddr)
    {
        self.startAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
        self.latStartCo = self.latLng[[indexPath row]][@"lat"] ;
        self.lngStartCo =self.latLng[[indexPath row]][@"lng"] ;

        
    }
    else
    {
        self.endAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
        self.latEndCo = self.latLng[[indexPath row]][@"lat"] ;
        self.lngEndCo =self.latLng[[indexPath row]][@"lng"] ;


    }
    if (self.latEndCo.length > 0)
    [self infoFromResa];


    
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];

    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}




@end
