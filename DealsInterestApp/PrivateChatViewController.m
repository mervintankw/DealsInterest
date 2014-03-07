//
//  PrivateChatViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 26/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import "PrivateChatViewController.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface PrivateChatViewController ()

@property (nonatomic, strong) NSMutableArray *messageToId;
@property (nonatomic, strong) NSMutableArray *messageContent;
@property (nonatomic, strong) NSMutableArray *messageFromId;
@property (nonatomic, strong) NSMutableArray *messageTime;
@property (nonatomic, strong) NSMutableArray *messageFromName;
@property (nonatomic, strong) NSMutableArray *messageToName;

@end

@implementation PrivateChatViewController

bool sendStatus = false;

NSString *inItemId;
NSString *inItemProfilePicPath;
NSString *inItemTitle;
NSString *inItemDescription;
NSString *inItemPrice;
NSString *inBuyerProfilePicPath;
NSString *inBuyerId;
NSString *inSellerId;
NSString *inDeviceId;
NSString *inToken;
NSString *inChatType;

// 0 = Send message
// 1 = Receive message
// 2 = Offer deal (Buyer)
// 3 = Accept deal (Seller)
int requestType1 = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self LoadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self LoadView];
}

- (void)LoadView
{
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    inChatType = self.PCChatType;
    
    inItemId = self.PCItemId;
    inItemProfilePicPath = self.PCItemProfilePic;
    inItemTitle = self.PCItemTitle;
    inItemDescription = self.PCItemDescription;
    inItemPrice = self.PCItemPrice;
    inBuyerProfilePicPath = self.PCBuyerProfilePic;
    if([inChatType isEqualToString:@"Buyer"]){
        inBuyerId = [prefs stringForKey:@"pk"];
        [_offerButton setTitle:@"Offer" forState:UIControlStateNormal];
        [_offerButton setTitle:@"Offer" forState:UIControlStateHighlighted];
        [_offerButton addTarget:self action:@selector(offerClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
//        inBuyerId = [prefs stringForKey:@"pk"];
        // Disable price text field input for seller
        [_priceTextField setEnabled:FALSE];
        inBuyerId = self.PCBuyerId;
        [_offerButton setTitle:@"Deal" forState:UIControlStateNormal];
        [_offerButton setTitle:@"Deal" forState:UIControlStateHighlighted];
        [_offerButton addTarget:self action:@selector(dealClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    inSellerId = self.PCSellerId;
    inDeviceId = [prefs stringForKey:@"udid"];
    inToken = [prefs stringForKey:@"token"];
    
    
    
//    _titleLabel.text = inItemTitle;
//    _descriptionLabel.text = inItemDescription;
//    _priceLabel.text = inItemPrice;
//
//    NSString* profilePicPath1 = inBuyerProfilePicPath;
//    NSMutableString* theString1 = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath1];
//    _buyerProfilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
//    [_buyerProfilePhotoView setImageWithURL:[NSURL URLWithString:theString1]
//                      placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    
//    NSString* profilePicPath = inItemProfilePicPath;
//    NSMutableString* theString;
//    
//    _profilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
//    //        NSData *imageData;
//    if([profilePicPath isEqual:@""]){
//        theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
//        // Here we use the new provided setImageWithURL: method to load the web image
//        [_profilePhotoView setImageWithURL:[NSURL URLWithString:theString]
//                placeholderImage:[UIImage imageNamed:@"laoding.gif"]];
//    }else{
//        NSString *tmpImagePath = profilePicPath;
//        theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,tmpImagePath];
//        // Here we use the new provided setImageWithURL: method to load the web image
//        [_profilePhotoView setImageWithURL:[NSURL URLWithString:theString]
//                placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//    }
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Private Chat";
    
//    _messageTable.dataSource = self;
//    _messageTable.delegate = self;
    
    [self getNewMessage];
    
    [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // toolbar for price text field
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           /*[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],*/
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _priceTextField.inputAccessoryView = numberToolbar;
    [_priceTextField addTarget:self action:@selector(updateLabelUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
    // toolbar for price text field
}

-(void)doneWithNumberPad{
    //    NSString *numberFromTheKeyboard = priceTextBox.text;
//    NSLog(@"done with numberpad");
    [_priceTextField resignFirstResponder];
//    [self.view endEditing:YES];
}

- (void)updateLabelUsingContentsOfTextField:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITextField *priceTextBox = (UITextField *)sender;
    NSLog(@"price: %@",priceTextBox.text);
    // Convert string to nsmutablestring first
    NSMutableString *ms = [NSMutableString stringWithString:priceTextBox.text];
    // Remove all decimal points in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"." withString:@""] mutableCopy];
    // Remove all commas in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"," withString:@""] mutableCopy];
    // Remove all dollar sign in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"$" withString:@""] mutableCopy];
    if([ms hasPrefix:@"0"]){
        priceTextBox.text = [ms substringFromIndex:1];
        // Convert string to nsmutablestring first
        ms = [NSMutableString stringWithString:priceTextBox.text];
        // Remove all decimal points in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"." withString:@""] mutableCopy];
        // Remove all commas in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"," withString:@""] mutableCopy];
        // Remove all dollar sign in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"$" withString:@""] mutableCopy];
        NSLog(@"Modified string: %@",ms);
    }
    
    int dollarLength = 0;
    if([ms length] >= 6){
        dollarLength = [ms length] - 2;
        while(dollarLength > 0){
            if(dollarLength != [ms length] - 2){
                [ms insertString:@"," atIndex:dollarLength];
            }
            dollarLength = dollarLength - 3;
        }
    }
    if([ms length] > 2){
        [ms insertString:@"." atIndex:[ms length]-2];
    }
    if([ms length] == 1){
        [ms insertString:@"0.0" atIndex:0];
    }
    if([ms length] == 2){
        [ms insertString:@"0." atIndex:0];
    }
    appDelegate.uploadPrice = [NSString stringWithFormat:@"%@",ms];
    if(![ms hasPrefix:@"$"]){
        _priceTextField.text = [NSString stringWithFormat:@"$%@",ms];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendClick:textField];
    return NO;
}

- (void)getNewMessage {
    _messageToId = [[NSMutableArray alloc] init];
    _messageContent = [[NSMutableArray alloc] init];
    _messageFromId = [[NSMutableArray alloc] init];
    _messageTime = [[NSMutableArray alloc] init];
    _messageFromName = [[NSMutableArray alloc] init];
    _messageToName = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    requestType1 = 1;
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/chat.list/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData;
    if([inChatType isEqualToString:@"Buyer"]){
        postData = [NSString stringWithFormat:@"user_id=%@&to_id=%@&device_id=%@&token=%@&item_id=%@&get_latest=0",
                          inBuyerId,inSellerId,inDeviceId,inToken,inItemId];
    }else{
        postData = [NSString stringWithFormat:@"user_id=%@&to_id=%@&device_id=%@&token=%@&item_id=%@&get_latest=0",
                    inSellerId,inBuyerId,inDeviceId,inToken,inItemId];
    }
//    NSString *postData = [NSString stringWithFormat:@"user_id=%@&device_id=%@&token=%@&item_id=%@",
//                          inSellerId,inDeviceId,inToken,inItemId];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

// NSURLConnection methods
/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
//    NSLog(@"%@" , htmlSTR);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(requestType1 == 0){
        sendStatus = true;
//        NSLog(@"%@" , htmlSTR);
        [self getNewMessage];
    }else if(requestType1 == 1){
        bool checkString = true;
        NSLog(@"%@" , htmlSTR);
        NSString *buyerPic = [[NSString alloc] init];
        NSString *s1 = [[NSString alloc] init];
        NSArray *fieldsArray1 = [jsonDictionary valueForKey:@"item"];
        for (NSDictionary *obj in fieldsArray1){
            NSString* profilePicPath = [obj valueForKey:@"photo1"];
            NSMutableString* theString;
            
            _profilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
            //        NSData *imageData;
            if([profilePicPath isEqual:@""]){
                theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_profilePhotoView setImageWithURL:[NSURL URLWithString:theString]
                                  placeholderImage:[UIImage imageNamed:@"laoding.gif"]];
            }else{
                NSString *tmpImagePath = profilePicPath;
                theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,tmpImagePath];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_profilePhotoView setImageWithURL:[NSURL URLWithString:theString]
                                  placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            }
            
            buyerPic = [NSString stringWithFormat:@"%@",[obj valueForKey:@"to_profile"]];
            
            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"condition"]] isEqualToString:@"0"]){
                _titleLabel.text = [NSString stringWithFormat:@"[USED] %@",[obj valueForKey:@"item_name"]];
            }else{
                _titleLabel.text = [NSString stringWithFormat:@"[NEW] %@",[obj valueForKey:@"item_name"]];
            }

            s1 = [obj valueForKey:@"item_name"];

            _descriptionLabel.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"description"]];
            _priceTextField.text = [NSString stringWithFormat:@"$%@",[obj valueForKey:@"price"]];
        }
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"responseCode"]] isEqualToString:@"2"]){
                checkString = false;
            }
            if(![s1 isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"item_owner_id"]]]){
                NSString* profilePicPath1 = buyerPic;
                NSMutableString* theString1 = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath1];
                _buyerProfilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
                [_buyerProfilePhotoView setImageWithURL:[NSURL URLWithString:theString1]
                                       placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            }
