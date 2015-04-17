//
//  DialogViewController.h
//  Lime
//
//  Created by Pavel on 15.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Message.h"
#import "PubNubConnectionManager.h"
#import "UserInfo.h"

@interface DialogViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) IBOutlet UILabel *usernameTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) Message *message;
@property (nonatomic, strong) PFUser *recipient;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *dateArray;

- (IBAction)send:(UIButton *)sender;



@end
