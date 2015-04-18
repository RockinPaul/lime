//
//  TableViewController.m
//  AskMeWhy
//
//  Created by Pavel on 15.03.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsViewController.h"

@implementation ContactsViewController

- (void) viewDidLoad {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.showsCancelButton = YES;
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(70.0, 6.0, 200.0, 28.0)];
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    UIView *barWrapper = [[UIView alloc]initWithFrame:CGRectMake(70.0, 0.0, 200.0, 45.0)];
    [barWrapper addSubview:searchBar];
    self.navigationItem.titleView = barWrapper;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorColor:[UIColor colorWithRed:126.0/255.0 green:211.0/255.0 blue:33.0/255.0 alpha:100.0]];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(update:) userInfo: nil repeats: YES];
    [self update:timer];
 
}


-(void)update:(NSTimer*) timer {
    
    [timer invalidate];
    [self getTableInfo];
}


- (void)getTableInfo {
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    self.contactsArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            NSDate *date;
            NSString *contact;
            
            for (PFObject *obj in objects) {
                
                if (obj != [PFUser currentUser]) {
                    
                    date = [obj valueForKey:@"createdAt"];
                    contact = [obj valueForKey:@"username"];
                
                    [self.contactsArray addObject:contact];
                    [self.dateArray addObject:date];
                }
            }
            
            NSLog(@"%@", [self.contactsArray description]);
            NSLog(@"%@", [self.dateArray description]);
            
            [self.tableView reloadData]; // for loading new data from arrays
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.contactsArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfo *userInfo = [UserInfo sharedInstance];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"email" equalTo:[self.contactsArray objectAtIndex:indexPath.row]];
    
    NSLog(@"%@", [self.contactsArray objectAtIndex:indexPath.row]);

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *object = [objects firstObject];
        NSLog(@"OBJECT: %@", [object description]);
        
        PFUser *recipientUser = (PFUser *)object;
        userInfo.recipient = recipientUser;
        userInfo.sender = [PFUser currentUser];
        
        DialogViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"dialog"];
        [self presentViewController:viewController animated:YES completion:nil];
     
        NSLog(@"%@", [userInfo.recipient description]);
    }];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    // allocate the cell:
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    // create a background image for the cell:
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundView:bgView];
    [cell setIndentationWidth:0.0];
    
    // create a custom label:                                        x    y   width  height
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 4.0, 300.0, 30.0)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [nameLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:1.0]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    
    // Date
    NSDate* date = [self.dateArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    [nameLabel setText:stringFromDate];
    // =========================================
    
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 9.0, 150.0, 80.0)];
    [questionLabel setTag:2];
    [questionLabel setBackgroundColor:[UIColor clearColor]];
    [questionLabel setFont:[UIFont fontWithName:@"Avenir" size: 12.0]];
    [questionLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:100.0]];
    [questionLabel setNumberOfLines: 2];
    
    NSString *cellValue = [self.contactsArray objectAtIndex:indexPath.row];
    [questionLabel setText: cellValue];
    
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:questionLabel];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: indexPath {
    return 80.0;
}


// =============== Header and footer ====================
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 56.0; //49.0 for iOS 8
}

@end