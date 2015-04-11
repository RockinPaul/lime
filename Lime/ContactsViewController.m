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

    cell.textLabel.text = object[@"username"];
    
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


