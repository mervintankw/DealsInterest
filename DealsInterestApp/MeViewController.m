//
//  MeViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "MeViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "UpdateProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewItemViewController.h"
#import "MyProductsViewController.h"

@interface MeViewController ()

@property (nonatomic, strong) NSArray *pkArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *likeArray;
@property (nonatomic, strong) NSArray *commentArray;

@end

@implementation MeViewController

NSMutableArray *viewSectionData;
NSMutableArray *viewData;
NSMutableArray *viewImageData;
NSMutableArray *itemIdArray;
NSMutableArray *favouritePkArray;

NSString *objValue;
NSString *keyValue;
NSString *postCount;
NSString *followerCount;
NSString *followingCount;
// 0 - retrieve user particulars
// 1 - retrieve user posts
// 2 - retrieve user followers
// 3 - retrieve user followings
// 4 - retrieve user statistics
int requestType;

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
//    [self LoadView];
}

- (void)viewWillAppear:(BOOL)animated
{
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSLog(@"purpose: %@",appDelegate.loadProfilePurpose);
//    NSLog(@"viewWillAppear");
    [self LoadView];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"purpose: %@",appDelegate.loadProfilePurpose);
    if([appDelegate.loadProfilePurpose isEqualToString:@"Edit Profile"]){
        appDelegate.loadProfilePurpose = @"";
        UpdateProfileViewController *updateProfileViewController = [[UpdateProfileViewController alloc] init];
        [self.navigationController pushViewController:updateProfileViewController animated:YES];
    }else if([appDelegate.loadProfilePurpose isEqualToString:@"My Products"]){
        appDelegate.loadProfilePurpose = @"";
        MyProductsViewController *myProductsViewController = [[MyProductsViewController alloc] init];
        [self.navigationController pushViewController:myProductsViewController animated:YES];
    }
}

- (void)LoadView
{
//        [self.view setNeedsDisplay];
    [self viewDidAppear:TRUE];
//        UpdateProfileViewController *updateProfileViewController = [[UpdateProfileViewController alloc] init];
//        [self.navigationController pushViewController:updateProfileViewController animated:YES];
    
    [_loadProfileIndicator startAnimating];
    
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Profile";
    
    // border radius
    [_userInfoView.layer setCornerRadius:8.0f];
    // border
    [_userInfoView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_userInfoView.layer setBorderWidth:1.0f];
    [_postsView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_postsView.layer setBorderWidth:0.5f];
    [_followersView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_followersView.layer setBorderWidth:0.5f];
    [_followingView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_followingView.layer setBorderWidth:0.5f];
    [_dealedView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_dealedView.layer setBorderWidth:0.5f];
    
    [[_editProfileButton layer] setBorderWidth:0.5f];
    _editProfileButton.backgroundColor = [UIColor lightGrayColor];
    
    _profilePic.contentMode = UIViewContentModeScaleAspectFit;
    // Make description label text align to top
    CGSize labelSize = [_userDescriptionLabel.text sizeWithFont:_userDescriptionLabel.font
                                          constrainedToSize:_userDescriptionLabel.frame.size
                                              lineBreakMode:_userDescriptionLabel.lineBreakMode];
    _userDescriptionLabel.frame = CGRectMake(
                                         _userDescriptionLabel.frame.origin.x, _userDescriptionLabel.frame.origin.y,
                                         _userDescriptionLabel.frame.size.width, labelSize.height);
    
    // Customize register button
    [_updateProfileBtn.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_updateProfileBtn.layer setBorderWidth: 1.0];
    _updateProfileBtn.layer.cornerRadius=8.0;
    [_updateProfileBtn setBackgroundColor:[UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1]];
    
    // Setup button event listener
    [_updateProfileBtn addTarget:self action:@selector(UpdateProfileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onOpenButtonClick)];
    
    [self getJsonObject];
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
//            selectedTitle = cellData;
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
//            [self performSelector:@selector(doubleTap) withObject: nil];
//            NSLog(@"Double tap!");
            break;
    }
}
- (void)singleTap {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Single tap detected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    tapCount = 0;
    
    // Declare view item view controller
    ViewItemViewController *viewItemViewController = [[ViewItemViewController alloc] init];
    // Set category selected into post item view controller variable
    NSLog(@"%@",selectedTitle);
    viewItemViewController.itemId = selectedTitle;
    viewItemViewController.likesNo = likesNo;
    // Push view controller into view
    [self.navigationController pushViewController:viewItemViewController animated:YES];
}


