//
//  Author.h
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;

+ (User *) sharedInstance;

@end

