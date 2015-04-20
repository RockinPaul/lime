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
    
    PubNubConnectionManager *pubNubManager = [PubNubConnectionManager sharedInstance];
    pubNubManager.tableView = self.tableView;
    pubNubManager.messageArray = self.messageArray;
    pubNubManager.dateArray = self.dateArray;
    
    [self getTableInfo];
    
//    [pubNubManager receiveTo:self.messageArray AndDateArray:self.dateArray forTable:self.tableView];
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
    
    UserInfo *userInfo = [UserInfo sharedInstance];
    PubNubConnectionManager *pubNubManager = [PubNubConnectionManager sharedInstance];
    
    Message *message = [[Message alloc] init];
    message.text = [self.messageTextField text];    // get text from messageTextField
    message.date = [[NSDate alloc] init];           // init date attribute by current date
    message.sender = userInfo.sender;               // sender is current application user
    message.recipient = userInfo.recipient;         // TODO
    
    [self.messageArray addObject:message.text];
    [self.dateArray addObject:message.date];
    [self.messageTextField setText:nil];
    
    [pubNubManager send:message forTable:self.tableView];
}


- (void) getTableInfo {
    
    UserInfo *userInfo = [UserInfo sharedInstance];
  
    PFQuery *query1 = [PFQuery queryWithClassName:@"Message"];
    [query1 whereKey:@"recipient" equalTo:userInfo.recipient];
    [query1 whereKey:@"sender" equalTo:userInfo.sender];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Message"];
    [query2 whereKey:@"recipient" equalTo:userInfo.sender];
    [query2 whereKey:@"sender" equalTo:userInfo.recipient];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    
    self.messageArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    self.contactsArray = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSDate *date;
        NSString *message;
        PFUser *contact;
        
        for (PFObject *obj in objects) {
            
            date = [obj valueForKey:@"createdAt"];
            message = [obj valueForKey:@"text"];
            contact = [obj valueForKey:@"sender"];
            
            [self.messageArray addObject:message];
            [self.dateArray addObject:date];
            [self.contactsArray addObject:contact.username];
        }
        NSLog(@"%@", [self.messageArray description]);
        NSLog(@"%@", [self.dateArray description]);
        NSLog(@"%@", [self.contactsArray description]);
        
        [self.tableView reloadData]; // for loading new data from arrays
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // It's very useful fix!
    NSString *CellIdentifier = [NSString  stringWithFormat:@"Cell_%ld", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 30.0)];
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 13.0, 150.0, 80.0)];
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0, 300.0, 30.0)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSString *cellValue;
    
    if (cell.backgroundView == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    // create a background image for the cell:
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundView:bgView];
    [cell setIndentationWidth:0.0];
    
    // Date
    // create a custom label:                                        x    y   width  height
    [dateLabel setTag:1];
    [dateLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [dateLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:1.0]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:10.0]];

    NSDate* date = [self.dateArray objectAtIndex:indexPath.row];
    
    [formatter setDateFormat:@"hh:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    [dateLabel setText:stringFromDate];
        
    [contactLabel setFont:[UIFont fontWithName:@"Avenir" size: 12.0]];
    [contactLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:100.0]];
//    [contactLabel setText:[self.contactsArray objectAtIndex:indexPath.row]];
    // =========================================
    
    [messageLabel setTag:2];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Avenir" size: 12.0]];
    [messageLabel setTextColor:[UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:100.0]];
    [messageLabel setNumberOfLines: 2];
    
    cellValue = [self.messageArray objectAtIndex:indexPath.row];
    [messageLabel setText: cellValue];
    
    // Adding subviews to cell
    [cell.contentView addSubview:dateLabel];
    [cell.contentView addSubview:messageLabel];
//    [cell.contentView addSubview:contactLabel];
        
        NSLog(@"REUSE CELL!");
        
    }
    
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

- (void)backToContacts:(UIButton *)sender {
    [self presentViewController];
    
    NSLog(@"%@", @"- (void)backToContacts:(UIButton *)sender");
}

- (void)presentViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ContactsViewController *contactsViewController = [storyboard instantiateViewControllerWithIdentifier:@"contacts"];
    
    [UIView transitionFromView:self.view
                        toView:contactsViewController.view
                      duration:0.65f
                       options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished){
                        [[UIApplication sharedApplication]delegate].window.rootViewController = contactsViewController;
                    }];
}

// ==================================================================================================================
// Move up the screen
//Declare a delegate, assign your textField to the delegate and then include these methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height <= 568) {
        [self.view setFrame:CGRectMake(0, -205, 400, 800)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
        // NSLog(@"Device has a 3.5inch Display.");
    } else {
        [self.view setFrame:CGRectMake(0, -230, 400, 800)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, 0, 400, 800)];
}
// ==================================================================================================================
// Dismiss on tap (have some questions)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.messageTextField endEditing:YES];
}
// ==================================================================================================================


@end