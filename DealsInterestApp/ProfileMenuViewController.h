//
//  ProfileMenuViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 5/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *myProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *myProductsBtn;
@property (weak, nonatomic) IBOutlet UIButton *myOffersBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBookmarksBtn;
@property (weak, nonatomic) IBOutlet UIButton *transactionHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *notificationsBtn;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UITableView *otherTableView;

-(void)LogoutBtnClick:(id)sender;

@end