//            NSLog(@"fieldsarray count: %@",[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]);
//            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]] isKindOfClass:[NSNull class]]){
//                checkString = false;
//            }
            [_messageToId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]];
            [_messageContent addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_message"]]];
            [_messageFromId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_from_id"]]];
            [_messageTime addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_time"]]];
            [_messageFromName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"from_name"]]];
            [_messageToName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"to_name"]]];
            
//            NSString* profilePicPath1 = [NSString stringWithFormat:@"%@",[obj valueForKey:@"from_profile"]];
//            NSMutableString* theString1 = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath1];
//            _buyerProfilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
//            [_buyerProfilePhotoView setImageWithURL:[NSURL URLWithString:theString1]
//                                   placeholderImage:[UIImage imageNamed:@"loading.gif"]];

            
//            inItemId = [obj valueForKey:@"item_id"];
        }
//        NSLog(@"%d",[_searchProductResultProfilePic count]);
//        NSLog(@"%d",[_searchProductResultPrice count]);
//        NSLog(@"%d",[_searchProductResultTitle count]);
//        NSLog(@"%d",[_searchProductResultCondition count]);
//        NSLog(@"%d",[_searchProductResultAddress count]);
//        NSLog(@"%d",[_searchProductResultLikes count]);
//        NSLog(@"%d",[_searchProductResultDescription count]);
        
        if(checkString){
            UINib *cellNib = [UINib nibWithNibName:@"NibChatListItem" bundle:nil];
            [self.messageTable registerNib:cellNib forCellReuseIdentifier:@"com.privatechat.item"];
            
            self.messageTable.delegate = self;
            self.messageTable.dataSource = self;
            
            [self.messageTable reloadData];
        }
    }else if(requestType1 == 2){
        [self getNewMessage];
    }else if(requestType1 == 3){
        [self getNewMessage];
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
//(NSIndexPath *)indexPath {
//    return 75;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageFromId count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"com.privatechat.item";
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    UILabel *usernameLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *messageLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:3];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // User last activity date
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[_messageTime objectAtIndex:[indexPath row]]]];
    // Current date
    NSDate *now = [NSDate date];
    // Find difference in days
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:date toDate:now options:0];
//    NSLog(@"Date difference: %@",difference);
    if([difference day] >= 31){
        long numOfMonths = (long)[difference day]/31;
        if(numOfMonths >= 12){
            long numOfYears = numOfMonths/12;
            timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld years ago",numOfYears]];
        }else{
            timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld months ago",numOfMonths]];
        }
    }else{
        timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld days ago",(long)[difference day]]];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([[_messageFromId objectAtIndex:[indexPath row]] isEqualToString:[prefs stringForKey:@"pk"]])
        cell.contentView.backgroundColor=[UIColor whiteColor] ;
    else
        cell.contentView.backgroundColor=[UIColor colorWithRed:(153/255.0) green:(255/255.0) blue:(255/255.0) alpha:1] ;
    
    usernameLabel.text = [_messageFromName objectAtIndex:[indexPath row]];
    messageLabel.text = [_messageContent objectAtIndex:[indexPath row]];
//    timeLabel.text = [_messageTime objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)offerClick:(id)sender {
    // Post request
    requestType1 = 2;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/deals.offer/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"offered_by_id=%@&to_id=%@&item_id=%@&price_offered=%@&device_id=%@&token=%@",inBuyerId,inSellerId,inItemId,self.priceTextField.text,inDeviceId,inToken];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

