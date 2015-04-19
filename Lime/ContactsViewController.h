//
//  ContactsViewController.h
//  Lime
//
//  Created by Pavel on 11.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UserInfo.h"
#import "DialogViewController.h"

@interface ContactsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButtonItem;

@property (nonatomic, strong) NSMutableArray *contactsArray;
@property (nonatomic, strong) NSMutableArray *dateArray;

@end