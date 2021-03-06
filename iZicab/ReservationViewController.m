//
//  ReservationViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ReservationViewController.h"
#import "CustomNavBar.h"
#import "MapViewController.h"
#import "UserInfoSingleton.h"
#import "InvoiceViewController.h"
#import "DashboardViewController.h"
#import "SearchAddressTableViewController.h"

@implementation ReservationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.nameView.hidden = YES;
    self.scrollView.delegate = self;
    self.comment.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.startAddress.tag = 111;
    self.endAddress.tag = 222;
    [self.startAddress setTitle: self.startAddr forState:UIControlStateNormal];
    [self.endAddress setTitle: self.endAddr forState:UIControlStateNormal];

    self.datePicker.hidden = YES;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.latLng = [[NSMutableArray alloc] init];

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init] ;
    dayComponent.hour = 1;
    dayComponent.minute = 59;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *minimumDate = [[NSDate alloc] init];
    minimumDate = [theCalendar dateByAddingComponents:dayComponent toDate:minimumDate options:0];
     
    
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.minimumDate = minimumDate;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.hidden = YES;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.datePicker.frame.size.height,  self.datePicker.frame.size.width,  self.datePicker.frame.size.height);
    

    self.datePicker.date = minimumDate;
    self.dpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dpBtn addTarget:self
               action:@selector(dateSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.dpBtn setTitle:@"" forState:UIControlStateNormal];
     self.dpBtn.frame = CGRectMake(0, self.datePicker.frame.origin.y - 40, 320, 40);
    [self.dpBtn setBackgroundImage:[UIImage imageNamed:@"validDate"] forState:UIControlStateNormal];
    self.dpBtn.hidden = YES;
    
    [self.view addSubview:self.dpBtn];
    [self.view addSubview:self.datePicker];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [self.startDate setTitle: [dateFormatter stringFromDate:self.datePicker.date ] forState:UIControlStateNormal];
    
    [self setLeftV:self.name :@"perso"];
    [self setLeftV:self.phone :@"phone"];
    
    [self offAll:nil];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"lat"] && self.startAddress.titleLabel.text.length == 0)
    {
        
        
       self.startLat = [[defaults objectForKey:@"lat"] floatValue];
        self.startLng = [[defaults objectForKey:@"lng"] floatValue];
    
        CLLocation *locStart = [[CLLocation alloc]initWithLatitude:self.startLat longitude:self.startLng];
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        [ceo reverseGeocodeLocation: locStart completionHandler:
         ^(NSArray *placemarks, NSError *error)
         {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            [self.startAddress setTitle:locatedAt forState:UIControlStateNormal];
         }
     ];

    }
    
    self.startAddress.titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:16.0];
    self.endAddress.titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:16.0];
    self.startDate.titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:16.0];
    self.comment.font = [UIFont fontWithName:@"Roboto-Thin" size:18.0];
    self.card.selected = YES;
    
    if (![[defaults valueForKey:@"userType"] isEqualToString:@"enterprise"] && ![[defaults valueForKey:@"userType"] isEqualToString:@"employee"])
    {
        self.card.hidden = YES;
        self.bill.hidden = YES;
        self.commentConstraint.constant = 168;
    }


}


-(void)createInputAccessoryView
{
    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [self.inputAccView setBackgroundColor:[UIColor whiteColor]];
    [self.inputAccView setAlpha: 0.8];
    
    
    
    self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDone setFrame:CGRectMake(260.0, 0.0f, 40.0f, 40.0f)];
    [self.btnDone setBackgroundImage:[UIImage imageNamed:@"keyboardDone"] forState:UIControlStateNormal];
    [self.btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];

    
    [self.inputAccView addSubview:self.btnDone];
}

-(void)doneTyping
{
    [self.comment resignFirstResponder];
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)observationComment
{
 
     [self moveView:-100];
    [self createInputAccessoryView];
   [self.comment setInputAccessoryView:self.inputAccView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveView:100];
}

