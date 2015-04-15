//
//  DialogViewController.m
//  Lime
//
//  Created by Pavel on 15.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogViewController.h"

@implementation DialogViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageTextField.delegate = self;
    self.messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getTableInfo];
    
    PNChannel *channel;
    channel = [self pubNubConnect];
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
            
            // Subscribe on the channel
            [PubNub subscribeOnChannel:channel];
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
        
    }];
    
    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self withCallbackBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error){
        
        switch (state) {
            case PNSubscriptionProcessSubscribedState:
                NSLog(@"OBSERVER: Subscribed to Channel: %@", channels[0]);
                // #2 Send a welcome message on subscribe
                [PubNub sendMessage:[NSString stringWithFormat:@"Hello Everybody!" ] toChannel:channel ];
                break;
            case PNSubscriptionProcessNotSubscribedState:
                NSLog(@"OBSERVER: Not subscribed to Channel: %@, Error: %@", channels[0], error);
                break;
            case PNSubscriptionProcessWillRestoreState:
                NSLog(@"OBSERVER: Will re-subscribe to Channel: %@", channels[0]);
                break;
            case PNSubscriptionProcessRestoredState:
                NSLog(@"OBSERVER: Re-subscribed to Channel: %@", channels[0]);
                break;
        }
    }];
    
    [[PNObservationCenter defaultCenter] addClientChannelUnsubscriptionObserver:self withCallbackBlock:^(NSArray *channel, PNError *error) {
        if ( error == nil )
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@", channel[0]);
            [PubNub subscribeOnChannel:channel];
        }
        else
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@, Error: %@", channel[0], error);
        }
    }];
    
    // Observer looks for message received events
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@", message.channel.name, message.message);
        
        // Look for a message that matches "**************"
        if ( [[[NSString stringWithFormat:@"%@", message.message] substringWithRange:NSMakeRange(1,14)] isEqualToString: @"**************" ])
        {
            // Send a goodbye message
            [PubNub sendMessage:[NSString stringWithFormat:@"Thank you, GOODBYE!" ] toChannel:channel withCompletionBlock:^(PNMessageState messageState, id data) {
                if (messageState == PNMessageSent) {
                    NSLog(@"OBSERVER: Sent Goodbye Message!");
                    //Unsubscribe once the message has been sent.
                    [PubNub unsubscribeFromChannel:channel ];
                }
            }];
        }
    }];
    
    
    // #3 Add observer to catch message send events.
    [[PNObservationCenter defaultCenter] addMessageProcessingObserver:self withBlock:^(PNMessageState state, id data){
        
        switch (state) {
            case PNMessageSent:
                NSLog(@"OBSERVER: Message Sent.");
                break;
            case PNMessageSending:
                NSLog(@"OBSERVER: Sending Message...");
                break;
            case PNMessageSendingError:
                NSLog(@"OBSERVER: ERROR: Failed to Send Message.");
                break;
            default:
                break;
        }
    }];
    // =================================
    
//    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
//                                                      selector: @selector(refreshData:) userInfo: nil repeats: YES];
//    [self refreshData:myTimer];
//    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    Message *message = [Message sharedInstance];
    message = [message createMessageWithText:[self.messageTextField text]]; // Create message with textField text
    
    if (message != nil) {
        self.message = message;
        self.message.recipient = [PFUser currentUser]; // MOCK: TODO - get recipient from contact table;
        NSLog(@"%@", [PFUser currentUser]);
    } else {
        NSLog(@"Error. Nil message");
    }
}


- (void)send:(UIButton *)sender {
    
    [self textFieldDidEndEditing:self.messageTextField];
    NSLog(@"textFieldDidEndEditing");
    NSLog(@"%@", self.message.text);
    NSLog(@"%@", self.message.sender);
    NSLog(@"%@", self.message.recipient);
    
    if (self.message != nil) {
        [self.message sendMessageTo:self.message.recipient];
    }
    
    NSLog(@"Send button pressed!");
}


- (void) getTableInfo {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"recipient" equalTo: [PFUser currentUser]];
    
    self.messageArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSDate *date;
        NSString *message;
        
        for (PFObject *obj in objects) {
            
            date = [obj valueForKey:@"createdAt"];
            message = [obj valueForKey:@"text"];
            
            
            [self.messageArray addObject:message];
            [self.dateArray addObject:date];
        }
        NSLog(@"%@", [self.messageArray description]);
        NSLog(@"%@", [self.dateArray description]);
        
        [self.tableView reloadData]; // for loading new data from arrays
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    // create a background image for the cell:
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundView:bgView];
    [cell setIndentationWidth:0.0];
    
    // Date
    // create a custom label:                                        x    y   width  height
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 30.0)];
    [dateLabel setTag:1];
    [dateLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [dateLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:1.0]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:10.0]];

    NSDate* date = [self.dateArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    [dateLabel setText:stringFromDate];
    // =========================================
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 13.0, 150.0, 80.0)];
    [messageLabel setTag:2];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Avenir" size: 12.0]];
    [messageLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:100.0]];
    [messageLabel setNumberOfLines: 2];
    
    NSString *cellValue = [self.messageArray objectAtIndex:indexPath.row];
    [messageLabel setText: cellValue];
    
    // Adding subviews to cell
    [cell.contentView addSubview:dateLabel];
    [cell.contentView addSubview:messageLabel];

    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messageArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: indexPath {
    return 80.0;
}


// Setting up separator insets
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Remove separator inset on empty cells.
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


// ========================================= PubNub section================================================

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


@end