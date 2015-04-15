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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

@end