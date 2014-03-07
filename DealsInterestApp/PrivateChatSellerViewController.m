//
//  PrivateChatSellerViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 28/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import "PrivateChatSellerViewController.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "PrivateChatViewController.h"

@interface PrivateChatSellerViewController ()

@property (nonatomic, strong) NSMutableArray *messageToId;
@property (nonatomic, strong) NSMutableArray *messageContent;
@property (nonatomic, strong) NSMutableArray *messageFromId;
@property (nonatomic, strong) NSMutableArray *messageTime;
@property (nonatomic, strong) NSMutableArray *messageFromName;
@property (nonatomic, strong) NSMutableArray *messageToName;
@property (nonatomic, strong) NSMutableArray *messageFromProfilePic;
@property (nonatomic, strong) NSMutableArray *messageFromPrice;
@property (nonatomic, strong) NSMutableArray *messageItemPhoto;
@property (nonatomic, strong) NSMutableArray *messageItemName;
@property (nonatomic, strong) NSMutableArray *messageItemDescription;
@property (nonatomic, strong) NSMutableArray *messageItemOwnerId;
@property (nonatomic, strong) NSMutableArray *messageItemId;

@end

@implementation PrivateChatSellerViewController

NSString *inSellerId;
NSString *inDeviceId;
NSString *inToken;
NSString *inItemId;

// 0 = get chat list
int connectPurpose = 0;

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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    inSellerId = [prefs stringForKey:@"pk"];
    inDeviceId = [prefs stringForKey:@"udid"];
    inToken = [prefs stringForKey:@"token"];
    inItemId = self.PCItemId;
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Private Chat";

    [self getChats];
}

- (void)getChats
{
    _messageToId = [[NSMutableArray alloc] init];
    _messageContent = [[NSMutableArray alloc] init];
    _messageFromId = [[NSMutableArray alloc] init];
    _messageTime = [[NSMutableArray alloc] init];
    _messageFromName = [[NSMutableArray alloc] init];
    _messageToName = [[NSMutableArray alloc] init];
    _messageFromProfilePic = [[NSMutableArray alloc] init];
    _messageFromPrice = [[NSMutableArray alloc] init];
    _messageItemPhoto = [[NSMutableArray alloc] init];
    _messageItemName = [[NSMutableArray alloc] init];
    _messageItemDescription = [[NSMutableArray alloc] init];
    _messageItemOwnerId = [[NSMutableArray alloc] init];
    _messageItemId = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    connectPurpose = 0;
    
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
    NSString *postData = [NSString stringWithFormat:@"user_id=%@&device_id=%@&token=%@&item_id=%@&get_latest=1",inSellerId,inDeviceId,inToken,inItemId];
    NSLog(@"user_id: %@",inSellerId);
    NSLog(@"device_id: %@",inDeviceId);
    NSLog(@"token: %@",inToken);
    NSLog(@"item_id: %@",inItemId);
    
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
    
    if(connectPurpose == 0){
        bool checkString = true;
        NSString *buyerPic = [[NSString alloc] init];
        NSString *s1 = [[NSString alloc] init];
        NSArray *fieldsArray1 = [jsonDictionary valueForKey:@"item"];
        for (NSDictionary *obj in fieldsArray1){
            NSString* profilePicPath = [obj valueForKey:@"photo1"];
            NSMutableString* theString;
            
            [_messageItemPhoto addObject:[NSString stringWithFormat:@"%@",profilePicPath]];
            
            _ItemProfilePicImageView.contentMode = UIViewContentModeScaleAspectFit;
            //        NSData *imageData;
            if([profilePicPath isEqual:@""]){
                theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_ItemProfilePicImageView setImageWithURL:[NSURL URLWithString:theString]
                                         placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            }else{
                NSString *tmpImagePath = profilePicPath;
                theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,tmpImagePath];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_ItemProfilePicImageView setImageWithURL:[NSURL URLWithString:theString]
                                         placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            }
            
            buyerPic = [NSString stringWithFormat:@"%@",[obj valueForKey:@"to_profile"]];
            
            [_messageItemName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"item_name"]]];
            
            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"condition"]] isEqualToString:@"0"]){
                _ItemNameLabel.text = [NSString stringWithFormat:@"[USED] %@",[obj valueForKey:@"item_name"]];
            }else{
                _ItemNameLabel.text = [NSString stringWithFormat:@"[NEW] %@",[obj valueForKey:@"item_name"]];
            }
            
            s1 = [NSString stringWithFormat:@"%@",[obj valueForKey:@"item_owner_id"]];
            [_messageItemOwnerId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"item_owner_id"]]];
            
            [_messageFromPrice addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"price"]]];
            
            [_messageItemDescription addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"description"]]];
            
            _ItemDescriptionLabel.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"description"]];
        }
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"responseCode"]] isEqualToString:@"2"]){
                checkString = false;
            }
