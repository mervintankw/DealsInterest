//
//  UpdateProfileViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 24/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *hpTextBox;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectProfilePicBtn;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

-(void)UpdateClick:(UIButton *)sender;
-(void)SelectProfilePic:(UIButton *)sender;
-(void)LoadView;

@end
