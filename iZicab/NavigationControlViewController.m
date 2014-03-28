//
//  NavigationControlViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "NavigationControlViewController.h"
#import "CustomNavBar.h"


@implementation NavigationControlViewController

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
    [self.view insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]] atIndex:0];
    
   
    self.navigationItem.titleView.hidden = YES;
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self setValue:navigationBar forKey:@"navigationBar"];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
