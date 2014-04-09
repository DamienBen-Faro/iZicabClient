//
//  DashboardSegue.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "DashboardSegue.h"

@implementation DashboardSegue

-(void) perform
{


    [UIView  beginAnimations: @"Showinfo" context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35];
    [[[self sourceViewController] navigationController]  pushViewController:[self   destinationViewController] animated:NO ] ;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[self sourceViewController] navigationController].view  cache:NO];
    [UIView commitAnimations];


    
}

@end