- (IBAction)selectPay:(id)sender
{
    self.card.selected = NO;
    self.bill.selected = NO;
    
    ((UIButton *)sender).selected = YES;
}

- (void)moveView:(int)moved
{
    const float movementDuration = 0.3f; // tweak as needed
   
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y + moved, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)setLeftV: (UITextField *)textF
                  :(NSString *)imgName
{
 
    textF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    textF.leftView.frame = CGRectMake(0, 0, 33, 28);
    textF.leftViewMode = UITextFieldViewModeAlways;
}




- (void) viewDidAppear:(BOOL)animated
{
    [self offAll:nil];
      [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self loadUserData];
    if (self.isResa)
        [self updateResa];
}





- (void) updateResa
{
    
    self.startAddress.titleLabel.text   = self.resaUpdate[@"startposition"];
    self.endAddress.titleLabel.text     = self.resaUpdate[@"endposition"];
    
    [self.startAddress setTitle:self.resaUpdate[@"startposition"] forState:UIControlStateNormal];
    [self.endAddress setTitle:self.resaUpdate[@"endposition"] forState:UIControlStateNormal];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dat = [format dateFromString:self.resaUpdate[@"tripdatetime"]];
    
    if (dat)
    {
        [self.datePicker setDate:dat];
        [self.startDate setTitle:self.resaUpdate[@"tripdatetime"] forState:UIControlStateNormal];
    }
    
    self.startLat = [self.resaUpdate[@"startLat"] floatValue];
    self.startLng = [self.resaUpdate[@"startLng"] floatValue];
    self.endLat   = [self.resaUpdate[@"endLat"] floatValue];
    self.endLng   = [self.resaUpdate[@"endLng"] floatValue];
    
    
}

- (void) loadUserData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.tiers.selected = NO;
    self.name.text = [defaults objectForKey:@"userName"];
    self.name.enabled = NO;
    self.name.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1];
    self.phone.text = [defaults objectForKey:@"phone"];
    self.phone.enabled = NO;
    self.phone.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1];
    
    self.passBtn.titleLabel.text = [defaults objectForKey:@"passBtn"] ?  [defaults objectForKey:@"passBtn"] : @"1";
    self.luggBtn.titleLabel.text = [defaults objectForKey:@"luggBtn"] ?  [defaults objectForKey:@"luggBtn"] : @"1";
    
    self.babySeat.selected = [[defaults objectForKey:@"babySeat"] boolValue] ?  [[defaults objectForKey:@"babySeat"] boolValue]: NO;
    self.paper.selected = [[defaults objectForKey:@"paper"] boolValue] ?  [[defaults objectForKey:@"paper"] boolValue]: NO;
    self.wifi.selected = [[defaults objectForKey:@"wifi"] boolValue] ?  [[defaults objectForKey:@"wifi"] boolValue]: NO;

    
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
        self.locationManager.distanceFilter = 10.0f;
    }
    [self.locationManager startUpdatingLocation];

}

- (IBAction)textFieldBegin:(id)sender
{
    [self offAll:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    SearchAddressTableViewController* ctrl = (SearchAddressTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchAddressTableViewController"];

    if ([sender tag] == 111)
    {
        ctrl.isStartAddr = YES;
        ctrl.memoryFromReservation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.endAddr ,@"addr", [NSString stringWithFormat:@"%f", self.endLat], @"lat",  [NSString stringWithFormat:@"%f", self.endLng], @"lng" , nil];
    }
    else
         ctrl.memoryFromReservation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.startAddr ,@"addr", [NSString stringWithFormat:@"%f",  self.startLat], @"lat",  [NSString stringWithFormat:@"%f", self.startLng], @"lng" , nil];

    [self.navigationController pushViewController:ctrl animated:YES];
}


