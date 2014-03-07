//
//  PrivateChatViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 26/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *buyerProfilePhotoView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextBox;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

- (void)getNewMessage;

//- (IBAction)sendClicked:(id)sender;

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
