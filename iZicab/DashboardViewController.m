//
//  DashboardViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "DashboardViewController.h"



@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _datstop = NO;
   // self.mapView.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
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
        
        CLLocationCoordinate2D locationFirst;
        locationFirst.latitude = 48.8f;
        locationFirst.longitude = 2.35f;
        
        CLLocationCoordinate2D locationSecond;
        locationSecond.latitude = 43.29;
        locationSecond.longitude = 5.3f;
        
        CLLocationCoordinate2D southWest = locationFirst;
        CLLocationCoordinate2D northEast = locationSecond;
        
        MKPointAnnotation *m = [[MKPointAnnotation alloc] init];
        [m setCoordinate:southWest];
        MKPointAnnotation *m2 = [[MKPointAnnotation alloc] init];
        [m2 setCoordinate:northEast];
        
        [self.mapView addAnnotation:m];
        [self.mapView addAnnotation:m2];
     
        
        CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude];
        CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude];
        CLLocationDistance meters = [locSouthWest getDistanceFrom:locNorthEast];
        
        MKCoordinateRegion region;
        region.center.latitude = (southWest.latitude + northEast.latitude) / 2.0;
        region.center.longitude = (southWest.longitude + northEast.longitude) / 2.0;
        region.span.latitudeDelta = meters / 111319.5;
        region.span.longitudeDelta = 0.0;
        
        MKCoordinateRegion rRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:rRegion animated:YES];
        [self traceRoute:southWest:northEast];
        
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
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line];
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
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    else if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *route = overlay;
        MKCircleRenderer *routeRenderer = [[MKCircleRenderer alloc] initWithCircle:route];
        
        UIColor *c = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        if ([overlay.title  isEqual: @"medium"])
            c = [UIColor colorWithRed:0.6 green:0.5 blue:0.0 alpha:0.5];
        if ([overlay.title  isEqual: @"low"])
            c = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
        
        routeRenderer.fillColor = c;
        //routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
        
    }
    
    return nil;
}


        
    /*
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.actuReverseButton.viewForBaselineLayout.transform = CGAffineTransformMakeScale(1, -1);
                     }
                     completion:nil];

    */

    


- (void) actuAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.actuView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        // [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-03"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"actu@2x"]];
                            [imgV setTag:11];
                            [self.actuView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.actuView viewWithTag:11];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                        
                    }
                    completion:^(BOOL finished)
                        {
                                 //[NSThread sleepForTimeInterval:5.5];
                        if (isFirst)
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:5.5];
                        else
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:5.5];
                    }];
    
}

- (void) mapAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.mapView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        // [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-03"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"map@2x"]];
                            [imgV setTag:42];
                            [self.mapView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.mapView viewWithTag:42];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                      
                    }
                    completion:^(BOOL finished)
                    {
                        if (isFirst)
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:5.5];
                        else
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:5.5];
                    }];
    
}


- (void) resaMineAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.resaMineView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                       
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.resaMineView.frame.size.width, self.resaMineView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"MesResa@2x"]];
                            [imgV setTag:422];
                            [self.resaMineView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.resaMineView viewWithTag:422];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                        
                    }
                    completion:^(BOOL finished) {
                        //[NSThread sleepForTimeInterval:5.5];
                        if (isFirst)
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:1.5];
                        else
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:1.5];
                    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    _datstop = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
 //[NSThread detachNewThreadSelector:@selector(firstAnim) toTarget:self withObject:nil];
   _datstop = NO;
   [self performSelector:@selector(mapAnim) withObject:nil afterDelay:2.5];
    [self actuAnim];
    [self resaMineAnim];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}




@end
