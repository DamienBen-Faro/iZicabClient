//
//  SearchAddressTableViewController.m
//  iZicab
//
//  Created by Damien  on 4/15/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SearchAddressTableViewController.h"
#import "CustomNavBar.h"
#import "MapViewController.h"
#import "ReservationViewController.h"
#import "DashboardViewController.h"

@implementation SearchAddressTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
              [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 27, 320, 0)];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    [self.tableView addSubview:self.searchBar];
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 70.0f)];
  
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

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:   (CLLocation*)newLocation fromLocation:(CLLocation *)oldLocation
{

    if (self.data.count >= 2)
        return;
      //  [self.data removeObjectAtIndex:1];
    NSString * tLatitude  = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.latitude];
    NSString * tLongitude = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.longitude];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for(CLPlacemark *curString in placemarks)
         {
             NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Ma position", @"section",   [[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "], @"name",  tLatitude,@"lat", tLongitude,  @"lng",nil];
             self.myPos = [[NSMutableArray alloc] initWithObjects: tmp, nil];
             
            
         }
          [self.data insertObject:self.myPos atIndex:0];
             [self.tableView reloadData];
         
     }];
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
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"RECHERCHE"];
    
    self.data = [[NSMutableArray alloc] init];
    NSMutableDictionary *cdg = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Aeroport", @"section", @"Paris-Charles De Gaulle (CDG), 95700 Roissy", @"name", @"49.004",@"lat", @"2.5711",@"lng", nil];
    NSMutableDictionary *orly = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"Aeroport", @"section", @"Aéroport de Paris-Orly, 94390 Orly, France", @"name", @"48.72624",@"lat",@"2.365247", @"lng",  nil];
    self.airport = [[NSMutableArray alloc] initWithObjects:cdg, orly, nil];
    
    [self.data addObject:self.airport];
    [self getLocation];
    
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error)
     {

         [self.autocompleteUrls removeAllObjects];
         if ([self.data count] == 3)
             [self.data removeObjectAtIndex:0];
         
         for(CLPlacemark *curString in placemarks)
         {

             NSMutableDictionary * tmp = nil;
             if ( [curString.administrativeArea isEqual:@"Île-de-France"])
             {

                tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Recherche", @"section",
                       [[curString.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "],@"name",
                       [ NSString stringWithFormat:@"%f", curString.region.center.latitude], @"lat",
                       [ NSString stringWithFormat:@"%f", curString.region.center.longitude], @"lng",  nil];
              
                 [self.autocompleteUrls addObject:tmp];
               
             }
         }
         if ([self.autocompleteUrls count] > 0)
         {
         [self.data insertObject:self.autocompleteUrls atIndex:0];
         [self.tableView reloadData];
         }
       
         
     }];
  //  NSLog(@"result:%@", self.autocompleteUrls);
  
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)goBack
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.data objectAtIndex:section];
    return [dictionary count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"waaat:%@",  [self.data objectAtIndex:section][0]);
    return [self.data objectAtIndex:section][0][@"section"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    NSLog(@"%@", [self.data objectAtIndex:indexPath.section][indexPath.row]);
    cell.textLabel.text = [self.data objectAtIndex:indexPath.section][indexPath.row][@"name"];
    return cell;
    
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
 

    if (self.isFromMap)
    {
         MapViewController *  ctrl = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
  
        ctrl.end = [self.data objectAtIndex:indexPath.section][indexPath.row][@"name"];
        ctrl.endLat = [self.data objectAtIndex:indexPath.section][indexPath.row][@"lat"] ;
        ctrl.endLng = [self.data objectAtIndex:indexPath.section][indexPath.row][@"lng"] ;
        
        ctrl.start = self.myPos[0][@"name"];
        ctrl.startLat = self.myPos[0][@"lat"];
        ctrl.startLng = self.myPos[0][@"lng"];
        
        ctrl.fromResa = YES;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:ctrl animated:YES];
        
     
    }
    else
    {
         ReservationViewController*     ctrl = (ReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
        if (self.isStartAddr)
        {
            ctrl.startAddr = [self.data objectAtIndex:indexPath.section][indexPath.row][@"name"];
            ctrl.startLat = [[self.data objectAtIndex:indexPath.section][indexPath.row][@"lat"] floatValue];
            ctrl.startLng = [[self.data objectAtIndex:indexPath.section][indexPath.row][@"lng"] floatValue];
            
            ctrl.endAddr = self.memoryFromReservation[@"addr"];
            ctrl.endLat = [self.memoryFromReservation[@"lat"] floatValue];
            ctrl.endLng = [self.memoryFromReservation[@"lng"] floatValue];
        }
        else
        {
            ctrl.endAddr = [self.data objectAtIndex:indexPath.section][indexPath.row][@"name"];
            ctrl.endLat = [[self.data objectAtIndex:indexPath.section][indexPath.row][@"lat"] floatValue];
            ctrl.endLng = [[self.data objectAtIndex:indexPath.section][indexPath.row][@"lng"] floatValue];
            
            ctrl.startAddr = self.memoryFromReservation[@"addr"];
            ctrl.startLat = [self.memoryFromReservation[@"lat"] floatValue];
            ctrl.startLng = [self.memoryFromReservation[@"lng"] floatValue];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:ctrl animated:YES];
        

    }


    
    

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
