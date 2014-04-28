//
//  NavigationControlViewController.m
//  iZicab
//
//  Created by Damien  on 3/27/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "NavigationControlViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"



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
    
    

    self.alertModalView.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.alertModalView.textColor = [UIColor whiteColor];
    self.alertModalView.text = @"Pas de connection internet";
    self.alertModalView.textAlignment = UITextAlignmentCenter;

    
    
    self.notifModalView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.notifModalView.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1];
    self.notifModalView.alpha = 0.95;
    
    
   
    self.notifModalView.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.notifModalView.textColor = [UIColor whiteColor];
    self.notifModalView.text = @"Message";
    self.notifModalView.numberOfLines = 2;
    self.notifModalView.textAlignment = UITextAlignmentCenter;

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


        
        [UIView transitionWithView:self.view
                          duration:1.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                        animations:^ {
                            
                            [self.alertModalView removeFromSuperview];
                            if (netStatus == NotReachable)
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
                        
                        [self.notifModalView removeFromSuperview];

                        
                    }
                    completion:nil];
}

- (void)setNotifModal:(NSNotification *)userInfo
{
    
    
    
    
     NSLog(@"%@", userInfo.object);
    
    self.notifModalView.text =[userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"message"] ?
    [userInfo.object objectForKey:@"aps"][@"alert"][@"data"][@"message"] : @"Problème d'affichage du message";


    
    [UIView transitionWithView:self.view
                      duration:1.2
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        
                        [self.notifModalView removeFromSuperview];
                        [self.view addSubview:self.notifModalView];
                        
                    }
                    completion:nil];
    [self performSelector:@selector(dismissNotifModal) withObject:nil afterDelay:10];
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
