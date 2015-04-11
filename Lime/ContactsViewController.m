//
//  ContactsViewController.m
//  Lime
//
//  Created by Pavel on 11.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsViewController.h"

@implementation ContactsViewController


- (id)initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:(NSCoder *)aCoder];
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 25;
    
    return self;
}


- (void)viewDidLoad {
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [super viewDidLoad];

}


- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"createdAt"];

    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 4.0, 300.0, 30.0)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [nameLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:1.0]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [nameLabel setText: object[@"username"]];
    
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 9.0, 150.0, 80.0)];
    [messageLabel setTag:2];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Avenir" size: 12.0]];
    [messageLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:100.0]];
    [messageLabel setNumberOfLines: 2];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(330.0, 25.0, 50.0, 30.0)];
    [countLabel setTag:3];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    [countLabel setFont: [UIFont boldSystemFontOfSize:18.0]];
    [countLabel setTextColor:[UIColor colorWithRed:(39.0/255) green:(174.0/255) blue:(96.0/255) alpha:1.0]];
    
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:messageLabel];
    [cell.contentView addSubview:countLabel];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: indexPath {
    
    return 80.0;
}

// =============== Header and footer ====================
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 60.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 56.0; //49.0 for iOS 8
}


@end


