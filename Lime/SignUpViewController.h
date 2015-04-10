//
//  SignUpViewController.h
//  Lime
//
//  Created by Pavel on 10.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *signButton;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UILabel *newcomerLabel;
@property (nonatomic, strong) IBOutlet UIButton *newcomerButton;

- (IBAction)auth:(UIButton *)sender;
- (IBAction)newcomer:(UIButton *)sender;

@end