- (void)UpdateProfileBtnClick:(UIButton *)sender
{
    // Declare register view controller
    UpdateProfileViewController *updateProfileViewController = [[UpdateProfileViewController alloc] init];
    // Push view controller into view
    [self.navigationController pushViewController:updateProfileViewController animated:YES];
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
    NSLog(@"%d %d",indexPath.row,data.count);
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
    //    UIButton *commentBtn = (UIButton *)[cell viewWithTag:106];
    UIImageView *likeImageView = (UIImageView *)[cell viewWithTag:107];
    
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
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Check for products with no image
    if(![cellImageData isEqual: @"noimage"]){
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,cellImageData];
        //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://wallgood.com/wp-content/uploads/2013/07/Jackie-Chan-Meme-Template.jpg"];
        // Here we use the new provided setImageWithURL: method to load the web image
        [productImageView setImageWithURL:[NSURL URLWithString:theString]
                         placeholderImage:[UIImage imageNamed:@"loading.gif"]];
//        // Multi-threading
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // Background thread running
//            NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//            UIImage *theImage=[UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Main thread updating GUI
//                productImageView.image=theImage;
//            });
//        });
        //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
        //        productImageView.image = [UIImage imageWithData:imageData];
        // Display default image if there is not image for product
    }else{
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
        //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://www.bubblews.com/assets/images/news/763574121_1373118355.jpg"];
        // Here we use the new provided setImageWithURL: method to load the web image
        [productImageView setImageWithURL:[NSURL URLWithString:theString]
                         placeholderImage:[UIImage imageNamed:@"loading.gif"]];
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
    
    [_loadProfileIndicator stopAnimating];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if(requestType == 0){
        NSArray *colorTitles = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in colorTitles){
            //objValue = obj;
            //NSLog(@"obj: %@", [obj valueForKey:@"email"]);
        
            // Populate profile picture
            NSString* profilePicPath = [obj valueForKey:@"profile_pic"];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,profilePicPath];
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//            _profilePic.image = [UIImage imageWithData:imageData];
            // Here we use the new provided setImageWithURL: method to load the web image
            [_profilePic setImageWithURL:[NSURL URLWithString:theString]
                             placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            // Populate username
            _usernameLbl.text = [obj valueForKey:@"user_name"];
            // Populate email
            _emailLbl.text = [obj valueForKey:@"email"];
            // Populate hp
            _hpLbl.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"hp"]];
            // Populate last_visit_date
            _lastVisitedDateLbl.text = [obj valueForKey:@"last_visit_date"];
        }
        // Call method to retrieve user posts
        [self getUserStatistics];
    }else if(requestType == 1){
        for(NSDictionary *obj in jsonDictionary){
            NSArray *postCountArray = [jsonDictionary valueForKey:@"itemListCount"];
            for(NSDictionary *pCount in postCountArray){
                postCount = [NSString stringWithFormat:@"%@",pCount];
            }
        }
        // Check if there is posts made by user
        if(![postCount isEqualToString:@"0"]){
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
            [flowLayout setMinimumInteritemSpacing:0.2];
            [flowLayout setMinimumLineSpacing:3.0];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            //    [self.collectionView setContentOffset:CGPointZero animated:YES];
            [self.collectionView setCollectionViewLayout:flowLayout];
            
            [NSThread sleepForTimeInterval:1];
            
            [_collectionView.collectionViewLayout invalidateLayout];
            
            //reload collection view data
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        // Call method to retrieve user followers
        //[self getFollowerCount];
    }else if(requestType == 2){
        for(NSDictionary *obj in jsonDictionary){
            if(![[NSString stringWithFormat:@"%@",[obj valueForKey:@"responseCode"]] isEqualToString:@"2"]){
                followerCount = [NSString stringWithFormat:@"%lu",(unsigned long)jsonDictionary.count];
            }else{
                followerCount = @"0";
            }
        }
        // Call method to retrieve user following
        [self getFollowingCount];
    }else if(requestType == 3){
        for(NSDictionary *obj in jsonDictionary){
            if(![[NSString stringWithFormat:@"%@",[obj valueForKey:@"responseCode"]] isEqualToString:@"2"]){
                followingCount = [NSString stringWithFormat:@"%lu",(unsigned long)jsonDictionary.count];
            }else{
                followingCount = @"0";
            }
        }
    }else if(requestType == 4){
//        NSLog(@"user statistics: %@",htmlSTR);
        _postsLabel.text = [NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"totalItemCount"]];
        _followersLabel.text = [NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"followerCount"]];
        _followingLabel.text = [NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"followingCount"]];
        _dealedLabel.text = [NSString stringWithFormat:@"Dealed: %@",[jsonDictionary valueForKey:@"soldItemCount"]];
        // Call method to retrieve user posts
        [self getPostCount];
    }
    [_loadProfileIndicator stopAnimating];
}
// NSURLConnection methods

- (void)getUserStatistics{
    requestType = 4;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.getStats/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"user_id=%@", [prefs stringForKey:@"pk"]];
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

- (void)getFollowingCount{
    requestType = 3;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/follow.getFollowUser/%@",
                                       appDelegate.apiUrl,[prefs stringForKey:@"pk"]]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"GET"];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    //[request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

- (void)getFollowerCount{
    requestType = 2;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/follow.getFollowMeUser/%@",
                                       appDelegate.apiUrl,[prefs stringForKey:@"pk"]]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"GET"];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    //[request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

- (void)getPostCount{
    requestType = 1;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/item.getPostItem/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"user_id=%@", [prefs stringForKey:@"pk"]];
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

- (void)getJsonObject{
    requestType = 0;
    
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
//    NSLog(@"username: %@",[prefs stringForKey:@"user_name"]);
//    NSLog(@"email: %@",[prefs stringForKey:@"email"]);
    
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
}
@end
