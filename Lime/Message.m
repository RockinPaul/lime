//
//  Message.m
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@implementation Message


- (Message *)createMessageWithText:(NSString *)text {
    
    Message *message = [[Message alloc] init];
    message.text = text;
    message.sender = [PFUser currentUser];
    
    return message;
}


- (void)sendMessageTo:(PFUser *)recipient {
    
    PFObject *pfMessage = [PFObject objectWithClassName:@"Message"];
    pfMessage[@"text"] = self.text;
    pfMessage[@"sender"] = self.sender;
    pfMessage[@"recipient"] = self.recipient;
    
    [pfMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Successfuly save!");
        } else {
            NSLog(@"%ld", [error code]);
        }
    }];
}


- (void)describeMessage:(Message *)message {
    NSLog(@"MESSAGE: %@", message.text);
    NSLog(@"DATE: %@", message.date);
    NSLog(@"SENDER: %@", message.sender);
    NSLog(@"RECIPIENT: %@", message.recipient);
}


+(Message *) sharedInstance {
    static dispatch_once_t pred;
    static Message *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Message alloc] init];
    });
    return sharedInstance;
}

@end