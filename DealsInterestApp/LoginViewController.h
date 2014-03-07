//
//  LoginViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 3/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

-(void)LoginBtnClick:(id)sender;
-(void)RegisterBtnClick:(id)sender;

@end
