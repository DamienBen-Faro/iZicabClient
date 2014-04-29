//
//  ConnectionData.m
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ConnectionData.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "NavigationControlViewController.h"

@implementation ConnectionData

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


+ (id)sharedConnectionData
{
    static ConnectionData *sharedConnectionData = nil;
    @synchronized(self)
    {
        if (sharedConnectionData == nil)
            sharedConnectionData = [[self alloc] init];
       
        
    }
    return sharedConnectionData;
}


- (void)initService
{
    
    self.alertModalView = [[UILabel alloc] initWithFrame:CGRectMake(0, [ [ UIScreen mainScreen ] bounds ].size.height - 50, 320, 50)];
    self.alertModalView.backgroundColor = [UIColor redColor];
    self.alertModalView.alpha = 0.85;
    
    
    
    self.alertModalView.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    self.alertModalView.textColor = [UIColor whiteColor];
    self.alertModalView.text = @"Pas de connection internet";
    self.alertModalView.textAlignment = UITextAlignmentCenter;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = window.rootViewController;
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:__GET_URL_DEV]];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    
  
     NSData *data = [NSURLConnection sendSynchronousRequest:postRequest  returningResponse:&response error:&error];
      [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    id tmp = nil;
    if (!data)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"pas de reseau"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];

    }
    else
    {
       tmp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
        if (error == nil && tmp && [tmp isKindOfClass:[NSDictionary class]] && [[tmp objectForKey:@"error"] length] == 0)
            [[ConnectionData sharedConnectionData] setUrlz: tmp[@"data"][@"services"]];
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[tmp objectForKey:@"error"] ? [tmp objectForKey:@"error"] : @"internal server error"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
            [alert show];
        }
    }
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(initService) withObject:nil afterDelay:2];
}



- (void)beginService:(NSString *)serviceName:(NSMutableDictionary *)params:(SEL)pointeeFunction:(id)delegateController
{

    NSMutableString *postString = [[NSMutableString alloc] initWithString:@""];
    for (NSString* key in params)
        [postString  appendString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
    postString = (NSMutableString *)[postString stringByReplacingOccurrencesOfString:@"," withString:@" "];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[ConnectionData sharedConnectionData] urlz], serviceName]]];
    
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[postString UTF8String] length:strlen([postString UTF8String])]];
    self.pointeeFunction = pointeeFunction;
    self.delegateController = delegateController;
    
    if ([[ConnectionData sharedConnectionData] spinner] == nil)
    {
        UIActivityIndicatorView *  spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        [spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
        [spin startAnimating];
        spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
       
        [[ConnectionData sharedConnectionData] setSpinner:spin];
    }
     [[delegateController view] addSubview:[[ConnectionData sharedConnectionData] spinner] ];
     [[[ConnectionData sharedConnectionData] spinner] startAnimating];
    [NSURLConnection connectionWithRequest:postRequest delegate:self];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
        NSLog(@"receive response");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    [[[ConnectionData sharedConnectionData] spinner] stopAnimating];
    [[[ConnectionData sharedConnectionData] spinner] removeFromSuperview];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    NSError *error;
    id tmp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    

    if ([tmp isKindOfClass:[NSDictionary class]])
        [self.delegateController performSelector:self.pointeeFunction withObject:tmp];
    else
      NSLog(@"error");
    
        NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}


- (void)dismissNotifModal
{
    
    [UIView transitionWithView:self.rootViewController.view
                      duration:1.2
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        
                        [self.alertModalView removeFromSuperview];
                        
                        
                    }
                    completion:nil];
    

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
        NSLog(@"cache");
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSLog(@"finish");
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        NSLog(@"fail");
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    // The request has failed for some reason!
    // Check the error var
}




@end