- (IBAction)goToMap:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MapViewController* ctrl = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    ctrl.start = self.startAddress.titleLabel.text;
    ctrl.end = self.endAddress.titleLabel.text;

    ctrl.startLat = [NSString stringWithFormat:@"%f", self.startLat ];
    ctrl.startLng = [NSString stringWithFormat:@"%f", self.startLng ];
    
    ctrl.endLat = [NSString stringWithFormat:@"%f", self.endLat ];
    ctrl.endLng = [NSString stringWithFormat:@"%f", self.endLng ];
   
    ctrl.fromResa = YES;
    if ([sender tag] == 1001)
        ctrl.isStart = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)selectDate:(id)sender
{
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
    self.dpBtn.hidden = NO;
    self.datePicker.hidden = NO;
   
}

- (IBAction)dateSelected:(id)sender
{
 
     self.datePicker.hidden = YES;
     self.dpBtn.hidden = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [self.startDate setTitle: [dateFormatter stringFromDate:self.datePicker.date ] forState:UIControlStateNormal];
    NSLog(@"wat:%@", self.startDate.titleLabel);
}

- (IBAction)offAll:(id)sender
{


    [self.phone resignFirstResponder];
    [self.name resignFirstResponder];
}



- (IBAction)more:(id)sender
{
    if ([sender tag] == 7878)
    {
        int i =  [((NSString *)self.passBtn.titleLabel.text) intValue];
        if (i < 8)
            i++;
        [self.passBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
    else
    {
        int i =  [((NSString *)self.luggBtn.titleLabel.text) intValue];
        if (i < 8)
        i++;
        [self.luggBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
}

- (IBAction)less:(id)sender
{
    if ([sender tag] == 7878)
    {
        int i =  [((NSString *)self.passBtn.titleLabel.text) intValue];
        if (i > 1)
            i--;
        [self.passBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }
    else
    {
        int i =  [((NSString *)self.luggBtn.titleLabel.text) intValue];
        if (i > 1)
            i--;
        [self.luggBtn setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
    }

}

- (IBAction)setOption:(id)sender
{
    if (((UIButton *)sender).selected)
        ((UIButton *)sender).selected = NO;
    else
        ((UIButton *)sender).selected = YES;
}

- (IBAction)send:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    InvoiceViewController* ctrl = (InvoiceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InvoiceViewController"];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init] ;
    dayComponent.hour = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *minimumDate = [[NSDate alloc] init];
    minimumDate = [theCalendar dateByAddingComponents:dayComponent toDate:minimumDate options:0];
    
    NSString *strEqual = nil;
    
    if ([self.startAddress.titleLabel.text isEqualToString:self.endAddress.titleLabel.text])
    strEqual = @"Adresse de départ et d'arrivée similaire";
    
    if (self.startAddress.titleLabel.text.length == 0 || self.endAddress.titleLabel.text.length == 0
      || [self.datePicker.date compare:minimumDate] == NSOrderedAscending || [self.startAddress.titleLabel.text isEqualToString:self.endAddress.titleLabel.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:strEqual ? strEqual : @"Veuillez remplir tous les champs et mettre une date adéquate"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];

    }
    else
    {
       ctrl.resaCtrl = self;
       [self.navigationController pushViewController:ctrl animated:YES];
    

    }
}



- (IBAction)tiersAct:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.tiers.selected)
    {
        self.name.text = [defaults objectForKey:@"userName"];
        self.name.enabled = YES;
        
        self.name.backgroundColor = [UIColor whiteColor];
        self.phone.text = [defaults objectForKey:@"phone"];
        self.phone.enabled = YES;
        self.phone.backgroundColor = [UIColor whiteColor];
        self.tiers.selected = YES;
    }
    else
    {
        self.name.text = [defaults objectForKey:@"userName"];
        self.name.enabled = NO;
        self.name.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1];
        self.phone.text = [defaults objectForKey:@"phone"];
        self.phone.enabled = NO;
        self.phone.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1];
        self.tiers.selected = NO;
    }
}




- (void)viewWillAppear:(BOOL)animated
{
    
    
    [self offAll:nil];
      [self setCustomTitle:@"RÉSERVATION"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
