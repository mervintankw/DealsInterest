//
//  AppDelegate.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "AppDelegate.h"
#import "FollowViewController.h"
#import "ProfileMenuViewController.h"
#import "PKRevealController.h"
#import "SettingViewController.h"
#import "PrivateChatViewController.h"
#import "SBJsonParser.h"

//@implementation UINavigationBar (CustomImage)
//- (void)drawRect:(CGRect)rect {
//    UIImage *image = [UIImage imageNamed: @"background_focus.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//}
//@end

@implementation AppDelegate
@synthesize tabBarController = _tabBarController;
@synthesize homeViewController = _homeViewController;
@synthesize exploreViewController = _exploreViewController;
@synthesize postItemViewController = _postItemViewController;
@synthesize meViewController = _meViewController;
@synthesize settingViewController = _settingViewController;
@synthesize searchViewController = _searchViewController;
@synthesize activityViewController = _activityViewController;
@synthesize selectItemPhotoViewController = _selectItemPhotoViewController;

NSString *fromId;
NSString *toId;
NSString *itemId;
NSString *itemTitle;
NSString *itemPrice;
NSString *itemDescription;

bool appActive = false;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.notify = @"0";
    
    self.PCItemProfilePic = [[NSString alloc] init];
    self.PCItemTitle = [[NSString alloc] init];
    self.PCItemDescription = [[NSString alloc] init];
    self.PCItemPrice = [[NSString alloc] init];
    self.PCBuyerProfilePic = [[NSString alloc] init];
    self.PCBuyerId = [[NSString alloc] init];
    self.PCSellerId = [[NSString alloc] init];
    self.PCItemId = [[NSString alloc] init];
    
    self.loadProfilePurpose = [[NSString alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // global variables
//    _apiUrl = @"http://ec2-50-16-89-249.compute-1.amazonaws.com:8113/";
    _apiUrl = @"http://dealsinterest.cloudapp.net:8080/";
    _postItemPhotoCount = 0;
    
    // instantiate the view controllers:
    self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    self.homeViewController.categoryType = @"All";
    UINavigationController *homeNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    self.exploreViewController = [[ExploreViewController alloc] initWithNibName:nil bundle:nil];
//    UINavigationController *homeNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.exploreViewController];
//    self.searchViewController = [[SearchViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *searchNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.exploreViewController];
    
    self.postItemViewController = [[PostItemViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *postNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.postItemViewController];
//    self.selectItemPhotoViewController = [[SelectItemPhotoViewController alloc] initWithNibName:nil bundle:nil];
//    UINavigationController *postNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.selectItemPhotoViewController];
    
    self.meViewController = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *meNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.meViewController];
//    self.settingViewController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    self.activityViewController = [[ActivityViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *settingNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    
    // Set navigation bar color
    homeNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    searchNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    postNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    meNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    settingNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    
    // Set navigation bar text color
    homeNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    searchNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    postNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    meNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    settingNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    meNavigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onOpenButtonClick)];
    
//    [expNavigationController.navigationBar 
//    [expNavigationController ];
//    [expNavigationController.navigationBar setTintColor:[UIColor blueColor]];
//    [expNavigationController setEdgesForExtendedLayout:UIRectEdgeNone ];
//    [expNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_focus.png"] forBarMetrics:UIBarMetricsDefault];
    
    // set the titles for the view controllers:
//    self.homeViewController.title = @"Home";
    homeNavigationController.title = @"Browse";
//    self.exploreViewController.title = @"Explore";
    searchNavigationController.title = @"Catalogue";
//    self.postViewController.title = @"Post";
    postNavigationController.title = @"Snap!";
//    self.meViewController.title = @"Me";
    meNavigationController.title = @"Profile";
//    self.settingViewController.title = @"Setting";
    settingNavigationController.title = @"Activity";
    
    // set the images to appear in the tab bar:
//    self.homeViewController.tabBarItem.image = [UIImage imageNamed:@"home_tag.png"];
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"home_tag.png"];
//    self.exploreViewController.tabBarItem.image = [UIImage imageNamed:@"category.png"];
    searchNavigationController.tabBarItem.image = [UIImage imageNamed:@"Catalogue.png"];
//    self.postViewController.tabBarItem.image = [UIImage imageNamed:@"post_tag2.png"];
    postNavigationController.tabBarItem.image = [UIImage imageNamed:@"Sell.png"];
//    self.meViewController.tabBarItem.image = [UIImage imageNamed:@"me.png"];
    meNavigationController.tabBarItem.image = [UIImage imageNamed:@"Profile.png"];
