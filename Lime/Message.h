//
//  Message.h
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Message : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *recipient;

- (Message *)createMessageWithText:(NSString *)text;
- (void)sendMessageTo:(PFUser *)recipient;
- (void)describeMessage:(Message *)message;

+ (Message *) sharedInstance;

@end
