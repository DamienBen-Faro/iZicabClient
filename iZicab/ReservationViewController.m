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

@implementation ReservationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

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
    [self.startAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.endAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.datePicker.hidden = YES;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    

}



- (void) viewDidAppear:(BOOL)animated
{
    [self loadUserData];
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(0, 20, 320, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.autocompleteTableView];
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offAll:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
}

- (void) loadUserData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.tiers.on = NO;
    self.name.text = [defaults objectForKey:@"userName"];
    self.name.enabled = NO;
    self.name.backgroundColor = [UIColor lightGrayColor];
    self.phone.text = [defaults objectForKey:@"phone"];
    self.phone.enabled = NO;
    self.phone.backgroundColor = [UIColor lightGrayColor];
    [self.passBtn setTitle:@"1" forState:UIControlStateNormal];
    [self.luggBtn setTitle:@"1" forState:UIControlStateNormal];
    self.babySeat.selected = NO;
    self.paper.selected = NO;
    self.wifi.selected = NO;
    
}


- (void)textFieldDidChange:(id)sender
{
     NSString *fieldSelected = self.startAddress.text;
    if ([sender tag] == 111)
        
        self.isStartAddr = YES;
    else
    {
        self.isStartAddr = NO;
        fieldSelected = self.endAddress.text;
    }
    
   
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:fieldSelected completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
       
        
      //  NSLog(@"lat:%f / lng:%f / arr count: %i / addr: %@", lat, lng, [placemarks count], [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]);
        self.autocompleteTableView.hidden = NO;
        [self.autocompleteUrls removeAllObjects];
        for(CLPlacemark *curString in placemarks)
        {
             if(self.isStartAddr)
             {
                 self.startLat = placemark.region.center.latitude;
                 self.startLng = placemark.region.center.longitude;
             }
            else
            {
                self.endLat = placemark.region.center.latitude;
                self.endLng = placemark.region.center.longitude;
            }
            [self.autocompleteUrls addObject:[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
        }
        
        [self.autocompleteTableView reloadData];
    }];
}

- (IBAction)goToMap:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MapViewController* ctrl = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)selectDate:(id)sender
{
    self.datePicker.hidden = NO;
    [self.startDate setTitle: [NSString stringWithFormat:@"%@",self.datePicker.date] forState:UIControlStateNormal];
}

- (IBAction)offAll:(id)sender
{
    self.datePicker.hidden = YES;
    [self.startAddress resignFirstResponder];
    [self.endAddress resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.phone resignFirstResponder];
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
    ctrl.resaCtrl = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)tiersAct:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.tiers.on)
    {
        self.name.text = [defaults objectForKey:@"userName"];
        self.name.enabled = YES;
        self.name.backgroundColor = [UIColor whiteColor];
        self.phone.text = [defaults objectForKey:@"phone"];
        self.phone.enabled = YES;
        self.phone.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.name.text = [defaults objectForKey:@"userName"];
        self.name.enabled = NO;
        self.name.backgroundColor = [UIColor lightGrayColor];
        self.phone.text = [defaults objectForKey:@"phone"];
        self.phone.enabled = NO;
        self.phone.backgroundColor = [UIColor lightGrayColor];
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = [indexPath row];
    [button addTarget:self
               action:@selector(selectAddr:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = cell.frame;
    [cell addSubview:button];
    cell.textLabel.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.autocompleteTableView.hidden = YES;
    
    if (self.isStartAddr)
        self.startAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
    else
        self.endAddress.text = [self.autocompleteUrls objectAtIndex:[indexPath row]];
}

- (IBAction)selectAddr:(id)sender
{
    self.autocompleteTableView.hidden = YES;
    
    if (self.isStartAddr)
        self.startAddress.text = [self.autocompleteUrls objectAtIndex:[sender tag]];
    else
        self.endAddress.text = [self.autocompleteUrls objectAtIndex:[sender tag]];

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
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"RESERVATION"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
