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
    //[[[self sourceViewController] navigationController]  pushViewController:[self   destinationViewController] animated:NO ] ;
    

  /*  UIViewController *sourceController = (UIViewController*)self.sourceViewController;
    UIViewController *destinationController = (UIViewController*)self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Set transition animation type
    transition.type = kCATransitionFromLeft;
    // Set transition animation subtype
    transition.subtype = kCATransitionFromTop;
    
    // Change animation
    [sourceController.navigationController.view.layer addAnimation:transition forKey:@"mytransition"];
    
    // Transition
    [sourceController.navigationController pushViewController:destinationController animated:NO];*/
    

    [UIView  beginAnimations: @"Showinfo" context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35];
    [[[self sourceViewController] navigationController]  pushViewController:[self   destinationViewController] animated:NO ] ;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[self sourceViewController] navigationController].view  cache:NO];
    [UIView commitAnimations];


    
}

@end