//    self.settingViewController.tabBarItem.image = [UIImage imageNamed:@"setting_tag.png"];
    settingNavigationController.tabBarItem.image = [UIImage imageNamed:@"Activity.png"];
    
    // instantiate the tab bar controller:
    self.tabBarController = [[UITabBarController alloc] init];
    
    // set the tab bar’s view controllers array:
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             homeNavigationController,
                                             searchNavigationController,
                                             postNavigationController,
                                             settingNavigationController,
                                             meNavigationController,
                                             nil];
    
    
    // add the tab bar to the application window as a subview:
    [self.window addSubview:self.tabBarController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Step 1: Create your controllers.
    //    UINavigationController *homeViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    UIViewController *followViewController = [[FollowViewController alloc] init];
    UIViewController *profileMenuViewController = [[ProfileMenuViewController alloc] init];
    
    // Step 2: Configure an options dictionary for the PKRevealController if necessary - in most cases the default behaviour should suffice. See PKRevealController.h for more option keys.
    /*
     NSDictionary *options = @{
     PKRevealControllerAllowsOverdrawKey : [NSNumber numberWithBool:YES],
     PKRevealControllerDisablesFrontViewInteractionKey : [NSNumber numberWithBool:YES]
     };
     */
    
    // Step 3: Instantiate your PKRevealController.
    self.revealController = [PKRevealController revealControllerWithFrontViewController:_tabBarController
                                                                     leftViewController:followViewController
                             rightViewController:profileMenuViewController                                                                             options:nil];
    
    
    
    // Step 4: Set it as your root view controller.
    //self.window.rootViewController = self.revealController;
    
    self.loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    //NSString *a = @"hello";
    //if ([a isEqual: @"hello"]) {
    UINavigationController *loginNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    // Set navigation bar color
    loginNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    // Set navigation bar text color
    loginNavigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.window.rootViewController = loginNavigationController;
        [self.window addSubview:loginNavigationController.view];
    //} else {
//        self.window.rootViewController = self.revealController;
//        [self.window addSubview:self.revealController.view];
    //}
    
//    self.revealController = (PKRevealController *)self.window.rootViewController;
//    UIViewController *rightViewController = [[HomeViewController alloc] init];
//    MainNavViewController *frontViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"frontViewController"];
//    [self.revealController setFrontViewController:frontViewController];
//    [self.revealController setRightViewController:rightViewController];
    
    // call once is enough
//    [self.window makeKeyAndVisible];
    
    appActive = true;
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenString = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My chat token is: %@", tokenString);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:tokenString forKey:@"deviceToken"];
    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    NSLog(@"token: %@",[prefs stringForKey:@"token"]);
    NSLog(@"UDID: %@",[prefs stringForKey:@"udid"]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Push received: %@", userInfo);
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"data: %@",[userInfo valueForKey:@"data"]);
    NSDictionary *dataArray = [userInfo valueForKey:@"data"];
    
    NSLog(@"from id: %@",[dataArray valueForKey:@"from_id"]);
    NSLog(@"to id: %@",[dataArray valueForKey:@"to_id"]);
    NSLog(@"item id: %@",[dataArray valueForKey:@"item_id"]);
    fromId = [NSString stringWithFormat:@"%@",[dataArray valueForKey:@"from_id"]];
    toId = [NSString stringWithFormat:@"%@",[dataArray valueForKey:@"to_id"]];
    itemId = [NSString stringWithFormat:@"%@",[dataArray valueForKey:@"item_id"]];
    
//    for(NSDictionary *obj1 in userInfo){
//        NSLog(@"first layer: %@",obj1);
//        if([obj1 isEqual:@"data"]){
    // Declare view controller
//    PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
//    NSString *fieldsArray = [obj1 valueForKey:@"from_id"];
//    for (NSDictionary *obj in obj1){
//        NSLog(@"second layer: %@",obj);
//        fromId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"from_id"]];
//        toId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"to_id"]];
//        itemId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"item_id"]];
//        privateChatViewController.PCSellerId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"from_id"]];
//        privateChatViewController.PCItemId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"item_id"]];
//    }

    if(appActive == false){
        [self getChatInformation];
    }
    
//        }
    
//    PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
//    privateChatViewController.PCItemProfilePic = PCPhotoURL;
//    privateChatViewController.PCItemTitle = PCTitle;
//    privateChatViewController.PCItemDescription = PCDescription;
//    privateChatViewController.PCItemPrice = PCPrice;
//    privateChatViewController.PCBuyerProfilePic = PCBuyerPhotoURL;
//    privateChatViewController.PCSellerId = PCSellerId;
//    privateChatViewController.PCItemId = PCItemId;
//    privateChatViewController.PCChatType = @"Buyer";
    
//    [_settingViewController getNewMessages];
    
//    privateChatViewController.PCItemProfilePic = PCPhotoURL;
//    privateChatViewController.PCItemTitle = PCTitle;
//    privateChatViewController.PCItemDescription = PCDescription;
//    privateChatViewController.PCItemPrice = PCPrice;
//    privateChatViewController.PCBuyerProfilePic = PCBuyerPhotoURL;
//    privateChatViewController.PCSellerId = PCSellerId;
//    privateChatViewController.PCItemId = PCItemId;
    //    NSLog(@"Before PC: %@",PCPhotoURL);
    //    NSLog(@"Before PC: %@",PCTitle);
    //    NSLog(@"Before PC: %@",PCDescription);
    
//    [_homeViewController triggerPrivateChat:privateChatViewController];

//    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)getChatInformation {
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *postData;
//    NSString *currentUserId = [NSString stringWithFormat:@"%@",[prefs stringForKey:@"pk"]];
//    if([currentUserId isEqualToString:toId]){
        postData = [NSString stringWithFormat:@"user_id=%@&to_id=%@&item_id=%@&device_id=%@&token=%@",
                    toId,fromId,itemId,[prefs stringForKey:@"udid"],[prefs stringForKey:@"token"]];
    NSLog(@"fromId %@",fromId);
    NSLog(@"toId %@",toId);
    
    NSLog(@"postData: %@",postData);
//    }
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
    NSLog(@"%@" , htmlSTR);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
//    bool checkString = true;
    //        NSLog(@"%@" , htmlSTR);
    NSString *buyerPic = [[NSString alloc] init];
    NSString *s1 = [[NSString alloc] init];
    NSString* profilePicPath = [[NSString alloc] init];
    NSArray *fieldsArray1 = [jsonDictionary valueForKey:@"item"];
    for (NSDictionary *obj in fieldsArray1){
        profilePicPath = [obj valueForKey:@"photo1"];
        
        if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"condition"]] isEqualToString:@"0"]){
            itemTitle = [NSString stringWithFormat:@"[USED] %@",[obj valueForKey:@"item_name"]];
        }else{
            itemTitle = [NSString stringWithFormat:@"[NEW] %@",[obj valueForKey:@"item_name"]];
        }
        
        s1 = [NSString stringWithFormat:@"%@",[obj valueForKey:@"item_owner_id"]];
        
        buyerPic = [NSString stringWithFormat:@"%@",[obj valueForKey:@"to_profile"]];
        
        itemDescription = [NSString stringWithFormat:@"%@",[obj valueForKey:@"description"]];
        itemPrice = [NSString stringWithFormat:@"$%@",[obj valueForKey:@"price"]];
    }
    NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
    for (NSDictionary *obj in fieldsArray){
//        if(![s1 isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"item_owner_id"]]]){
//            NSString* profilePicPath1 = buyerPic;
//            NSMutableString* theString1 = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath1];
//            _buyerProfilePhotoView.contentMode = UIViewContentModeScaleAspectFit;
//            [_buyerProfilePhotoView setImageWithURL:[NSURL URLWithString:theString1]
//                                   placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//        }
        //            NSLog(@"fieldsarray count: %@",[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]);
        //            if([[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]] isKindOfClass:[NSNull class]]){
        //                checkString = false;
        //            }
//        [_messageToId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_to_id"]]];
//        [_messageContent addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_message"]]];
//        [_messageFromId addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_from_id"]]];
//        [_messageTime addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"chat_time"]]];
//        [_messageFromName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"from_name"]]];
//        [_messageToName addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"to_name"]]];
        
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
    
    _exploreViewController.PCItemProfilePic = profilePicPath;
    _exploreViewController.PCItemTitle = itemTitle;
    _exploreViewController.PCItemDescription = itemDescription;
    _exploreViewController.PCItemPrice = itemPrice;
    _exploreViewController.PCBuyerProfilePic = buyerPic;
    _exploreViewController.PCItemId = itemId;
    
    if([s1 isEqualToString:toId]){
        _exploreViewController.PCSellerId = toId;
        _exploreViewController.PCChatType = @"Buyer";
    }else{
        _exploreViewController.PCSellerId = fromId;
        _exploreViewController.PCChatType = @"Seller";
    }
    
    [_exploreViewController triggerPrivateChat];
//    [self.navigationController pushViewController:privateChatViewController animated:YES];
}
// NSURLConnection methods

- (void)userDidLogin
{
    [[self window] setRootViewController:self.revealController];
    [self.window addSubview:self.revealController.view];
}

- (void)userDidLogout
{
    self.loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    //NSString *a = @"hello";
    //if ([a isEqual: @"hello"]) {
    UINavigationController *loginNavigationController =  [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    // Set navigation bar color
    loginNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    // Set navigation bar text color
    loginNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.window.rootViewController = loginNavigationController;
    [self.window addSubview:loginNavigationController.view];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    appActive = false;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
