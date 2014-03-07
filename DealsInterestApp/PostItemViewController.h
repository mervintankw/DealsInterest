//
//  PostItemViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 26/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PostItemViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak,nonatomic) NSString *categoryType;
@property (weak, nonatomic) IBOutlet UITextField *titleTextBox;
@property (weak, nonatomic) IBOutlet UITextField *priceTextBox;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

-(void)PostClick:(UIButton *)sender;

@end
