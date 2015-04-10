//
//  SignUpViewController.m
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"

@implementation SignUpViewController

- (void)viewDidLoad {
    
}

// ==================================================================================================================
// Dismiss keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // done button was pressed - dismiss keyboard
    [textField resignFirstResponder];
    return YES;
}

// Clear and turn back default text in text fields
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setText:@""];
    
    // Adding dots placeholder to password field
    if ([[textField restorationIdentifier ] isEqual:@"pass"]) {
        [textField setSecureTextEntry:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![textField hasText]) {
        if ([[textField restorationIdentifier]  isEqual: @"email"]) {
            [textField setText: @"Email"];
        }
        if ([[textField restorationIdentifier]  isEqual: @"pass"]) {
            [textField setSecureTextEntry:NO];
            [textField setText: @"Password"];
        }
    }
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
    [self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,460)];
}
// ==================================================================================================================
// Dismiss on tap (have some questions)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}
// ==================================================================================================================


@end