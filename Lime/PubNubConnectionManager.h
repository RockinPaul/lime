//
//  PubNubConnectionManager.h
//  Lime
//
//  Created by Pavel on 16.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import "PNImports.h"
#import "Message.h"
#import "UserInfo.h"
#import <Parse/Parse.h>

@interface PubNubConnectionManager : NSObject 

@property (nonatomic, strong) PNChannel *channel;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) UITableView *tableView;

- (void)initConnection;
- (void)send:(Message *)message forTable:(UITableView *)tableView;
- (void)receive;
- (PNChannel *)pubNubConnect;
- (void)addClientChannelUnsubscriptionObserver;

+ (PubNubConnectionManager *)sharedInstance;

@end
