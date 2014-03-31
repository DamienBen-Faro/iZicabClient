//
//  UserInfoSingleton.h
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoSingleton : NSObject
{
}

@property (strong) NSString *userId;
@property (strong) NSString *name;
@property (strong) NSString *email;
@property (strong) NSString *postalCode;
@property (strong) NSString *city;

+ (id)sharedUserInfo;


@end
