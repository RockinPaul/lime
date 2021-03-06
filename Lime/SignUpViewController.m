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


- (void)viewDidAppear:(BOOL)animated {
    
    [PFUser logOut]; // logout for demo
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self presentViewController];
    }
}

- (void)presentViewController {
    UIStoryboard *storyboard = [self grabStoryboard];
    ContactsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"contacts"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height <= 568) {
        storyboard = [UIStoryboard storyboardWithName:@"iphone5" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    
    return storyboard;
}



- (void)auth:(UIButton *)sender {
    
    if ([[self.signButton.titleLabel text] isEqualToString:@"Sign In"]) {
        [self signIn];
    } else
        if ([[self.signButton.titleLabel text] isEqualToString:@"Sign Up"]) {
            [self signUp];
        } else {
            NSLog(@"Something is wrong.");
    }
}


- (void)signUp {
    
    PFUser *user = [PFUser user];
    user.username = [self.emailTextField text];
    user.password = [self.passwordTextField text];
    user.email = [self.emailTextField text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Authorization successful!");
            [self.newcomerLabel setText:@"Check your email to confirm registration"];
            [self presentViewController];
        } else {
            if ([error code] == 203) { // email already exists
                [self.errorLabel setText:@"Email already exists"];
            }
            if ([error code] == 125) {
                [self.errorLabel setText:@"Invalid email address"];
            }
            if ([error code] == 202) {
                [self.errorLabel setText:@"Email already taken"];
            }
        }
    }];
}


- (void)signIn {
    [PFUser logInWithUsernameInBackground:[self.emailTextField text] password:[self.passwordTextField text]
                                    block:^(PFUser *user, NSError *error) {
        if (user) {
               // Do stuff after successful login.
            NSLog(@"Sign In success!");
            [self presentViewController];
        } else {
               // The login failed. Check error to see why.
            if ([error code] == 101) { // email already exists
                [self.errorLabel setText:@"Wrong password"];
            }
            if ([error code] == 205) {
                [self.errorLabel setText:@"User not found"];
            }
            if ([error code] == 125) {
                [self.errorLabel setText:@"Invalid email address"];
            }
        }
    }];
}


// Changing button state for sign up
- (void)newcomer:(UIButton *)sender {
    [self.signButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.newcomerLabel setText:@""];
    [self.newcomerButton setHidden:YES];
}


// Email verification
- (void)resendConfirmation:(UIButton *)sender {
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded) {
            NSLog(@"Successfuly resent");
            [[PFUser currentUser] setObject:[self.emailTextField text] forKey:@"email"];
            [[PFUser currentUser] saveInBackground];
        }
    }];
}


// Reset password. User takes the email with instructions from Parse.
- (void)resetPassword:(UIButton *)sender {
    [PFUser requestPasswordResetForEmailInBackground:[self.emailTextField text] block:^(BOOL succeeded, NSError *error){
        if (!error) {
            [self.errorLabel setText:@"Check email for instructions"];
            NSLog(@"Succesfuly reset");
        } else {
            if ([error code] == 205) {
                [self.errorLabel setText:@"No user found with this email"];
            }
        }
    }];
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
    [self.view setFrame:CGRectMake(0, -80, 400, 800)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, 0, 400, 800)];
}
// ==================================================================================================================
// Dismiss on tap (have some questions)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}
// ==================================================================================================================


@end