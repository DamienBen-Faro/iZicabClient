//
//  CustomNavBar.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "CustomNavBar.h"
#import "UserInfoSingleton.h"

@implementation CustomNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {}
    return self;
}

/*
 UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
 v.backgroundColor = [UIColor clearColor];
 
 UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(12.5f, 30, self.frame.size.width - 25, 90)];
 l.text = _titleNavBar;
 l.textColor = [UIColor whiteColor];
 l.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
 l.textAlignment = NSTextAlignmentCenter;
 l.lineBreakMode = NSLineBreakByWordWrapping;
 l.numberOfLines = 2;
 //[[UIApplication sharedApplication] setStatusBarHidden:NO
 //                                      withAnimation:UIStatusBarAnimationFade];
 
 UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
 whiteView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
 
 UIImageView *fondu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 86)];
 fondu.image = [UIImage imageNamed:@"fondu"];
 
 
 [v addSubview:whiteView];
 [v addSubview:fondu];
 [v addSubview:l];
 [self insertSubview:v atIndex:0];
 
 */

- (void)drawRect:(CGRect)rect
{

    if (_isDash)
    {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
   
    if (![[UserInfoSingleton sharedUserInfo] dashed])
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
    v.backgroundColor = [UIColor clearColor];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 70)];
    whiteView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    
    UIImageView *fondu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
    fondu.image = [UIImage imageNamed:@"fondu.png"];
    
    UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(25, 9, self.frame.size.width - 50, 90)];
    l.text = _titleNavBar;
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Roboto-Thin" size:30.0];
    l.textAlignment = NSTextAlignmentCenter;
    l.lineBreakMode = NSLineBreakByWordWrapping;
    l.numberOfLines = 2;


    self.frame = CGRectMake(0, 0, self.frame.size.width, 110);
    [v insertSubview:fondu atIndex:0];
    [v addSubview:whiteView];
   
    [self insertSubview:v atIndex:0];
    [self addSubview:l];
}


@end
