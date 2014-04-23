//
//  TutoViewController.m
//  iZicab
//
//  Created by Damien  on 4/18/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "TutoViewController.h"
#import "PageViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"

@implementation TutoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pager.dataSource = self;
    
    int initialIndex = 0;
    PageViewController *initialViewController = (PageViewController *)[self viewControllerAtIndex:initialIndex];
    NSArray *initialViewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pager.view.backgroundColor = [UIColor blackColor];
    [self.pager willMoveToParentViewController:self];
    [self addChildViewController:self.pager];
    [self.view addSubview:self.pager.view];
    [self.pager didMoveToParentViewController:self];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
}


- (void)goBack
{

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



- (UIViewController *)viewControllerAtIndex:(int)i
{
    // Asking for a page that is out of bounds??
    if (i < 0)
        return nil;
    
    if (i > 4 )
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"tutorialy"] == nil)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"ok" forKey:@"tutorialy"];
            [defaults synchronize];
            [self performSelector:@selector(goToDash) withObject:nil afterDelay:1];
        }
        else
        {
            NSLog(@"waaaaaat");
             [self goToDash];
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    PageViewController* ctrl = (PageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    ctrl.index = i;
    ctrl.imgName = [NSString stringWithFormat:@"tuto%i", i + 1];
    return ctrl;
}




- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PageViewController *p = (PageViewController *)viewController;
    return [self viewControllerAtIndex:(p.index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PageViewController *p = (PageViewController *)viewController;
    return [self viewControllerAtIndex:(p.index + 1)];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    int currentPage = [[pageViewController.viewControllers objectAtIndex:0] index];
    return currentPage;
}

// MAX_PAGES is the total # of pages.

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

@end
