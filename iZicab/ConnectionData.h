//
//  ConnectionData.h
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionData : NSObject
{
    
}
+ (void)sendReq:(NSString *)serviceName:(void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))completion:(id)delegateController:(NSMutableDictionary *)params;

@end
