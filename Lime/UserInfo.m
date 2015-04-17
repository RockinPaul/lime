//
//  UserInfo.m
//  Lime
//
//  Created by Pavel on 17.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@implementation UserInfo


+ (UserInfo *) sharedInstance {
    static dispatch_once_t pred;
    static UserInfo *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[UserInfo alloc] init];
    });
    return sharedInstance;
}

@end
