//
//  FollowViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@property (weak, nonatomic) IBOutlet UITableView *followDataTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *followControl;

- (void)followBtnPressed:(id)sender;
- (void)segmentedControlSelectedIndexChanged:(id)sender;

@end
