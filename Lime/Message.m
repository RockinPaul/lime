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


- (PFObject *)messageToPFObject:(Message *)message {
    PFObject *object = [PFObject objectWithClassName:@"Message"];
    object[@"date"] = message.date;
    object[@"text"] = message.text;
    object[@"sender"] = message.sender;
    object[@"recipient"] = message.recipient;
    
    return object;
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