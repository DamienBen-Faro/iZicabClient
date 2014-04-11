//
//  DashboardViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "DashboardViewController.h"
#import "ConnectionData.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

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
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.isFirstPlacement = NO;
    
    if (!IS_IPHONE_5)
    {
        self.logoH.constant = 130;
        self.logoW.constant = 130;
        self.logoDecal.constant = 95;
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[ConnectionData sharedConnectionData] beginService: @"reservation/readAllMinePrivateUser" :[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                       [defaults objectForKey:@"userId"],  @"userId"
                                                                       ,nil] :@selector(callBackController:):self];
    


    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)callBackController:(NSDictionary *)dict
{
        NSError *error;
        
        
        NSLog(@"%@", dict);
        
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            
            
           
            if ([dict objectForKey:@"data"]  > 0 && [[dict objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {

                NSString *pos = [dict objectForKey:@"data"][0][@"tripdatetime"] ? [dict objectForKey:@"data"][0][@"tripdatetime"] : @"" ;
                
                self.addressResaMine.text = [dict objectForKey:@"data"][0][@"endposition"] ? [dict objectForKey:@"data"][0][@"endposition"]  : @"";
                self.hourResaMine.text = [pos componentsSeparatedByString:@" "][1] ? [pos componentsSeparatedByString:@" "][1] : @"";
                self.dateResaMine.text = [pos componentsSeparatedByString:@" "][0] ? [pos componentsSeparatedByString:@" "][0] : @"";
             
                
                CLLocationCoordinate2D startMap, endMap;
                startMap.latitude =  [((NSString *)[dict objectForKey:@"data"][0][@"startLat"]) floatValue] ? [((NSString *)[dict objectForKey:@"data"][0][@"startLat"]) floatValue] : 0.0;
                startMap.longitude =  [((NSString *)[dict objectForKey:@"data"][0][@"startLng"]) floatValue] ? [((NSString *)[dict objectForKey:@"data"][0][@"startLng"]) floatValue] : 0.0;
                endMap.latitude =  [((NSString *)[dict objectForKey:@"data"][0][@"endLat"]) floatValue] ? [((NSString *)[dict objectForKey:@"data"][0][@"endLat"]) floatValue] : 0.0;
                endMap.longitude =  [((NSString *)[dict objectForKey:@"data"][0][@"endLng"]) floatValue] ? [((NSString *)[dict objectForKey:@"data"][0][@"endLng"]) floatValue] : 0.0;
                
  
          
                
               [self mapResa: startMap: endMap];
                [self resaMineAnim];
            }
            else
            {
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.resaMineView.frame.size.width, self.resaMineView.frame.size.height)];
                
                [imgV setImage:[UIImage imageNamed:@"MesResa@2x"]];
                [imgV setTag:422];
                [self.resaMineView addSubview:imgV];
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



-(void)mapResa: (CLLocationCoordinate2D ) locationFirst:(CLLocationCoordinate2D )locationSecond
{

    
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
        CLLocationCoordinate2D locationSecond;
        

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
        //NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line];
        //    NSLog(@"Rout Name : %@",rout.name);
         //   NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
          //  NSLog(@"Total Steps : %d",[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //    NSLog(@"Rout Instruction : %@",[obj instructions]);
              //  NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1] colorWithAlphaComponent:1];;
        aView.lineWidth = 10;
        return aView;
    }
    
    return nil;
}




    

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
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:15.5];
                        else
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:18.5];
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
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:15.5];
                        else
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:18.5];
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
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:17.5];
                        else
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:17.5];
                    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    _datstop = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
 //[NSThread detachNewThreadSelector:@selector(firstAnim) toTarget:self withObject:nil];
   _datstop = NO;
   [self performSelector:@selector(mapAnim) withObject:nil afterDelay:2.5];
    [self actuAnim];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}





@end