- (void)dealClick:(id)sender {
    // Post request
    requestType1 = 3;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/deals.setStatus/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"offered_by_id=%@&user_id=%@&item_id=%@&status=1&device_id=%@&token=%@",inBuyerId,inSellerId,inItemId,inDeviceId,inToken];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request

}

- (void)sendClick:(id)sender {
    
    [self.messageTextBox resignFirstResponder];
    if ( [self.messageTextBox.text length] > 0 ) {
        
        // Post request
        requestType1 = 0;
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/chat.send/",appDelegate.apiUrl]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        //initialize a post data
        NSString *postData;
        if([inChatType isEqualToString:@"Buyer"]){
            postData = [NSString stringWithFormat:@"from_id=%@&to_id=%@&item_id=%@&message=%@&device_id=%@&token=%@",
                                  inBuyerId,inSellerId,inItemId,self.messageTextBox.text,inDeviceId,inToken];
        }else{
            postData = [NSString stringWithFormat:@"from_id=%@&to_id=%@&item_id=%@&message=%@&device_id=%@&token=%@",
                        inSellerId,inBuyerId,inItemId,self.messageTextBox.text,inDeviceId,inToken];
        }
    
        //set request content type we MUST set this value.
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //set post data of request
        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        
        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = connection;
        
        //start the connection
        [connection start];
        // Post request
    }
    
    self.messageTextBox.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
