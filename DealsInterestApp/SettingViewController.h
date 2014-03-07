//
//  SettingViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {

    __weak IBOutlet UITextField *messageText;
    __weak IBOutlet UIButton *sendButton;
    __weak IBOutlet UITableView *messageList;
    
    NSMutableData *receivedData;
    NSMutableArray *messages;
    int lastId;

    NSTimer *timer;

    NSXMLParser *chatParser;
    NSString *msgAdded;
    NSMutableString *msgUser;
    NSMutableString *msgText;
    int msgId;
    Boolean inText;
    Boolean inUser;
}

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *messageList;

//- (void)getNewMessages;

- (IBAction)sendClicked:(id)sender;

-(void)LogoutBtnClick:(id)sender;

@end
