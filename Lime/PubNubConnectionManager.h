//
//  PubNubConnectionManager.h
//  Lime
//
//  Created by Pavel on 16.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import "PNImports.h"
#import "Message.h"

@interface PubNubConnectionManager : NSObject 

@property (nonatomic, strong) PNChannel *channel;

- (void)initConnection;
- (void)send:(Message *)message;
- (Message *)receive;

+ (PubNubConnectionManager *) sharedInstance;


@end
