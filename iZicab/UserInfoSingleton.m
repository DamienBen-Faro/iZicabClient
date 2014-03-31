//
//  UserInfoSingleton.m
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "UserInfoSingleton.h"

@implementation UserInfoSingleton


+ (id)sharedUserInfo
{
    static UserInfoSingleton *sharedUserInfo = nil;
    @synchronized(self)
    {
        if (sharedUserInfo == nil)
            sharedUserInfo = [[self alloc] init];
    }
    return sharedUserInfo;
}



@end
