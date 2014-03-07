//
//  HomeViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "QuartzCore/CALayer.h"
#import "HomeViewController.h"
#import "FollowViewController.h"
#import "PKRevealController.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "UITabBarController+hidable.h"
#import "ViewItemViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//#define CELL_WIDTH 150
//#define CELL_COUNT 10
//#define CELL_IDENTIFIER @"WaterfallCell"

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray *cellHeights;

@property (nonatomic, strong) NSArray *pkArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *likeArray;
@property (nonatomic, strong) NSArray *commentArray;

@property (nonatomic, strong) NSCache *cacheImages;

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation HomeViewController{
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
//    NSMutableArray *pkData;
//    NSCache *cacheImages;
    NSMutableArray *trackLoadArray;
    NSMutableArray *viewSectionData;
    NSMutableArray *viewData;
    NSMutableArray *viewImageData;
    NSMutableArray *itemIdArray;
    NSMutableArray *favouritePkArray;
    // 0 for getting favourite item list
    // 1 for getting all items
    // 2 for inserting favourite item
    // 3 for removing favourite item
    int connectPurpose;
    // 0 for loading popular items
    // 1 for loading latest items
    // 2 for loading nearby items
    // 3 for loading following itmes
    int loadPurpose;
    
    int lastIndexLoaded;
    NSString *currentItemId;
    
    // Hide tab bar
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
    // Hide tab bar
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.cellWidth = CELL_WIDTH;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        // Hide tab bar
        hidden = NO;
        // Hide tab bar
    }
    return self;
}

//- (void)viewWillLayoutSubviews;
//{
//    [super viewWillLayoutSubviews];
//    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
//    
//    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
//        flowLayout.itemSize = CGSizeMake(170.f, 170.f);
//    } else {
//        flowLayout.itemSize = CGSizeMake(192.f, 192.f);
//    }
//    
//    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
//}

UIRefreshControl *refreshControl;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _myLabel.textColor = [UIColor whiteColor];
    
    // use existing instantiated view inside view controller;
    // ensure autosizing enabled
    self.mainView.autoresizesSubviews = YES;
    self.mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    _collectionView.autoresizesSubviews = YES;
//    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
//    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    
//    CGRect bounds = [self.collectionView bounds];
//    [self.collectionView setBounds:CGRectMake(bounds.origin.x,
//                                              bounds.origin.y,
//                                              bounds.size.width,
//                                              bounds.size.height + 10)];
    
//    CGRect frame1 = [self.collectionView frame];
//    [self.collectionView setFrame:CGRectMake(frame1.origin.x,
//                                             frame1.origin.y,
//                                             frame1.size.width,
//                                             frame1.size.height + 500)];
    
//    CGRect frame1 = self.collectionView.frame;
//    frame1.size.height += 10;
//    self.collectionView.frame = frame1;
    
    self.collectionView.clipsToBounds = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    trackLoadArray = [[NSMutableArray alloc] init];
    
    _cacheImages = [[NSCache alloc] init];
    lastIndexLoaded = 0;
    
    // Load location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
