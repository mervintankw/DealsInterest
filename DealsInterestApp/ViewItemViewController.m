//
//  ViewItemViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 23/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "ViewItemViewController.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"
#import "QuartzCore/CALayer.h"
#import "UserProfileViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "PrivateChatViewController.h"
#import "PrivateChatSellerViewController.h"

@interface ViewItemViewController ()

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, strong) NSMutableArray *commentUserProfilePic;
@property (nonatomic, strong) NSMutableArray *commentUsername;
@property (nonatomic, strong) NSMutableArray *commentUserComment;

@end

@implementation ViewItemViewController

NSString *inItemId;
NSString *userId;
// 0 - Get item details
// 1 - Get user details
// 2 - Get comment details
// 3 - Send comment
// 4 - Get current user details
int requestType;
//PrivateChatViewController *privateChatViewController;
NSString *PCItemId;
NSString *PCPhotoURL;
NSString *PCTitle;
NSString *PCDescription;
NSString *PCPrice;
NSString *PCBuyerPhotoURL;
NSString *PCSellerId;
NSString *PCBuyerId;

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
    self.chatTextBox.delegate = self;
    
    [_tableView setRowHeight: 44.00];
    
//    privateChatViewController = [[PrivateChatViewController alloc] init];
    
    _commentUserProfilePic = [[NSMutableArray alloc] init];
    _commentUsername = [[NSMutableArray alloc] init];
    _commentUserComment = [[NSMutableArray alloc] init];
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"View Item";
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(keyboardWillShow:)
//     name:UIKeyboardWillShowNotification
//     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    
    _profilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Add view user profile button action control
    [_userProfileButton addTarget:self action:@selector(ViewUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dealBtn addTarget:self action:@selector(OpenPrivateChat:) forControlEvents:UIControlEventTouchUpInside];
    
    // Adds action control for segmented control
    [_toggleView addTarget:self action:@selector(segmentedControlSelectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    _infoView.hidden = false;
    _commentView.hidden = true;
    
    inItemId = self.itemId;
    PCItemId = self.itemId;
    _likesLabel.text = [NSString stringWithFormat:@"%@ likes",self.likesNo];
    
    [_sendChatButton addTarget:self action:@selector(sendCommentAction:) forControlEvents:UIControlEventTouchDown];
    
    requestType = 0;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%1$@json/browse.getItemBook/%2$@",appDelegate.apiUrl,inItemId]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
}

-(void)OpenPrivateChat:(UIButton *)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.PCItemId = PCItemId;
//    appDelegate.PCBuyerId = PCBuyerId;
//    appDelegate.PCSellerId = PCSellerId;
//    appDelegate.PCItemProfilePic = PCPhotoURL;
//    appDelegate.PCItemTitle = PCTitle;
//    appDelegate.PCItemDescription = PCDescription;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSLog(@"userid = %@",userId);
    NSLog(@"currentuserid = %@",[prefs stringForKey:@"pk"]);
    
    if([[NSString stringWithFormat:@"%@",userId] isEqualToString:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"pk"]]]){
        PrivateChatSellerViewController *privateChatSellerViewController = [[PrivateChatSellerViewController alloc] init];
        privateChatSellerViewController.PCItemProfilePic = PCPhotoURL;
        privateChatSellerViewController.PCItemTitle = PCTitle;
        privateChatSellerViewController.PCItemDescription = PCDescription;
        privateChatSellerViewController.PCItemPrice = PCPrice;
        privateChatSellerViewController.PCBuyerProfilePic = PCBuyerPhotoURL;
        privateChatSellerViewController.PCSellerId = PCSellerId;
        privateChatSellerViewController.PCItemId = PCItemId;
        [self.navigationController pushViewController:privateChatSellerViewController animated:YES];
    }else{
        // Declare view controller
        PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
        privateChatViewController.PCItemProfilePic = PCPhotoURL;
        privateChatViewController.PCItemTitle = PCTitle;
        privateChatViewController.PCItemDescription = PCDescription;
        privateChatViewController.PCItemPrice = PCPrice;
        privateChatViewController.PCBuyerProfilePic = PCBuyerPhotoURL;
        privateChatViewController.PCSellerId = PCSellerId;
        privateChatViewController.PCItemId = PCItemId;
        privateChatViewController.PCChatType = @"Buyer";
        //    NSLog(@"Before PC: %@",PCPhotoURL);
        //    NSLog(@"Before PC: %@",PCTitle);
        //    NSLog(@"Before PC: %@",PCDescription);
        // Push view controller into view
        [self.navigationController pushViewController:privateChatViewController animated:YES];
    }
}

