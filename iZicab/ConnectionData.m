//
//  ConnectionData.m
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ConnectionData.h"
#import "Constant.h"

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
        {
            sharedConnectionData = [[self alloc] init];
        }
    }
    return sharedConnectionData;
}





- (void)beginService:(NSString *)serviceName:(NSMutableDictionary *)params:(SEL)pointeeFunction:(id)delegateController
{
    NSMutableString *postString = [[NSMutableString alloc] initWithString:@""];
    for (NSString* key in params)
        [postString  appendString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
    postString = (NSMutableString *)[postString stringByReplacingOccurrencesOfString:@"," withString:@" "];
    
    
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", __CONST_ADDR_SERVER, serviceName]]];
    
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

        [[[ConnectionData sharedConnectionData] spinner] stopAnimating];
    [[[ConnectionData sharedConnectionData] spinner] removeFromSuperview];
    
    
    NSError *error;
    id tmp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([tmp isKindOfClass:[NSDictionary class]])
        [self.delegateController performSelector:self.pointeeFunction withObject:tmp];
    else
    {
     
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        
    }
    
        NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"%@", dataStr);

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
        NSLog(@"cache");
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSLog(@"finish");
    
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        NSLog(@"fail");
    // The request has failed for some reason!
    // Check the error var
}




@end
