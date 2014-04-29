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
    self.start.text = self.resaCtrl.startAddress.titleLabel.text;
    self.end.text = self.resaCtrl.endAddress.titleLabel.text;
    self.passenger.text = self.resaCtrl.passBtn.titleLabel.text;
    self.luggage.text = self.resaCtrl.luggBtn.titleLabel.text;
    self.name.text = self.resaCtrl.name.text;
    
        self.start.font     = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.end.font       = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.date.font      = [UIFont fontWithName:@"Roboto-Thin" size:17.0];
        self.wifi.font      = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.baby.font      = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.luggage.font   = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.passenger.font = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.paper.font     = [UIFont fontWithName:@"Roboto-Thin" size:12.0];
        self.price.font     = [UIFont fontWithName:@"Roboto-Regular" size:45.0];

            self.billz.hidden = YES;
     self.premium.selected = YES;

    self.firstURL = NO;
    self.baby.text = [NSString stringWithFormat:@"%i", self.resaCtrl.babySeat.selected];
    self.wifi.text = [NSString stringWithFormat:@"%i", self.resaCtrl.wifi.selected];
    self.paper.text = [NSString stringWithFormat:@"%i", self.resaCtrl.paper.selected];
    
    
    
    [self getDist:CLLocationCoordinate2DMake(self.resaCtrl.startLat, self.resaCtrl.startLng): CLLocationCoordinate2DMake(self.resaCtrl.endLat, self.resaCtrl.endLng)];
    self.datId.hidden = YES;
    self.idResa.hidden = YES;
 
    if (self.isSeeing)
        [self showResaM];
    
    CGRect webFrame = CGRectMake(0.0, 90.0, 320.0, 460.0);
    self.webView = [[UIWebView alloc] initWithFrame:webFrame];
    self.webView.delegate = self;
}

- (void) showResaM
{
    self.datId.hidden = NO;
    self.idResa.hidden = NO;
    self.premium.hidden = YES;
    self.standard.hidden = YES;
    
    if (self.isHisto)
    self.billz.hidden = NO;
    self.date.text = self.resa[@"tripdatetime"];
        self.start.text = self.resa[@"startposition"];
        self.end.text = self.resa[@"endposition"];
 
     self.passenger.text = [NSString stringWithFormat:@"%@", self.resa[@"seat"]];
     self.luggage.text = [NSString stringWithFormat:@"%@", self.resa[@"luggage"]];
     self.price.text = [NSString stringWithFormat:@"%@ €", self.resa[@"invoicing"]];
     self.name.text = [NSString stringWithFormat:@"%@", self.resa[@"contactname"]];
     self.idResa.text = [NSString stringWithFormat:@"ref#100%@", self.resa[@"id"]];
     self.validate.hidden = YES;
    
    

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


             
             [[ConnectionData sharedConnectionData] beginService: @"linkRelation/getFormulaPrice":[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                                   isPremium, @"type",
                                                                                                   [NSString stringWithFormat:@"%f", rout.distance / 1000],  @"distance"
                                                                                                   ,nil] :@selector(callBackController:):self];
         
         }];
     }];
    
}




- (void)callBackController:(NSDictionary *)dict
{
        
        NSError *error;
        
        
 
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
    

}




- (void)viewWillAppear:(BOOL)animated
{
    
    [self setCustomTitle:@"RÉCAPITULATIF"];
}

- (IBAction)share:(id)sender
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.content drawViewHierarchyInRect:self.content.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *shareString = @"";
   
    NSData *pdfData = UIImagePNGRepresentation(image);
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, pdfData, nil];
    
    

    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityViewController setValue:@"Facture iZicab" forKey:@"subject"];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    
    
}





- (void)sendResa:(NSDictionary *)dict
{
       NSError *error;
    
    if ([self.price.text length] > 0)
    {
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
     
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *urlAddress = [NSString stringWithFormat:@"http://199.16.131.147/~izicat/105/Website/application/controllers/ws/CIC/Phase1Aller.php?email=%@&userId=%@&amount=%@", [defaults objectForKey:@"email"], [defaults objectForKey:@"userId"],[self.price.text substringToIndex:[self.price.text length] - 1]];
            NSLog(@"waat:%@", urlAddress);
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:requestObj];
            [self.view addSubview:self.webView];
            
                [self setCustomTitle:@"PAIEMENT"];
            
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
    
}

- (void)updateResa:(NSDictionary *)dict
{
        
        NSError *error;
        
        
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
}



- (void) sendFinish
{
     [self.webView removeFromSuperview];
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

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
{
    
    
    if (![[inRequest.URL.absoluteString substringToIndex:24] isEqual:@"https://ssl.paiement.cic"] && self.firstURL)
        [self performSelector:@selector(sendFinish) withObject:nil afterDelay:3];
    self.firstURL = YES;
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"START");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"FINISH");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                    message:@"Une erreur est survenue veuillez réésayer plus tard."
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Error : %@",error);
}

- (IBAction)send:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    NSString *isPremium = @"standard";
    
    if ( self.premium.selected)
        isPremium = @"premium";
    


    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dat = [format dateFromString:self.date.text];
   
    NSString *newDateString = [format stringFromDate:dat];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    
    
    [params setObject:[defaults objectForKey:@"userId"] forKey:@"userId" ];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.startLat] forKey:   @"latStart"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.startLng] forKey: @"lngStart"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.endLat] forKey: @"latEnd"];
    [params setObject:[NSString stringWithFormat:@"%f", self.resaCtrl.endLng ] forKey: @"lngEnd"];
    [params setObject:self.start.text forKey:@"startAddress"];
    [params setObject:self.end.text forKey:  @"endAddress"];
    [params setObject:isPremium forKey:@"tripType"];
    [params setObject:newDateString forKey: @"tripDateTime"];
    [params setObject: @"cash" forKey:@"paymentMode"];
     [params setObject: self.resaCtrl.comment.text forKey:@"comment"];
    [params setObject: self.resaCtrl.passBtn.titleLabel.text forKey:@"seat"];
    [params setObject: self.resaCtrl.luggBtn.titleLabel.text forKey:@"luggage"];
     [params setObject:@"no convention" forKey:@"convention"];
     [params setObject:@"waiting" forKey:@"status"];
     [params setObject: self.resaCtrl.name.text forKey:@"contactName"];
     [params setObject:@"empty" forKey:@"contactEmail"];
     [params setObject:self.resaCtrl.phone.text forKey:@"contactPhone"];
    [params setObject:[NSString stringWithFormat:@"%i", self.resaCtrl.wifi.selected] forKey:@"wifi"];
     [params setObject:self.price.text forKey:@"invoicing"];
    [params setObject:[NSString stringWithFormat:@"%i", self.resaCtrl.paper.selected]  forKey:@"magazine"];
    [params setObject:[NSString stringWithFormat:@"%i", self.resaCtrl.babySeat.selected]  forKey:@"babysit"];
    [params setObject:self.resaCtrl.resaUpdate[@"id"] ? self.resaCtrl.resaUpdate[@"id"] : @"0" forKey:@"resaId"];


    if (self.resaCtrl.isResa)
         [[ConnectionData sharedConnectionData] beginService: @"reservation/update" :params :@selector(updateResa:):self];
    else
          [[ConnectionData sharedConnectionData] beginService: @"reservation/create" :params :@selector(sendResa:):self];
  }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
