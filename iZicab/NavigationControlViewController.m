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
    
    UIImageView *img =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [img setFrame:CGRectMake(0, 0, img.frame.size.width, img.frame.size.height)];
    [self.view insertSubview:img atIndex:0];
    
    
    self.navigationItem.titleView.hidden = YES;
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self setValue:navigationBar forKey:@"navigationBar"];

    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
