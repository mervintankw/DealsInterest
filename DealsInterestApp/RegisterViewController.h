//
//  RegisterViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 23/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *emailTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectProfilePicBtn;

@property(weak,nonatomic) UIImage *registerProfilePic;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

-(void)LoadView;
-(void)RegisterBtnClick:(id)sender;
-(void)SelectProfilePic:(UIButton *)sender;

@end
