//
//  PostItem2ViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostItem2ViewController : UIViewController

@property(weak,nonatomic) NSString *categoryType;
@property(weak,nonatomic) NSString *titleTextBox;
@property(weak,nonatomic) NSString *priceTextBox;
@property(weak,nonatomic) NSString *descriptionTextBox;
@property(weak,nonatomic) NSString *emailTextBox;
@property(weak,nonatomic) NSString *handphoneTextBox;
@property(weak,nonatomic) NSString *contactNameTextBox;
@property(weak,nonatomic) NSString *locationAddressTextBox;
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextBox;

@property (weak, nonatomic) IBOutlet UIImageView *photo1;
@property (weak, nonatomic) IBOutlet UIImageView *photo2;
@property (weak, nonatomic) IBOutlet UIImageView *photo3;
@property (weak, nonatomic) IBOutlet UIImageView *photo4;
@property (weak, nonatomic) IBOutlet UIImageView *photo5;
@property (weak, nonatomic) IBOutlet UIButton *photo1Btn;
@property (weak, nonatomic) IBOutlet UIButton *photo2Btn;
@property (weak, nonatomic) IBOutlet UIButton *photo3Btn;
@property (weak, nonatomic) IBOutlet UIButton *photo4Btn;
@property (weak, nonatomic) IBOutlet UIButton *photo5Btn;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

-(void)LoadView;

@end