-(void)sendCommentAction:(UIButton *)sender {
    // Close keyboard on submitting of comment
    [_chatTextBox resignFirstResponder];
    // Validate user input
    if([_chatTextBox.text isEqualToString:@""]){
        // Create alert message
        UIAlertView *commentFailed = [[UIAlertView alloc] initWithTitle:@"Comment Failed"
                                                              message:@"Please enter a comment!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        // Display alert message
        [commentFailed show];
    }else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // This part is getting all the items from server.
        // Post request
        requestType = 3;
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/comment.insert/",appDelegate.apiUrl]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        //initialize a post data
        NSString *postData = [NSString stringWithFormat:@"item_id=%@&user_id=%@&device_id=%@&token=%@&name=%@&comment=%@&replyto_id=%@&replyto_id_android=%@",
                              inItemId,[prefs stringForKey:@"pk"],
                              [prefs stringForKey:@"udid"],[prefs stringForKey:@"token"],[prefs stringForKey:@"user_name"],_chatTextBox.text,userId,userId];
        
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
        // Clear textbox
        _chatTextBox.text = @"";
    }
}

// Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentUsername count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *usernameData = [_commentUsername objectAtIndex:indexPath.row];
    NSString *commentData = [_commentUserComment objectAtIndex:indexPath.row];
    NSString *profilePicData = [_commentUserProfilePic objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"com.itemcomment.cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *profilePicImageView = (UIImageView *)[cell viewWithTag:300];
    UILabel *usernameLabel = (UILabel *)[cell viewWithTag:301];
    UILabel *commentLabel = (UILabel *)[cell viewWithTag:302];
    
    usernameLabel.text = usernameData;
    commentLabel.text = commentData;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableString *theString;
    NSString* profilePicPath = profilePicData;
    if([profilePicPath isEqualToString:@""]){
        theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
        // Here we use the new provided setImageWithURL: method to load the web image
        [profilePicImageView setImageWithURL:[NSURL URLWithString:theString]
                placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    }else{
        theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,profilePicPath];
        // Here we use the new provided setImageWithURL: method to load the web image
        [profilePicImageView setImageWithURL:[NSURL URLWithString:theString]
                            placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    }
    
    return cell;
}
// Table view methods

// Collection view methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.photoArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.photoArray objectAtIndex:section];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoData = [self.photoArray objectAtIndex:indexPath.section];
    NSString *cellData = [photoData objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"com.itemview.cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *productImageView = (UIImageView *)[cell viewWithTag:100];
    productImageView.contentMode = UIViewContentModeScaleAspectFit;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if(![cellData isEqualToString:@""]){
    NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,cellData];
    NSLog(@"Photo Collection: %@",cellData);
    // Here we use the new provided setImageWithURL: method to load the web image
    [productImageView setImageWithURL:[NSURL URLWithString:theString]
                     placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//    // Multi-threading
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // Background thread running
//        NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//        UIImage *theImage=[UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Main thread updating GUI
//            productImageView.image=theImage;
//        });
//    });
//    }
    return cell;
}
// Collection view methods

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
    NSLog(@"%@" , htmlSTR);
    NSMutableArray *photoSection = [[NSMutableArray alloc] init];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    
    if(requestType == 0){
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            userId = [obj valueForKey:@"user_id"];
            PCSellerId = userId;
            if(![[obj valueForKey:@"photo1"] isEqual:@""])
                [photoSection addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo1"]]];
            if(![[obj valueForKey:@"photo2"] isEqual:@""])
                [photoSection addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo2"]]];
            if(![[obj valueForKey:@"photo3"] isEqual:@""])
                [photoSection addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo3"]]];
            if(![[obj valueForKey:@"photo4"] isEqual:@""])
                [photoSection addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo4"]]];
            if(![[obj valueForKey:@"photo5"] isEqual:@""])
                [photoSection addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo5"]]];
            
            // Populate title label
            PCTitle = [obj valueForKey:@"title"];
            _titleLabel.text = PCTitle;
//            privateChatViewController.PCItemTitle = [obj valueForKey:@"title"];
            
            // Populate price label
            PCPrice = [NSString stringWithFormat:@"$%@",[obj valueForKey:@"price"]];
            _priceLabel.text = PCPrice;
            // Populate description label
            PCDescription = [obj valueForKey:@"description"];
            _descriptionLabel.text = PCDescription;
//            privateChatViewController.PCItemDescription = [obj valueForKey:@"description"];
    //        CGSize labelSize = [_descriptionLabel.text sizeWithFont:_descriptionLabel.font
    //                                constrainedToSize:_descriptionLabel.frame.size
    //                                    lineBreakMode:_descriptionLabel.lineBreakMode];
    //        _descriptionLabel.frame = CGRectMake(
    //                                             _descriptionLabel.frame.origin.x, _descriptionLabel.frame.origin.y,
    //                                             _descriptionLabel.frame.size.width, labelSize.height);
            // Populate location label
            _locationLabel.text = [obj valueForKey:@"location_address"];
            
            // Populate item cover pic
            NSString* profilePicPath = [obj valueForKey:@"photo1"];
            PCPhotoURL = profilePicPath;
            NSLog(@"%@",profilePicPath);
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableString* theString;
//            privateChatViewController.PCItemProfilePic = profilePicPath;
            
            _photo1.contentMode = UIViewContentModeScaleAspectFit;
    //        NSData *imageData;
            if([profilePicPath isEqual:@""]){
                theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_photo1 setImageWithURL:[NSURL URLWithString:theString]
                                 placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//                // Multi-threading
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    // Background thread running
//                    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//                    UIImage *theImage=[UIImage imageWithData:data];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Main thread updating GUI
//                        _photo1.image = theImage;
//                    });
//                });
    //            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
    //            _photo1.image = [UIImage imageWithData:imageData];
            }else{
                NSString *tmpImagePath = profilePicPath;
    //            profilePicPath = @"uploads/1376303779_11122608.jpg";
                theString = [NSMutableString stringWithFormat:@"%@%@",appDelegate.apiUrl,tmpImagePath];
                // Here we use the new provided setImageWithURL: method to load the web image
                [_photo1 setImageWithURL:[NSURL URLWithString:theString]
                        placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//                // Multi-threading
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    // Background thread running
//                    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//                    UIImage *theImage=[UIImage imageWithData:data];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Main thread updating GUI
//                        _photo1.image = theImage;
//                    });
//                });
    //            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
    //            _photo1.image = [UIImage imageWithData:imageData];
            }
    //        NSLog(@"%@",theString);
    //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            
        }
        
        self.photoArray = [[NSArray alloc] initWithObjects:photoSection, nil];
        
        UINib *cellNib = [UINib nibWithNibName:@"NibViewItemCell" bundle:nil];
        [self.photoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.itemview.cell"];
        
        self.photoCollectionView.delegate = self;
        self.photoCollectionView.dataSource = self;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(174, 138)];
        [flowLayout setMinimumInteritemSpacing:0.1];
        [flowLayout setMinimumLineSpacing:0.1];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //    [self.collectionView setContentOffset:CGPointZero animated:YES];
        [self.photoCollectionView setCollectionViewLayout:flowLayout];
        
        // Call get user info method
        [self getUserInfo:userId];
    }else if(requestType == 1){
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            // Populate user name
            [_userProfileButton setTitle:[NSString stringWithFormat:@"%@",[obj valueForKey:@"user_name"]] forState:UIControlStateNormal];
            _usernameLabel.text = [obj valueForKey:@"user_name"];
            // Populate profile picture
            NSString* profilePicPath = [obj valueForKey:@"profile_pic"];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath];
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            [_profilePhotoView setImageWithURL:[NSURL URLWithString:theString]
                             placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//            [_chatUserProfile setImageWithURL:[NSURL URLWithString:theString]
//                              placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//            _profilePhotoView.image = [UIImage imageWithData:imageData];
//            _chatUserProfile.image = [UIImage imageWithData:imageData];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            // User last activity date
            NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"last_visit_date"]]];
            // Current date
            NSDate *now = [NSDate date];
            // Find difference in days
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:date toDate:now options:0];
            NSLog(@"Date difference: %@",difference);
            if([difference day] >= 31){
                long numOfMonths = (long)[difference day]/31;
                if(numOfMonths >= 12){
                    long numOfYears = numOfMonths/12;
                    _lastActivityLabel.text = [NSString stringWithFormat:@"%ld years ago",numOfYears];
                }else{
                    _lastActivityLabel.text = [NSString stringWithFormat:@"%ld months ago",numOfMonths];
                }
            }else{
                _lastActivityLabel.text = [NSString stringWithFormat:@"%ld days ago",(long)[difference day]];
            }
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        PCBuyerId = [prefs stringForKey:@"pk"];
        // Call get current user info method
        [self getCurrentUserInfo:[prefs stringForKey:@"pk"]];
    }else if(requestType == 2){
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            [_commentUsername addObject:[NSString stringWithFormat:@"%@", [obj valueForKey:@"name"]]];
            [_commentUserComment addObject:[NSString stringWithFormat:@"%@", [obj valueForKey:@"comment"]]];
            [_commentUserProfilePic addObject:[NSString stringWithFormat:@"%@", [obj valueForKey:@"profile_pic"]]];
        }
        
        NSString *firstUsername = [_commentUsername objectAtIndex:0];
        NSString *firstComment = [_commentUserComment objectAtIndex:0];
        NSString *firstProfilePic = [_commentUserProfilePic objectAtIndex:0];
        if(!([firstUsername isEqualToString:@"<null>"]) &&
           !([firstComment isEqualToString:@"<null>"]) &&
           !([firstProfilePic isEqualToString:@"<null>"])){
            UINib *cellNib = [UINib nibWithNibName:@"NibItemCommentCell" bundle:nil];
            [_tableView registerNib:cellNib forCellReuseIdentifier:@"com.itemcomment.cell"];
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            
            [_tableView reloadData];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationRight];
//            [_tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
        }
    }else if(requestType == 3){
        for(NSDictionary *obj in jsonDictionary){
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
                // Update table with new comments
//                [_tableView reloadData];
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationRight];
                [self LoadView];
                _infoView.hidden = true;
                _commentView.hidden = false;
//                [_tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
        }else{
                // Create alert message
                UIAlertView *commentFailed = [[UIAlertView alloc] initWithTitle:@"Comment Failed"
                                                                        message:@"Please enter a valid input!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                // Display alert message
                [commentFailed show];
            }
        }
    }else if(requestType == 4){
        NSArray *colorTitles = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in colorTitles){
            //objValue = obj;
            //NSLog(@"obj: %@", [obj valueForKey:@"email"]);
            
            // Populate profile picture
            PCBuyerPhotoURL = [obj valueForKey:@"profile_pic"];
            NSString* profilePicPath = PCBuyerPhotoURL;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath];
            // Here we use the new provided setImageWithURL: method to load the web image
            [_chatUserProfile setImageWithURL:[NSURL URLWithString:theString]
                        placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        }
        
        // Retrieve comments for product
        requestType = 2;
        
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%1$@json/comment.getByItem/%2$@",appDelegate.apiUrl,inItemId]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = connection;
        
        //start the connection
        [connection start];
    }
}
// NSURLConnection methods

