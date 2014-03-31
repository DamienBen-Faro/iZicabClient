//
//  DashboardViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "DashboardViewController.h"



@implementation DashboardViewController

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
    _datstop = NO;
   // self.mapView.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}


        
    /*
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.actuReverseButton.viewForBaselineLayout.transform = CGAffineTransformMakeScale(1, -1);
                     }
                     completion:nil];

    */

    
/*
- (void) firstAnim
{/*
    [UIView animateWithDuration:0.7 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.actuButton.viewForBaselineLayout.transform = CGAffineTransformMakeScale(1, 1);
                         
                     }
                     completion:^(BOOL finished){
                     //    self.actuReverseButton.layer.zPosition = 0;
                       //    self.actuButton.layer.zPosition = 100;
                         [self lastAnim];
                     }];
    
    [UIView transitionWithView:self.actuView
                      duration:0.8
     
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                      //  [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-05"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                        [imgV setImage:[UIImage imageNamed:@"ElementAppli-05"]];
                        [self.actuView addSubview:imgV];

                        
                    }
                    completion:^(BOOL finished) {
                      //  [NSThread sleepForTimeInterval:5.5];
                        [self lastAnim];
                    }];
}

- (void) lastAnim
{
     [UIView transitionWithView:self.actuView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                       // [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-03"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                          [imgV setImage:[UIImage imageNamed:@"ElementAppli-03"]];
                        [self.actuView addSubview:imgV];
                    }
                    completion:^(BOOL finished) {
               //         [NSThread sleepForTimeInterval:5.5];
                        [self firstAnim];
                    }];
    

}*/

- (void) actuAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.actuView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        // [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-03"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"actu@2x"]];
                            [imgV setTag:11];
                            [self.actuView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.actuView viewWithTag:11];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                        
                    }
                    completion:^(BOOL finished) {
                                 //[NSThread sleepForTimeInterval:5.5];
                        if (isFirst)
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:5.5];
                        else
                            [self performSelector:@selector(actuAnim) withObject:nil afterDelay:5.5];
                    }];
    
}

- (void) mapAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.mapView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        // [self.actuView setBackgroundImage:[UIImage imageNamed:@"ElementAppli-03"] forState:UIControlStateNormal];
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.actuView.frame.size.width, self.actuView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"map@2x"]];
                            [imgV setTag:42];
                            [self.mapView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.mapView viewWithTag:42];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                      
                    }
                    completion:^(BOOL finished)
                    {
                        if (isFirst)
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:5.5];
                        else
                            [self performSelector:@selector(mapAnim) withObject:nil afterDelay:5.5];
                    }];
    
}


- (void) resaMineAnim
{
    static BOOL isFirst = YES;
    if (_datstop)
        return;
    [UIView transitionWithView:self.resaMineView
                      duration:0.8
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                       
                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.resaMineView.frame.size.width, self.resaMineView.frame.size.height)];
                        if (isFirst)
                        {
                            [imgV setImage:[UIImage imageNamed:@"MesResa@2x"]];
                            [imgV setTag:422];
                            [self.resaMineView addSubview:imgV];
                            isFirst = NO;
                        }
                        else
                        {
                            UIView *viewToRemove = [self.resaMineView viewWithTag:422];
                            [viewToRemove removeFromSuperview];
                            isFirst = YES;
                        }
                        
                    }
                    completion:^(BOOL finished) {
                        //[NSThread sleepForTimeInterval:5.5];
                        if (isFirst)
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:1.5];
                        else
                            [self performSelector:@selector(resaMineAnim) withObject:nil afterDelay:1.5];
                    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    _datstop = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
 //[NSThread detachNewThreadSelector:@selector(firstAnim) toTarget:self withObject:nil];
   _datstop = NO;
   [self performSelector:@selector(mapAnim) withObject:nil afterDelay:2.5];
    [self actuAnim];
    [self resaMineAnim];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}




@end
