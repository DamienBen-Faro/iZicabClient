//
//  PageViewController.h
//  iZicab
//
//  Created by Damien  on 4/18/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h" 

@interface PageViewController : CustomViewController

@property (assign, nonatomic) NSInteger index;
@property (strong) IBOutlet UIImageView    *img;
@property (strong) NSString *imgName;

@end
