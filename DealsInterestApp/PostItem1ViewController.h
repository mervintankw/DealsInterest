//
//  PostItem1ViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostItem1ViewController : UIViewController

@property(weak,nonatomic) NSString *categoryType;
@property(weak,nonatomic) NSString *titleTextBox;
@property(weak,nonatomic) NSString *priceTextBox;
@property(weak,nonatomic) NSString *descriptionTextBox;

@property (weak, nonatomic) IBOutlet UITextField *emailTextBox;
@property (weak, nonatomic) IBOutlet UITextField *handphoneTextBox;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *locationAddressTextBox;

-(void)PostClick:(UIButton *)sender;

@end
