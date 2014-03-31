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


+ (void)sendReq:(NSString *)serviceName:(void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))completion:(id)delegateController:(NSMutableDictionary *)params
{
    
   UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(100, 150)];
    [[delegateController view] addSubview:spinner];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", __CONST_ADDR_SERVER, serviceName]]];
    NSMutableString *postString = [[NSMutableString alloc] initWithString:@""];
    for (NSString* key in params)
        [postString appendString:[NSString stringWithFormat:@"%@=%@&", [params objectForKey:key], key]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                                        completionHandler:completion];

}





@end
