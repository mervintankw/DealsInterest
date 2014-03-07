//
//  SearchViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 10/12/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *SearchTextBox;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ProductUserSegementedControl;
@property (weak, nonatomic) IBOutlet UITableView *SearchResultTableView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