//    label.text = @"Home";
    label.text = _categoryType;
    
    self.collectionView.alwaysBounceVertical = YES;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    refreshControl.tintColor = [UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    /*
     Configuration for loading indicator
     */
    // make the area larger
    [_loadProductIndicator setFrame:self.view.frame];
    // set a background color
    [_loadProductIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    CGPoint center = self.view.center;
    _loadProductIndicator.center = center;
    /*
     Configuration for loading indicator
     */
    
    // This part onwards is getting the current user's favourite items
    favouritePkArray = [[NSMutableArray alloc] init];
    
    loadPurpose = 1;
    [self populateData];
    
    
    
//    // Post request
//    //if there is a connection going on just cancel it.
//    [self.connection cancel];
//    
//    //initialize new mutable data
//    data = [[NSMutableData alloc] init];
//    self.receivedData = data;
//    
//    //initialize url that is going to be fetched.
//    url = [NSURL URLWithString:@"http://ec2-54-224-4-212.compute-1.amazonaws.com:8113/json/browse.getItemList/"];
//    
//    //initialize a request from url
//    request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
//    
//    //set http method
//    [request setHTTPMethod:@"POST"];
//    //initialize a post data
//    postData = @"category=outdoors&price_low=0&price_high=10000&limit_low=100";
//    //set request content type we MUST set this value.
//    
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    //set post data of request
//    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //initialize a connection from request
//    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    self.connection = connection;
//    
//    //start the connection
//    [connection start];
//    // Post request
    
    
//    UIImage *revealImagePortrait = [UIImage imageNamed:@"reveal_menu_icon_portrait.png"];
//    UIImage *revealImageLandscape = [UIImage imageNamed:@"reveal_menu_icon_landscape.png"];
//    
//    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
//    {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait landscapeImagePhone:revealImageLandscape style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView:)];
//    }
//    
//    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
//    {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait landscapeImagePhone:revealImageLandscape style:UIBarButtonItemStylePlain target:self action:@selector(showRightView:)];
//    }
    
    //self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //self.tableView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
    //[self.view addSubview:self.tableView];
    
//    // Initialize view data
//    viewData = [NSMutableArray arrayWithObjects:@"Steve Jobs", @"Tim Cook", nil];
//    // Initialize view image data
//    viewImageData = [NSMutableArray arrayWithObjects:@"steve_jobs_profile_pic.png", @"tim_cook_profile_pic.png", nil];
//    // Initialize view section data
//    viewSectionData = [NSMutableArray arrayWithObject:nil]
    
       
//    NSLog(@"%d",firstSection.count);
//    [self.view addSubview:self.collectionView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:hidden
                                             animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController setTabBarHidden:hidden
                                  animated:NO];
}

- (IBAction)segmentedControlSelectedIndexChanged:(UISegmentedControl*)segmentedControl
{
    if(segmentedControl.selectedSegmentIndex == 0){
        NSLog(@"popular");
    }
    if(segmentedControl.selectedSegmentIndex == 1){
        loadPurpose = 1;
        [self populateData];
        //reload collection view data
        [self.collectionView reloadData];
    }
    if(segmentedControl.selectedSegmentIndex == 2){
        loadPurpose = 2;
        [self populateData];
        //reload collection view data
        [self.collectionView reloadData];
    }
    if(segmentedControl.selectedSegmentIndex == 3){
        loadPurpose = 3;
        [self populateData];
        //reload collection view data
        [self.collectionView reloadData];
    }
}