//            if(![[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_from_id"]] isEqualToString:s1]){
                [_messageToId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]];
            NSLog(@"chat to id: %@",[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]);
            NSLog(@"chat from id: %@",[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_from_id"]]);
                [_messageContent addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_message"]]];
                [_messageFromId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_from_id"]]];
                [_messageTime addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_time"]]];
                [_messageToName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"to_name"]]];
                [_messageFromName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"from_name"]]];
                [_messageFromProfilePic addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"from_profile"]]];
                [_messageItemId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"item_id"]]];
//            }
            
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
            UINib *cellNib = [UINib nibWithNibName:@"NibSellerChatListItem" bundle:nil];
            [self.ChatListTableView registerNib:cellNib forCellReuseIdentifier:@"com.privatechatseller.item"];
            
            self.ChatListTableView.delegate = self;
            self.ChatListTableView.dataSource = self;
            
            [self.ChatListTableView reloadData];
        }
    }else if(connectPurpose == 1){
    
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // Declare view controller
    PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
    privateChatViewController.PCItemProfilePic = [_messageItemPhoto objectAtIndex:[indexPath row]];
    privateChatViewController.PCItemTitle = [_messageItemName objectAtIndex:[indexPath row]];
    privateChatViewController.PCItemDescription = [_messageItemDescription objectAtIndex:[indexPath row]];
    privateChatViewController.PCItemPrice = [_messageFromPrice objectAtIndex:[indexPath row]];
    privateChatViewController.PCBuyerProfilePic = [_messageFromProfilePic objectAtIndex:[indexPath row]];
    privateChatViewController.PCSellerId = [_messageItemOwnerId objectAtIndex:[indexPath row]];
    privateChatViewController.PCItemId = [_messageItemId objectAtIndex:[indexPath row]];
    privateChatViewController.PCChatType = @"Seller";
    privateChatViewController.PCBuyerId = [_messageFromId objectAtIndex:[indexPath row]];
    NSLog(@"sellerID: %@",[_messageItemOwnerId objectAtIndex:[indexPath row]]);
    NSLog(@"buyerID: %@",[_messageFromId objectAtIndex:[indexPath row]]);
    //    NSLog(@"Before PC: %@",PCPhotoURL);
    //    NSLog(@"Before PC: %@",PCTitle);
    //    NSLog(@"Before PC: %@",PCDescription);
    // Push view controller into view
    [self.navigationController pushViewController:privateChatViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageFromId count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"com.privatechatseller.item";
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:1];
    UIButton *usernameButton = (UIButton *)[cell viewWithTag:2];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *messageLabel = (UILabel *)[cell viewWithTag:4];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    // User last activity date
//    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[_messageTime objectAtIndex:[indexPath row]]]];
//    // Current date
//    NSDate *now = [NSDate date];
//    // Find difference in days
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:date toDate:now options:0];
//    NSLog(@"Date difference: %@",difference);
//    if([difference day] >= 31){
//        long numOfMonths = (long)[difference day]/31;
//        if(numOfMonths >= 12){
//            long numOfYears = numOfMonths/12;
//            timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld years ago",numOfYears]];
//        }else{
//            timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld months ago",numOfMonths]];
//        }
//    }else{
//        timeLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld days ago",(long)[difference day]]];
//    }
    
    [usernameButton setTitle:[_messageFromName objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    messageLabel.text = [_messageContent objectAtIndex:[indexPath row]];
    priceLabel.text = [NSString stringWithFormat:@"$%@",[_messageFromPrice objectAtIndex:[indexPath row]]];
    
    NSString* profilePicPath = [_messageFromProfilePic objectAtIndex:[indexPath row]];
    NSMutableString* theString;
    
    userImageView.contentMode = UIViewContentModeScaleAspectFit;
    if([profilePicPath isEqual:@""]){
        theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
        // Here we use the new provided setImageWithURL: method to load the web image
        [userImageView setImageWithURL:[NSURL URLWithString:theString]
                          placeholderImage:[UIImage imageNamed:@"laoding.gif"]];
    }else{
        NSString *tmpImagePath = profilePicPath;
        theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,tmpImagePath];
        // Here we use the new provided setImageWithURL: method to load the web image
        [userImageView setImageWithURL:[NSURL URLWithString:theString]
                          placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
