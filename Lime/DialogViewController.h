//
//  DialogViewController.h
//  Lime
//
//  Created by Pavel on 15.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DialogViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;


@end