int tapCount;
NSIndexPath *tableSelection;
NSString *selectedTitle;
NSString *likesNo;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    tableSelection = indexPath;
    tapCount++;
    NSMutableArray *data = [self.pkArray objectAtIndex:indexPath.section];
    NSMutableArray *likeData = [self.likeArray objectAtIndex:indexPath.section];
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *likeCellData = [likeData objectAtIndex:indexPath.row];
    NSLog(@"Selected index: %@",cellData);
    switch (tapCount) {
        case 1: //single tap
            selectedTitle = cellData;
            likesNo = likeCellData;
            [self performSelector:@selector(singleTap) withObject: nil afterDelay: .4];
            break;
            NSLog(@"Single tap!");
            break;
        case 2: //double tap
            selectedTitle = cellData;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [self performSelector:@selector(doubleTap) withObject: nil];
            NSLog(@"Double tap!");
            break;
    }
}
- (void)singleTap {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Single tap detected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    tapCount = 0;
    
    // Unhide tab bar if its hidden
    if(hidden){
        hidden = NO;
        [self.tabBarController setTabBarHidden:NO animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    // Declare view item view controller
    ViewItemViewController *viewItemViewController = [[ViewItemViewController alloc] init];
    // Set category selected into post item view controller variable
    NSLog(@"%@",selectedTitle);
    viewItemViewController.itemId = selectedTitle;
    viewItemViewController.likesNo = likesNo;
    // Push view controller into view
    [self.navigationController pushViewController:viewItemViewController animated:YES];
}
- (void)doubleTap {
//    NSUInteger row = [tableSelection row];
//    companyName = [self.suppliers objectAtIndex:row];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"DoubleTap" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles: nil];
//    [alert show];
    currentItemId = selectedTitle;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // This part is getting all the items from server.
    // Post request
    connectPurpose = 2;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/favourite.insert/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSLog(@"Token: %@",[prefs stringForKey:@"udid"]);
    NSString *postData = [NSString stringWithFormat:@"item_id=%@&user_id=%@&device_id=%@&token=%@",
                          selectedTitle,[prefs stringForKey:@"pk"],
                          [prefs stringForKey:@"udid"],[prefs stringForKey:@"token"]];
    
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

    tapCount = 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
//    return [sectionArray count];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"hello");
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    NSMutableArray *priceData = [self.priceArray objectAtIndex:indexPath.section];
    NSMutableArray *imageData = [self.imageArray objectAtIndex:indexPath.section];
    NSMutableArray *likeData = [self.likeArray objectAtIndex:indexPath.section];
    NSMutableArray *commentData = [self.commentArray objectAtIndex:indexPath.section];
    NSMutableArray *pkData = [self.pkArray objectAtIndex:indexPath.section];
//    NSLog(@"%d %d",indexPath.row,data.count);
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *cellPriceData = [priceData objectAtIndex:indexPath.row];
    NSString *cellImageData = [imageData objectAtIndex:indexPath.row];
    NSString *cellLikeData = [likeData objectAtIndex:indexPath.row];
    NSString *cellCommentData = [commentData objectAtIndex:indexPath.row];
    NSString *cellPkData = [pkData objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"com.productview.cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:101];
    UIImageView *productImageView = (UIImageView *)[cell viewWithTag:102];
//    UIButton *productBtn = (UIButton *)[cell viewWithTag:103];
    UILabel *likeLabel = (UILabel *)[cell viewWithTag:103];
    UILabel *commentLabel = (UILabel *)[cell viewWithTag:104];
    UIButton *likeBtn = (UIButton *)[cell viewWithTag:105];
    UIButton *commentBtn = (UIButton *)[cell viewWithTag:106];
    UIImageView *likeImageView = (UIImageView *)[cell viewWithTag:107];
    
    if([cellData isKindOfClass:[NSString class]]){
        [likeBtn setTitle:cellPkData forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchDown];
        // Populate product title label
        titleLabel.text = cellData;
        // Populate product price label
        priceLabel.layer.cornerRadius = 8;
        priceLabel.text = cellPriceData;
        // Populate like label
        for(NSString *obj in favouritePkArray){
            if(cellPkData == obj){
                [likeImageView setImage:[UIImage imageNamed: @"heart_tag_red.png"]];
            }
        }
        likeLabel.text = cellLikeData;
        // Populate comment label
        commentLabel.text = cellCommentData;
        
        productImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"%@",cellData);
    }else{
        titleLabel.hidden = true;
        priceLabel.hidden = true;
        productImageView.hidden = true;
        likeLabel.hidden = true;
        commentLabel.hidden = true;
        likeBtn.hidden = true;
        likeImageView.hidden = true;
        commentBtn.hidden = true;
    }
    
//    cell.tag = indexPath.row;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    productImageView.image = nil;
    // Check for products with no image
    if(![cellImageData isEqual: @"noimage"]){
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,cellImageData];
//        if(indexPath.row == 0){
//            NSLog(@"first data: %@",cellImageData);
//        }
            //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://wallgood.com/wp-content/uploads/2013/07/Jackie-Chan-Meme-Template.jpg"];
        
            // Here we use the new provided setImageWithURL: method to load the web image
            [productImageView setImageWithURL:[NSURL URLWithString:theString]
                   placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        
            // Multi-threading
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                // Background thread running
//                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//                UIImage *theImage=[UIImage imageWithData:data];
//                if(theImage){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if(cell.tag == indexPath.row) {
//                            if([data isEqualToData:[_cacheImages objectForKey:theString]]){
//                                productImageView.image=theImage;
//                                NSLog(@"Loading cached image");
//                            }else{
//                                // Main thread updating GUI
//                                [_cacheImages setObject:data forKey:theString];
//                                productImageView.image=theImage;
//                            }
//                        }
//                    });
//                }
//            });
        //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
        //        productImageView.image = [UIImage imageWithData:imageData];
        // Display default image if there is not image for product
    }else{
//        NSMutableString* theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
//        //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://www.bubblews.com/assets/images/news/763574121_1373118355.jpg"];
//        
//        // Multi-threading
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // Background thread running
//            NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//            UIImage *theImage=[UIImage imageWithData:data];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Main thread updating GUI
//                productImageView.image=theImage;
//            });
//        });
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//        productImageView.image = [UIImage imageWithData:imageData];
    }
    
    bool checkExist = true;
    for(NSString *obj in trackLoadArray){
        if([obj isEqualToString:[NSString stringWithFormat:@"%d",indexPath.row]]){
            checkExist = false;
        }else{
            
        }
    }
    if(checkExist){
        [trackLoadArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        
    }
//    NSLog(@"count: %d",trackLoadArray.count);
    
//    if(indexPath.row==lastIndexLoaded-1){
//        NSLog(@"populating more data! %d %d",indexPath.row,lastIndexLoaded);
//        [self populateData];
//    }
    
//    NSLog(@"go %d",indexPath.row);
    [_loadProductIndicator stopAnimating];
    
    return cell;
}

-(void)likeAction:(UIButton *)sender {
    NSLog(@"Item %@ liked.",sender.currentTitle);
    
    currentItemId = sender.currentTitle;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    
    // This part is getting all the items from server.
    // Post request
    connectPurpose = 2;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/favourite.insert/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"item_id=%@&user_id=%@&device_id=%@&token=%@",
                          sender.currentTitle,[prefs stringForKey:@"pk"],
                          [prefs stringForKey:@"udid"],[prefs stringForKey:@"token"]];
    
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
-(void)populateData{
    // Post request
    connectPurpose = 0;
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    NSLog(@"username: %@",[prefs stringForKey:@"user_name"]);
    NSLog(@"email: %@",[prefs stringForKey:@"email"]);
    
    //initialize url that is going to be fetched.
    NSString *pPk = [prefs stringForKey:@"pk"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"%@",[NSString stringWithFormat:@"%1$@json/user.getUserById/%2$@",appDelegate.apiUrl,pPk]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%1$@json/user.getUserById/%2$@",appDelegate.apiUrl,pPk]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
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
    [_loadProductIndicator startAnimating];
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
//    NSLog(@"%@" , htmlSTR);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    
    if(connectPurpose == 1){
        NSLog(@"Loading items ...");
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        NSArray *pkDataArray = [jsonDictionary valueForKey:@"pk"];
        
        NSMutableArray *firstSection = [[NSMutableArray alloc] init];
        NSMutableArray *priceSection = [[NSMutableArray alloc] init];
        NSMutableArray *imageSection = [[NSMutableArray alloc] init];
        NSMutableArray *likeSection = [[NSMutableArray alloc] init];
        NSMutableArray *commentSection = [[NSMutableArray alloc] init];
        NSMutableArray *pkSection = [[NSMutableArray alloc] init];
        
        NSString *titleArray;
        NSString *priceArray;
        NSString *imageArray;
        NSString *likeArray;
        NSString *commentArray;
        NSString *pkArray;
        
        // Store pk of items
        for (NSString *obj in pkDataArray){
            pkArray = obj;
            NSLog(@"PK ID: %@",obj);
            [pkSection addObject:[NSString stringWithFormat:@"%@", pkArray]];
        }
            
        for (NSDictionary *obj in fieldsArray){
            titleArray = [obj valueForKey:@"title"];
            priceArray = [obj valueForKey:@"price"];
            imageArray = [obj valueForKey:@"photo1"];
            likeArray = [obj valueForKey:@"like_no"];
            commentArray = [obj valueForKey:@"comment_no"];
            
            if([imageArray isEqual:@""])
                imageArray = @"noimage";
    //        NSLog(@"%@",imageArray);
            [firstSection addObject:[NSString stringWithFormat:@"%@", titleArray]];
            [priceSection addObject:[NSString stringWithFormat:@"$%@", priceArray]];
            [imageSection addObject:[NSString stringWithFormat:@"%@", imageArray]];
            [likeSection addObject:[NSString stringWithFormat:@"%@", likeArray]];
            [commentSection addObject:[NSString stringWithFormat:@"%@", commentArray]];
        }
        
        self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
        self.priceArray = [[NSArray alloc] initWithObjects:priceSection, nil];
        self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
        self.likeArray = [[NSArray alloc] initWithObjects:likeSection, nil];
        self.commentArray = [[NSArray alloc] initWithObjects:commentSection, nil];
        self.pkArray = [[NSArray alloc] initWithObjects:pkSection, nil];
        
        UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.productview.cell"];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(155, 175)];
        [flowLayout setMinimumInteritemSpacing:0.5];
        [flowLayout setMinimumLineSpacing:3.0];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    [self.collectionView setContentOffset:CGPointZero animated:YES];
        if(self.dataArray.count != 0 || self.priceArray.count != 0 ||
           self.imageArray.count != 0 || self.likeArray.count != 0 ||
           self.commentArray.count != 0 || self.pkArray.count != 0){
        [self.collectionView setCollectionViewLayout:flowLayout];
        }
        
        //    //initialize a new webviewcontroller
        //    WebViewController *controller = [[WebViewController alloc] initWithString:htmlSTR];
        //
        //    //show controller with navigation
        //    [self.navigationController pushViewController:controller animated:YES];
        
        NSLog(@"Finish items ...");
        
    }else if(connectPurpose == 0){
        NSArray *pkDataArray = [jsonDictionary valueForKey:@"pk"];
        // Store pk of items
        for (NSString *obj in pkDataArray){
            [favouritePkArray addObject:[NSString stringWithFormat:@"%@", obj]];
        }
        
        // This part is getting all the items from server.
        // Post request
        connectPurpose = 1;
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        NSURL *url;
        NSString *postData;
        NSMutableURLRequest *request;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getItemList/",appDelegate.apiUrl]];
        NSLog(@"Loading products ...");
        if(loadPurpose == 1){
            NSLog(@"Loading latest products ...");
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getNewItemList/",appDelegate.apiUrl]];
            
            //initialize a request from url
            request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
            
            //set http method
            [request setHTTPMethod:@"POST"];
            //initialize a post data
            if(![_categoryType isEqualToString:@"All"]){
                postData = [NSString stringWithFormat:@"limit=100&lastIndex=0&category=%@",_categoryType];
            }else{
               postData = [NSString stringWithFormat:@"limit=100&lastIndex=0"];
            }
//            postData = @"limit=100&lastIndex=0";
        }else if(loadPurpose == 2){
            NSLog(@"Loading nearby products ...");
            NSLog(@"Location: %f %f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getItemByLocation/",appDelegate.apiUrl]];
            
            //initialize a request from url
            request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
            
            //set http method
            [request setHTTPMethod:@"POST"];
            //initialize a post data
            if(![_categoryType isEqualToString:@"All"]){
//                postData = [NSString stringWithFormat:@"lati=%f&longt=%f&locradius=6371&category=%@",1.37,108.66,_categoryType];
                postData = [NSString stringWithFormat:@"lati=%f&longt=%f&locradius=6371&category=%@",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,_categoryType];
            }else{
                postData = [NSString stringWithFormat:@"lati=%f&longt=%f&locradius=6371",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
//                postData = [NSString stringWithFormat:@"lati=%f&longt=%f&locradius=6371",1.37,108.66];
            }
        }else if(loadPurpose == 3){
            NSLog(@"Loading following products ...");
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/follow.getFollowItem/%@",appDelegate.apiUrl,[prefs stringForKey:@"pk"]]];
            
            //initialize a request from url
            request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
            
            //set http method
            [request setHTTPMethod:@"GET"];
            //initialize a post data
//            postData = [NSString stringWithFormat:@"%@",];
        }
        
        
        
//        NSString *postData = [NSString stringWithFormat:@"limit=10&lastIndex=%d",lastIndexLoaded];
//        lastIndexLoaded = lastIndexLoaded + 10;
        //set request content type we MUST set this value.
        
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //set post data of request
        if(loadPurpose != 3){
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = connection;
        
        //start the connection
        [connection start];
        // Post request
        
        
        [NSThread sleepForTimeInterval:2];
        
        //reload collection view data
        [self.collectionView reloadData];
        
    }else if(connectPurpose == 2){
        NSArray *responseArray = [jsonDictionary valueForKey:@"responseCode"];
        for (NSString *obj in responseArray){
            NSLog(@"Favourite Item Insert Response Code: %@",obj);
            if([[NSString stringWithFormat:@"%@",obj] isEqual: @"5"]){
                NSLog(@"in%@",currentItemId);
                // This part is getting all the items from server.
                // Post request
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                connectPurpose = 3;
                //if there is a connection going on just cancel it.
                [self.connection cancel];
                
                //initialize new mutable data
                NSMutableData *data = [[NSMutableData alloc] init];
                self.receivedData = data;
                
                //initialize url that is going to be fetched.
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/favourite.remove/",appDelegate.apiUrl]];
                
                //initialize a request from url
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
                
                //set http method
                [request setHTTPMethod:@"POST"];
                //initialize a post data
                NSString *postData = [NSString stringWithFormat:@"item_id=%@&user_id=%@&device_id=%@&token=%@",
                                      currentItemId,[prefs stringForKey:@"pk"],
                                      [prefs stringForKey:@"udid"],[prefs stringForKey:@"token"]];
                
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
            }else{
                connectPurpose = 1;
                
                // Post request
                //if there is a connection going on just cancel it.
                [self.connection cancel];
                
                //initialize new mutable data
                NSMutableData *data = [[NSMutableData alloc] init];
                self.receivedData = data;
                
                //initialize url that is going to be fetched.
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getItemList/",appDelegate.apiUrl]];
                
                //initialize a request from url
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
                
                //set http method
                [request setHTTPMethod:@"POST"];
                //initialize a post data
                NSString *postData = [NSString stringWithFormat:@"limit=100&category=%@",_categoryType];
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
                
                [NSThread sleepForTimeInterval:1];
                
                //reload collection view data
                [self.collectionView reloadData];
            }
        }
    }else if(connectPurpose == 3){
        NSArray *responseArray = [jsonDictionary valueForKey:@"responseCode"];
        for (NSString *obj in responseArray){
            NSLog(@"Favourite Item Remove Response Code: %@",obj);
        }
        
        connectPurpose = 1;
        
        // Post request
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getItemList/",appDelegate.apiUrl]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        //initialize a post data
        NSString *postData = @"limit=100";
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
        
        [NSThread sleepForTimeInterval:1];
        
        //reload collection view data
        [self.collectionView reloadData];
    }
    [_loadProductIndicator stopAnimating];
}
// NSURLConnection methods

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Autorotation

/*
 * Please get familiar with iOS 6 new rotation handling as if you were to nest this controller within a UINavigationController,
 * the UINavigationController would _NOT_ relay rotation requests to his children on its own!
 */

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// Pull to refresh method
-(void)refreshView:(UIRefreshControl *)refresh{
    // custom refresh logic would be placed here...
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/browse.getItemList/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = @"limit=100";
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

    
    
    //set the title while refreshing
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing products"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    
    [NSThread sleepForTimeInterval:1];
    
    //reload collection view data
    [self.collectionView reloadData];
    
    //end the refreshing
    [refreshControl endRefreshing];
}
// Pull to refresh method

// Hide tab bar
#pragma mark - The Magic!
-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self.tabBarController setTabBarHidden:YES
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    [self.tabBarController setTabBarHidden:NO
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
float previousScrollState;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat currentOffset = scrollView.contentOffset.y;
//    CGFloat differenceFromStart = startContentOffset - currentOffset;
//    CGFloat differenceFromLast = lastContentOffset - currentOffset;
//    lastContentOffset = currentOffset;
//    
//    if((differenceFromStart) < 0)
//    {
//        // scroll up
//        if(scrollView.isTracking && (abs(differenceFromLast)>1))
//            [self expand];
//    }
//    else {
//        if(scrollView.isTracking && (abs(differenceFromLast)>1))
//            [self contract];
//    }
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
    {
        //LOAD MORE DATA
        // you can also add a isLoading bool value for better dealing :D
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    previousScrollState = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self contract];
    return YES;
}
// Hide tab bar

@end
