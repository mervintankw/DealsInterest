//
//  ExploreViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *detailCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *detailHeaderLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadCatIndicator;

-(void)triggerPrivateChat;

// Variables
@property(weak,nonatomic) NSString *PCItemProfilePic;
@property(weak,nonatomic) NSString *PCItemTitle;
@property(weak,nonatomic) NSString *PCItemDescription;
@property(weak,nonatomic) NSString *PCItemPrice;
@property(weak,nonatomic) NSString *PCBuyerProfilePic;
@property(weak,nonatomic) NSString *PCBuyerId;
@property(weak,nonatomic) NSString *PCSellerId;
@property(weak,nonatomic) NSString *PCItemId;
@property(weak,nonatomic) NSString *PCChatType;
// Variables

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
