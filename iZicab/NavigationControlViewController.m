//
//  NavigationControlViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "NavigationControlViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "AVFoundation/AVFoundation.h"



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
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setNotifModal:)
                                                 name: @"notif"
                                               object: nil];
    
    
    [self initReach];
    [self initModal];
}



- (void)initModal
{
    self.alertModalView = [[UILabel alloc] initWithFrame:CGRectMake(0, [ [ UIScreen mainScreen ] bounds ].size.height - 50, 320, 50)];
    self.alertModalView.backgroundColor = [UIColor redColor];
    self.alertModalView.alpha = 0.85;
    
    

    self.alertModalView.font = [UIFont fontWithName:@"Roboto-Light" size:20.0];
    self.alertModalView.textColor = [UIColor whiteColor];
    self.alertModalView.text = @"Pas de connection internet";
    self.alertModalView.textAlignment = UITextAlignmentCenter;

    
    
    self.notifModalViewContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 79)];
    self.notifModalViewContent.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:157.0/255.0 blue:190.0/255.0 alpha:1];
    self.notifModalViewContent.alpha = 1.00;
    
    self.notifModalView = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 280, 45)];
    self.notifModalView.backgroundColor = [UIColor clearColor];
    self.notifModalView.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    self.notifModalView.textColor = [UIColor whiteColor];
    self.notifModalView.text = @"Message";
    self.notifModalView.numberOfLines = 2;
    self.notifModalView.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    self.notifModalViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 8, 280, 15)];
    self.notifModalViewTitle.backgroundColor = [UIColor clearColor];
    self.notifModalViewTitle.font = [UIFont fontWithName:@"Roboto-Thin" size:16.0];
    self.notifModalViewTitle.textColor = [UIColor whiteColor];
    self.notifModalViewTitle.text = @"Titre";


    
    
    UISwipeGestureRecognizer *tapGestureRecognize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModal)];
    tapGestureRecognize.direction = UISwipeGestureRecognizerDirectionUp;
    [ self.view addGestureRecognizer:tapGestureRecognize];


}

- (void) initReach
{
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName =  [[ConnectionData sharedConnectionData] urlz];
    
    
	self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
    

    
}

- (void) reachabilityChanged:(NSNotification *)note
{
    static BOOL first = NO;
    
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	if (first)
    [self updateInterfaceWithReachability:curReach];
    first = YES;
}



- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
  //  NSLog(@"stats:%@", netStatus );

        
        [UIView transitionWithView:self.view
                          duration:1.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                        animations:^ {
                            
                            [self.alertModalView removeFromSuperview];
                            if (netStatus != ReachableViaWWAN && netStatus != ReachableViaWiFi)
                                [self.view addSubview:self.alertModalView];
                            
                        }
                        completion:nil];
    
      
}

- (void)dismissNotifModal
{
    
    [UIView transitionWithView:self.view
                      duration:1.2
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        
                        [self.notifModalViewContent removeFromSuperview];

                        
                    }
                    completion:nil];
}

- (void)dismissModal
{
    [UIView transitionWithView:self.notifModalView
                      duration:1.2
                       options:UIViewAnimationOptionTransitionFlipFromTop //any animation
                    animations:^ {
                        
                        [self.notifModalViewContent removeFromSuperview];
                        
                        
                    }
                    completion:nil];
}



- (void)setNotifModal:(NSNotification *)userInfo
{
  
    self.notifModalView.text = [[userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"message"] uppercaseString]?
   [[userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"message"] uppercaseString] : @"ERREUR MESSAGE";
    NSLog(@"%@", userInfo.object);

    self.notifModalViewTitle.text = [[userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"notifType"]  uppercaseString]?
    [[userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"notifType"]  uppercaseString] : @"ALERTE";
    
    [self.notifModalViewContent addSubview:self.notifModalViewTitle];
     [self.notifModalViewContent addSubview:self.notifModalView];
        [self.notifModalView sizeToFit];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/notification.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    
    [UIView transitionWithView:self.view
                      duration:1.2
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        
                        [self.notifModalViewContent removeFromSuperview];
                        [self.view addSubview:self.notifModalViewContent];

                        
                    }
                    completion:nil];
    [self performSelector:@selector(dismissNotifModal) withObject:nil afterDelay:12];
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
