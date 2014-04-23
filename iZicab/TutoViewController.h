//
//  TutoViewController.h
//  iZicab
//
//  Created by Damien  on 4/18/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutoViewController : UIPageViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>


@property (strong, nonatomic) NSMutableArray *pageImages;
@property (strong)UIPageViewController *pager;
@end
