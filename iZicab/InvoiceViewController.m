//
//  InvoiceViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "InvoiceViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "DashboardViewController.h"

@implementation InvoiceViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.date.text = self.resaCtrl.startDate.titleLabel.text;
    self.start.text = self.resaCtrl.startAddress.text;
    self.end.text = self.resaCtrl.endAddress.text;
    self.passenger.text = self.resaCtrl.passBtn.titleLabel.text;
    self.luggage.text = self.resaCtrl.luggBtn.titleLabel.text;
    
        self.start.font     = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.end.font       = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.date.font      = [UIFont fontWithName:@"Roboto-Thin" size:17.0];
        self.wifi.font      = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.baby.font      = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.luggage.font   = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.passenger.font = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.paper.font     = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.price.font     = [UIFont fontWithName:@"Roboto-Regular" size:45.0];


    
    self.baby.text = [NSString stringWithFormat:@"%i", self.resaCtrl.babySeat.selected];
    self.wifi.text = [NSString stringWithFormat:@"%i", self.resaCtrl.wifi.selected];
    self.paper.text = [NSString stringWithFormat:@"%i", self.resaCtrl.paper.selected];
    
    self.premium.selected = YES;

    
    [self getDist:CLLocationCoordinate2DMake(self.resaCtrl.startLat, self.resaCtrl.startLng): CLLocationCoordinate2DMake(self.resaCtrl.endLat, self.resaCtrl.endLng)];
    
    if (self.isSeeing)
        [self showResaM];

}

- (void) showResaM
{
    self.date.text = self.resa[@"tripdatetime"];
        self.start.text = self.resa[@"startposition"];
        self.end.text = self.resa[@"endposition"];
 
       self.passenger.text = [NSString stringWithFormat:@"%@", self.resa[@"seat"]];
        self.luggage.text = [NSString stringWithFormat:@"%@", self.resa[@"luggage"]];
    self.price.text = [NSString stringWithFormat:@"%@ €", self.resa[@"invoicing"]];
    
    self.validate.hidden = YES;
    self.premium.hidden = YES;
    self.standard.hidden = YES;

}

- (void)getDist:(CLLocationCoordinate2D)southWest:(CLLocationCoordinate2D)northEast
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

         NSArray *arrRoutes = [response routes];
         [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             MKRoute *rout = obj;
             NSString *isPremium = @"standard";
             
             if ( self.premium.selected)
                 isPremium = @"premium";

             [ConnectionData sendReq: @"linkRelation/getFormulaPrice": [self priceEstimation]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                                 isPremium, @"type",
                                                                                               [NSString stringWithFormat:@"%f", rout.distance / 1000],  @"distance"
                                                                                                ,nil]];
         
         }];
     }];
    
}




- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error)) priceEstimation
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
 
        NSString *isPremium = @"standard";
        
        if ( self.premium.selected)
            isPremium = @"premium";
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
            self.price.text = [NSString stringWithFormat:@"%.01f€", [dict[@"data"][isPremium] floatValue]];
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    };

}


- (void) goToDash
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton@2x.png"];
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"backButton@2x.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [backButtonView setFrame:CGRectMake(0, 30, 50, 70)];//25, 75
    [backButtonView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeBtnImage = [UIImage imageNamed:@"menuButton@2X.png"];
    UIImage *homeBtnImagePressed = [UIImage imageNamed:@"menuButton@2X.png"];
    [homeBtn setBackgroundImage:homeBtnImage forState:UIControlStateNormal];
    [homeBtn setBackgroundImage:homeBtnImagePressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(goToDash) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *homeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [homeButtonView setFrame:CGRectMake(270, 30, 50, 70)];//25, 75
    [homeButtonView addSubview:homeBtn];
    
    
    
    
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
    [navigationBar addSubview:backButtonView];
    [navigationBar addSubview:homeButtonView];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"INVOICE"];
    
    
}



- (IBAction)standard:(id)sender
{

        self.premium.selected = NO;
        self.standard.selected = YES;
    [self getDist:CLLocationCoordinate2DMake(self.resaCtrl.startLat, self.resaCtrl.startLng): CLLocationCoordinate2DMake(self.resaCtrl.endLat, self.resaCtrl.endLng)];
}

- (IBAction)premium:(id)sender
{
    
        self.premium.selected = YES;
        self.standard.selected = NO;
    [self getDist:CLLocationCoordinate2DMake(self.resaCtrl.startLat, self.resaCtrl.startLng): CLLocationCoordinate2DMake(self.resaCtrl.endLat, self.resaCtrl.endLng)];
}

- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))sendResa
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
       NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Reservation effectuée"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:ctrl animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            NSString* dataStr = [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
            NSLog(@"wat:%@", dataStr);
        }
      
    };
}

- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))updateResa
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Modification de la réservation effectuée"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:ctrl animated:YES];
            
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
        
    };
}


- (IBAction)send:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    NSString *isPremium = @"standard";
    
    if ( self.premium.selected)
        isPremium = @"premium";
    

    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[defaults objectForKey:@"userId"] forKey:@"userId" ];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.startLat] forKey:   @"latStart"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.startLng] forKey: @"lngStart"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.endLat] forKey: @"latEnd"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.endLng ] forKey: @"lngEnd"];
    [params setObject:self.start.text forKey:@"startAddress"];
    [params setObject:self.end.text forKey:  @"endAddress"];
    [params setObject:isPremium forKey:@"tripType"];
    [params setObject:[NSString stringWithFormat:@"%@%@", [self.date.text componentsSeparatedByString:@" "][0], [self.date.text componentsSeparatedByString:@" "][1]] forKey: @"tripDateTime"];
    [params setObject: @"cash" forKey:@"paymentMode"];
    [params setObject: _passenger.text forKey:@"seat"];
    [params setObject: _luggage.text forKey:@"luggage"];
     [params setObject:@"no convention" forKey:@"convention"];
     [params setObject:@"waiting" forKey:@"status"];
     [params setObject: self.resaCtrl.name.text forKey:@"contactName"];
     [params setObject:@"empty" forKey:@"contactEmail"];
     [params setObject:self.resaCtrl.phone.text forKey:@"contactPhone"];
    [params setObject:self.wifi.text forKey:@"wifi"];
     [params setObject:self.price.text forKey:@"invoicing"];
    [params setObject:self.paper.text forKey:@"magazine"];
    [params setObject:self.baby.text forKey:@"babysit"];
    [params setObject:self.resaCtrl.resaUpdate[@"id"] ? self.resaCtrl.resaUpdate[@"id"] : @"0" forKey:@"resaId"];

    
    

    //NSLog(@"%@/%@", params , self.passenger.text);
    if (self.resaCtrl.isResa)
        [ConnectionData sendReq: @"reservation/update": [self updateResa]: self: params];
    else
        [ConnectionData sendReq: @"reservation/create": [self sendResa]: self: params];
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
