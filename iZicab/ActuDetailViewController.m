//
//  ActuDetailViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ActuDetailViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"

@implementation ActuDetailViewController

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

    self.textView.text = self.arr[@"value"];
    self.hour.text = self.arr[@"hour"];
    self.date.text = self.arr[@"date"];
    NSURL * imageURL = [NSURL URLWithString: self.arr[@"img"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    self.img.image  = [UIImage imageWithData:imageData];

}




- (void)viewWillAppear:(BOOL)animated
{
        [self setCustomTitle:@"ACTUALITÉ DÉTAILS"];
}




@end
