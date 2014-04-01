//
//  MapViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "MapViewController.h"
#import "CustomNavBar.h"


@implementation MapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
  

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pin"]];
    [imgV setFrame:CGRectMake(self.mapView.frame.size.width / 2 - 10 , self.mapView.frame.size.height / 2 - 35, imgV.frame.size.width, imgV.frame.size.height)];
    [self.mapView addSubview:imgV];
   
    
   // UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    //[self.mapView addGestureRecognizer:longPressGesture];

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
    
    
   /*
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = aUserLocation.coordinate.latitude;
    ctrpoint.longitude = aUserLocation.coordinate.longitude;
    
    self.annotation = [[MKPointAnnotation alloc] init];
    [self.annotation setCoordinate:ctrpoint];
    [self.annotation setTitle:@"First"];
    [self.annotation setSubtitle:@"First"];
     [self.mapView addAnnotation:self.annotation];*/
    
  
}

- (void)setStartAddressFromLocation
{
    
    /*    NSString *location = @"some address, state, and zip";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:placemark];
                     }
                 }
     ];*/

}



-(IBAction)setFirstPin:(id)sender
{
    CLLocationCoordinate2D  ctrpoint;
    
    ctrpoint = [self.mapView centerCoordinate];
    
    
    self.annotation = [[MKPointAnnotation alloc] init];
    [self.annotation setCoordinate:ctrpoint];
    [self.annotation setTitle:@"First"];
    [self.annotation setSubtitle:@"First"];
    [self.mapView addAnnotation:self.annotation];
    

    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:ctrpoint.latitude longitude:ctrpoint.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.startAddress.text =locatedAt;
     }
     
     ];
}


-(IBAction)setSecondPin:(id)sender
{
    CLLocationCoordinate2D  ctrpoint;
    
    ctrpoint = [self.mapView centerCoordinate];
    

    self.annotation = [[MKPointAnnotation alloc] init];
    [self.annotation setCoordinate:ctrpoint];
    [self.annotation setTitle:@"First"];
    [self.annotation setSubtitle:@"First"];
 
    
    MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:self.annotation reuseIdentifier:Nil];
    result.pinColor = 244;
    
       [self.mapView addAnnotation:result];
   
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:ctrpoint.latitude longitude:ctrpoint.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.endAddress.text =locatedAt;
     }
     
     ];
}



- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"buttonBack"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 97, 15);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.isFirstPlacement = NO;
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@""];
    
}





@end
