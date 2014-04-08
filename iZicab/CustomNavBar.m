//
//  CustomNavBar.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {}
    return self;
}



- (void)drawRect:(CGRect)rect
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
    v.backgroundColor = [UIColor clearColor];
    
    UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(12.5f, 30, self.frame.size.width - 25, 90)];
    l.text = _titleNavBar;
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Roboto-Thin" size:34.0];
    l.textAlignment = NSTextAlignmentCenter;
    l.lineBreakMode = NSLineBreakByWordWrapping;
    l.numberOfLines = 2;
    //[[UIApplication sharedApplication] setStatusBarHidden:NO
      //                                      withAnimation:UIStatusBarAnimationFade];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [v addSubview:whiteView];
    [v addSubview:l];
    [self insertSubview:v atIndex:0];
    self.frame = CGRectMake(0, -10, self.frame.size.width, self.frame.size.height);
 
}


@end
