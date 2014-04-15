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
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.startAddress.tag = 111;
    self.endAddress.tag = 222;
    self.startAddress.text = self.startAddr;
    self.endAddress.text = self.endAddr;
   // [self.startAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   // [self.endAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.startAddress addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.endAddress addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    

    self.datePicker.hidden = YES;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.latLng = [[NSMutableArray alloc] init];
    if (self.isResa)
        [self updateResa];

    

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init] ;
    dayComponent.hour = 1;
    
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
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [self.startDate setTitle: [dateFormatter stringFromDate:self.datePicker.date ] forState:UIControlStateNormal];
    
    [self setLeftV:self.name :@"perso"];
    [self setLeftV:self.phone :@"phone"];
    [self setLeftV:self.startAddress :@"littlePin"];
    [self setLeftV:self.endAddress :@"flag"];
    
}

- (void)setLeftV: (UITextField *)textF
                  :(NSString *)imgName
{
 
    textF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    textF.leftView.frame = CGRectMake(0, 0, 47, 40);
    textF.leftViewMode = UITextFieldViewModeAlways;
}




- (void) viewDidAppear:(BOOL)animated
{
    [self loadUserData];
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(0, 130, 320, 500) style:UITableViewStylePlain];
    
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    

    self.wroteAddr = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 40)];
    self.wroteAddr.textAlignment = NSTextAlignmentCenter;
    self.wroteAddr.font = [UIFont fontWithName:@"Roboto-Light" size:20.0];
    self.wroteAddr.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:0.8];
    self.wroteAddr.textColor = [UIColor whiteColor];
    self.wroteAddr.hidden = YES;
     [self.view addSubview:self.wroteAddr];
    
    [self.view addSubview:self.autocompleteTableView];
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offAll:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    UITapGestureRecognizer* canc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelStreet:)];
    [self.wroteAddr setUserInteractionEnabled:YES];
    [self.wroteAddr addGestureRecognizer:canc];
    self.wasSelected = NO;
}


- (void) updateResa
{
    //service need to return lat and long ...
 //   self.startAddress.text = self.resaUpdate[@"startposition"];
    
    
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
        self.locationManager.distanceFilter = 10.0f; //we don't need to be any more accurate than 10m
    }
    
    [self.locationManager startUpdatingLocation];

}

- (void)textFieldBegin:(id)sender
{
    
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

- (void)textFieldDidChange:(id)sender
{
    [self getLocation];
     NSString *fieldSelected = self.startAddress.text;
    if ([sender tag] == 111)
        self.isStartAddr = YES;
    else
    {
        self.isStartAddr = NO;
        fieldSelected = self.endAddress.text;
    }
    self.wroteAddr.hidden = NO;
    self.wroteAddr.text = ((UITextField *)sender).text;
    if ( self.wroteAddr.text.length == 0)
        self.wroteAddr.text = @"Annuler";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:fieldSelected completionHandler:^(NSArray *placemarks, NSError *error)
    {
       if (self.wasSelected)
       {
        self.autocompleteTableView.hidden = YES;
           self.wasSelected = NO;
       }
        else
            self.autocompleteTableView.hidden = NO;
        [self.autocompleteUrls removeAllObjects];
        [self.latLng removeAllObjects];
        for(CLPlacemark *curString in placemarks)
        {
         //   NSLog(@"admarea:%@ / subadm:%@/ locality:@ / sublocality:%@",    curString.administrativeArea, curString.subAdministrativeArea, curString.locality, curString.subLocality );
             NSLog(@"admarea:%@ ",    curString.administrativeArea );
             if(self.isStartAddr )
             {
                 self.startLat = curString.region.center.latitude;
                 self.startLng = curString.region.center.longitude;
             }
            else
            {
                self.endLat = curString.region.center.latitude;
                self.endLng = curString.region.center.longitude;
            }
            NSDictionary *tmp = nil;
            if ( [curString.administrativeArea isEqual:@"Île-de-France"])
            {
              tmp = [[NSDictionary alloc] initWithObjectsAndKeys:[ NSString stringWithFormat:@"%f", curString.region.center.latitude], @"lat",
                                  [ NSString stringWithFormat:@"%f", curString.region.center.longitude], @"lng",nil];

              [self.latLng addObject:tmp];
              [self.autocompleteUrls addObject:[[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
            }
        }
        
        [self.autocompleteTableView reloadData];
    }];
}

- (IBAction)goToMap:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MapViewController* ctrl = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    ctrl.start = self.startAddress.text;
    ctrl.end = self.endAddress.text;

    ctrl.latStartCo = [NSString stringWithFormat:@"%f", self.startLat ];
    ctrl.lngStartCo = [NSString stringWithFormat:@"%f", self.startLng ];
    
    ctrl.latEndCo = [NSString stringWithFormat:@"%f", self.endLat ];
    ctrl.lngEndCo = [NSString stringWithFormat:@"%f", self.endLng ];
   
    ctrl.fromResa = YES;

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
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [self.startDate setTitle: [dateFormatter stringFromDate:self.datePicker.date ] forState:UIControlStateNormal];

}

- (IBAction)offAll:(id)sender
{
    


    [self.phone resignFirstResponder];
    [self.name resignFirstResponder];
}

- (IBAction)cancelStreet:(id)sender
{
    [self offAll:nil];
    if ([self.wroteAddr.text isEqual:@"Annuler"])
    {
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
     self.wroteAddr.hidden = YES;
     self.autocompleteTableView.hidden = YES;
    }
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
    
    NSLog(@"%@", self.datePicker.date );
    
    if (self.startAddress.text.length == 0 || self.endAddress.text.length == 0
      || [self.datePicker.date compare:minimumDate] == NSOrderedAscending)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"Veuillez remplir tous les champs et mettre une date adéquate"
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.autocompleteUrls count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];


    cell.textLabel.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.autocompleteTableView.hidden = YES;
    self.wroteAddr.hidden = YES;
    self.wasSelected = YES;
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
    if (self.isStartAddr)
    {
        self.startAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
        self.startLat = [self.latLng[[indexPath row]][@"lat"] floatValue];
         self.startLng = [self.latLng[[indexPath row]][@"lng"] floatValue];
    }
    else
    {
        self.endAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
        self.endLat = [self.latLng[[indexPath row]][@"lat"] floatValue];
        self.endLng = [self.latLng[[indexPath row]][@"lng"] floatValue];
    }
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
    
    return NO;

}


- (void)goBack
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];

    
}

- (void) goToDash
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
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
    [backButtonView setFrame:CGRectMake(0, 20, 50, 70)];//25, 75
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
    [homeButtonView setFrame:CGRectMake(270, 20, 50, 70)];//25, 75
    [homeButtonView addSubview:homeBtn];
    
    
    
    
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
    navigationBar.isDash = YES;
    [navigationBar addSubview:backButtonView];
    [navigationBar addSubview:homeButtonView];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"RÉSERVATION"];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
