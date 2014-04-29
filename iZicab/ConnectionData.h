//
//  ConnectionData.h
//  iZicab
//
//  Created by Damien  on 3/31/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionData : NSObject<NSURLConnectionDelegate>
{}

@property (strong) IBOutlet UITextField *phone;
@property (strong) IBOutlet UITextField *code;
@property (strong)          UIActivityIndicatorView* spinner;
@property (assign)          SEL pointeeFunction;
@property (strong)          id  delegateController;
@property (nonatomic, strong) NSString *urlz;
@property (strong) UILabel *alertModalView;
@property (strong)UIViewController *rootViewController;


- (void)beginService:(NSString *)serviceName:(NSMutableDictionary *)params:(SEL)pointeeFunction:(id)delegateController;
- (void)initService;
+ (id)sharedConnectionData;

@end
