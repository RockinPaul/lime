//
//  UserInfo.h
//  Lime
//
//  Created by Pavel on 17.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *recipient;

+ (UserInfo *)sharedInstance;

@end