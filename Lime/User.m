//
//  User.m
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User


+ (User *) sharedInstance {
    static dispatch_once_t pred;
    static User *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[User alloc] init];
    });
    return sharedInstance;
}

@end