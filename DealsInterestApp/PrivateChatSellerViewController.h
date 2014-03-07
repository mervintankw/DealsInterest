//
//  PrivateChatSellerViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 28/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateChatSellerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ItemProfilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ItemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *ChatListTableView;

// Variables
@property(weak,nonatomic) NSString *PCItemProfilePic;
@property(weak,nonatomic) NSString *PCItemTitle;
@property(weak,nonatomic) NSString *PCItemDescription;
@property(weak,nonatomic) NSString *PCItemPrice;
@property(weak,nonatomic) NSString *PCBuyerProfilePic;
@property(weak,nonatomic) NSString *PCBuyerId;
@property(weak,nonatomic) NSString *PCSellerId;
@property(weak,nonatomic) NSString *PCItemId;
// Variables

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
