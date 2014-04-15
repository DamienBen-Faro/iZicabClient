//
//  SearchAddressTableViewController.h
//  iZicab
//
//  Created by Damien  on 4/15/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchAddressTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>


@property (strong)                  UISearchBar         *searchBar;
@property (strong)                  NSMutableArray      *autocompleteUrls;
@property (strong)                  NSMutableArray      *airport;
@property (strong)                  NSMutableArray      *myPos;
@property (strong)                  NSMutableArray      *data;
@property (strong)                  CLLocationManager   *locationManager;
@property (assign)                  BOOL                isStartAddr;
@property (strong)                  NSMutableDictionary *memoryFromReservation;

@end