- (void)getUserInfo:(NSString *)inId{
    requestType = 1;
    
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%1$@json/user.getUserById/%2$@",appDelegate.apiUrl,inId]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
}

- (void)getCurrentUserInfo:(NSString *)inId{
    requestType = 4;
    
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%1$@json/user.getUserById/%2$@",appDelegate.apiUrl,inId]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
}

- (IBAction)ViewUserProfileClick:(UIButton *)sender
{
    // Declare user profile view controller
    UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] init];
    // Set user id selected into user profile view controller variable
    userProfileViewController.postUserId = userId;
    // Push view controller into view
    [self.navigationController pushViewController:userProfileViewController animated:YES];

}

- (IBAction)segmentedControlSelectedIndexChanged:(UISegmentedControl*)segmentedControl
{
    if(segmentedControl.selectedSegmentIndex == 0){
        _infoView.hidden = false;
        _commentView.hidden = true;
    }
    if(segmentedControl.selectedSegmentIndex == 1){
        _infoView.hidden = true;
        _commentView.hidden = false;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.chatTextBox) {
        [theTextField resignFirstResponder];
    }
    // Close keyboard on submitting of comment
    [_chatTextBox resignFirstResponder];
//    // Validate user input
//    if([_chatTextBox.text isEqualToString:@""]){
//        // Create alert message
//        UIAlertView *commentFailed = [[UIAlertView alloc] initWithTitle:@"Comment Failed"
//                                                                message:@"Please enter a comment!"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//        // Display alert message
//        [commentFailed show];
//    }else{
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        // This part is getting all the items from server.
//        // Post request
//        requestType = 3;
//        //if there is a connection going on just cancel it.
//        [self.connection cancel];
//        
//        //initialize new mutable data
//        NSMutableData *data = [[NSMutableData alloc] init];
//        self.receivedData = data;
//        
//        //initialize url that is going to be fetched.
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/comment.insert/",appDelegate.apiUrl]];
//        
//        //initialize a request from url
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
//        
//        //set http method
//        [request setHTTPMethod:@"POST"];
//        //initialize a post data
//        NSString *postData = [NSString stringWithFormat:@"item_id=%@&user_id=%@&device_id=%@&token=%@&name=%@&comment=%@&replyto_id=%@&replyto_id_android=%@",
//                              inItemId,[prefs stringForKey:@"pk"],
//                              [prefs stringForKey:@"udid"],[prefs stringForKey:@"token"],[prefs stringForKey:@"user_name"],_chatTextBox.text,userId,userId];
//        
//        //set request content type we MUST set this value.
//        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        
//        //set post data of request
//        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        //initialize a connection from request
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        self.connection = connection;
//        
//        //start the connection
//        [connection start];
//        // Post request
//        
//        // Clear textbox
//        _chatTextBox.text = @"";
//    }
    return YES;
}

// Method trigger whenever use touches somewhere other than the keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.contentScrollView endEditing:YES];
    [self.overallView endEditing:YES];
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

//- (void)keyboardWillShow:(NSNotification*)notification
//{
//    // Step 1: Get the size of the keyboard.
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
//    NSLog(@"Keyboard height: %f",keyboardSize.height);
//    _contentScrollView.contentInset = contentInsets;
//    _contentScrollView.scrollIndicatorInsets = contentInsets;
//    // Step 3: Scroll the target text field into view.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= keyboardSize.height;
//    if (!CGRectContainsPoint(aRect, _chatTextBox.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, 0.0);
//        [_contentScrollView setContentOffset:scrollPoint animated:YES];
//    }
//}

-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    
    if (diff < 0)
        [self scrollToY:diff];
    
    else
        [self scrollToY:0];
}

-(void)scrollToY:(float)y
{
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.view.transform = CGAffineTransformMakeTranslation(0, y);
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.view.frame.origin.y == 0)
        [self scrollToY:-170.0];  // y can be changed to your liking
    
}

-(void)keyboardWillHide:(NSNotification*)note
{
    [self scrollToY:0];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
