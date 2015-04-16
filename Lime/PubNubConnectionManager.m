//
//  PubNubConnectionManager.m
//  Lime
//
//  Created by Pavel on 16.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubNubConnectionManager.h"

@implementation PubNubConnectionManager

// ========================================= PubNub section================================================

- (void)initConnection {
    
    self.channel = [self pubNubConnect];
    
    [self addClientConnectionStateObserver];
    
//    [self addClientChannelUnsubscriptionObserver];

}



- (PNChannel *)pubNubConnect
{
    // PubNub implementation
    
    PNConfiguration *config = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                           publishKey:@"pub-c-eaa60e8f-990f-487e-826c-a95ca71ded15"
                                                         subscribeKey:@"sub-c-426ec5a4-e3a2-11e4-883b-0619f8945a4f"
                                                            secretKey:@"sec-c-NGI3NjVhZDctZTI0Ny00YmVkLTk2N2UtYzM2MDlhNDY3MmM4"
                               ];
    // #1 define new channel name "demo"
    PNChannel *channel = [PNChannel channelWithName:@"dialog"
                              shouldObservePresence:YES];
    
    [PubNub setConfiguration:config];
    [PubNub connect];
    return channel;
}


- (void)addClientConnectionStateObserver
{
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
            
            // Subscribe on the channel
            [PubNub subscribeOnChannel:self.channel];
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
        
    }];
}


- (void)send:(Message *)message
{
    // Send a message
    [PubNub sendMessage:[NSString stringWithFormat:@"%@", message.text] toChannel:self.channel withCompletionBlock:^(PNMessageState messageState, id data) {
        if (messageState == PNMessageSent) {
            NSLog(@"OBSERVER: MESSAGE SENT!");
            //Unsubscribe once the message has been sent.
            [PubNub unsubscribeFromChannel:self.channel];
        }
    }];
}


- (void)receive:(Message *)message
{
    // Observer looks for message received events
    
    PFObject *pfObject = [message messageToPFObject:message];
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *pnMessage) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@", pnMessage.channel.name, pnMessage.message);
        
        pfObject[@"text"] = [NSString stringWithFormat:@"%@", pnMessage.message];
        pfObject[@"createdAt"] = [[NSDate alloc] init];
        
        [pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"PFObject successfuly saved.");
        }];
    }];
}


- (void)addClientChannelSubscriptionStateObserver
{
//    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self withCallbackBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error){
//        
//        switch (state) {
//            case PNSubscriptionProcessSubscribedState:
//                NSLog(@"OBSERVER: Subscribed to Channel: %@", channels[0]);
//                break;
//            case PNSubscriptionProcessNotSubscribedState:
//                NSLog(@"OBSERVER: Not subscribed to Channel: %@, Error: %@", channels[0], error);
//                break;
//            case PNSubscriptionProcessWillRestoreState:
//                NSLog(@"OBSERVER: Will re-subscribe to Channel: %@", channels[0]);
//                break;
//            case PNSubscriptionProcessRestoredState:
//                NSLog(@"OBSERVER: Re-subscribed to Channel: %@", channels[0]);
//                break;
//        }
//    }];
}


- (void)addClientChannelUnsubscriptionObserver {
    [[PNObservationCenter defaultCenter] addClientChannelUnsubscriptionObserver:self withCallbackBlock:^(NSArray *channel, PNError *error) {
        if ( error == nil )
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@", channel[0]);
            [PubNub subscribeOnChannel:self.channel];
        }
        else
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@, Error: %@", channel[0], error);
        }
    }];
}


- (void)addMessageProcessingObserver
{
//    // #3 Add observer to catch message send events.
//    [[PNObservationCenter defaultCenter] addMessageProcessingObserver:self withBlock:^(PNMessageState state, id data){
//        
//        switch (state) {
//            case PNMessageSent:
//                NSLog(@"OBSERVER: Message Sent.");
//                break;
//            case PNMessageSending:
//                NSLog(@"OBSERVER: Sending Message...");
//                break;
//            case PNMessageSendingError:
//                NSLog(@"OBSERVER: ERROR: Failed to Send Message.");
//                break;
//            default:
//                break;
//        }
//    }];
}


+ (PubNubConnectionManager *) sharedInstance {
    static dispatch_once_t pred;
    static PubNubConnectionManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[PubNubConnectionManager alloc] init];
    });
    return sharedInstance;
}


@end