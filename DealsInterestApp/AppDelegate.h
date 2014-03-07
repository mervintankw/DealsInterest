//
//  AppDelegate.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "PostItemViewController.h"
#import "MeViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "SelectItemPhotoViewController.h"
#import "ActivityViewController.h"

@class PKRevealController;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) ExploreViewController *exploreViewController;
@property (strong, nonatomic) PostItemViewController *postItemViewController;
@property (strong, nonatomic) MeViewController *meViewController;
@property (strong, nonatomic) SettingViewController *settingViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong, nonatomic) ActivityViewController *activityViewController;
@property (strong, nonatomic) SelectItemPhotoViewController *selectItemPhotoViewController;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;

// Global Variables
@property (nonatomic, retain) NSString *apiUrl;
@property (nonatomic, retain) UIImage *registerProfilePic;
@property (nonatomic, retain) NSData *registerProfilePicData;
@property int postItemPhotoCount;
@property (nonatomic, retain) UIImage *photo1;
@property (nonatomic, retain) UIImage *photo2;
@property (nonatomic, retain) UIImage *photo3;
@property (nonatomic, retain) UIImage *photo4;
@property (nonatomic, retain) UIImage *photo5;
@property (nonatomic, retain) NSMutableArray *postItemPhoto;
@property (nonatomic, retain) NSString *loadProfilePurpose;

@property (nonatomic, retain) NSString *notify;

@property(nonatomic,retain) NSString *PCItemProfilePic;
@property(nonatomic,retain) NSString *PCItemTitle;
@property(nonatomic,retain) NSString *PCItemDescription;
@property(nonatomic,retain) NSString *PCItemPrice;
@property(nonatomic,retain) NSString *PCBuyerProfilePic;
@property(nonatomic,retain) NSString *PCBuyerId;
@property(nonatomic,retain) NSString *PCSellerId;
@property(nonatomic,retain) NSString *PCItemId;
// Global Variables

// Upload Items
@property (nonatomic, retain) NSString *uploadCategory;
@property (nonatomic, retain) NSString *uploadTitle;
@property (nonatomic, retain) NSString *uploadPrice;
@property (nonatomic, retain) NSString *uploadCondition;
@property (nonatomic, retain) NSString *uploadDescription;
@property (nonatomic, retain) NSString *uploadLocation;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@property (nonatomic, strong) NSMutableArray *messageToId;
@property (nonatomic, strong) NSMutableArray *messageContent;
@property (nonatomic, strong) NSMutableArray *messageFromId;
@property (nonatomic, strong) NSMutableArray *messageTime;
@property (nonatomic, strong) NSMutableArray *messageFromName;
@property (nonatomic, strong) NSMutableArray *messageToName;

- (void)userDidLogin;
- (void)userDidLogout;

@end
