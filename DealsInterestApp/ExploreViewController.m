//
//  ExploreViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "ExploreViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MeViewController.h"
#import "SBJson.h"
#import "ExploreDetailViewController.h"
#import "HomeViewController.h"
#import "PrivateChatViewController.h"

@interface ExploreViewController ()

@property (nonatomic, strong) NSArray *catArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *detailDataArray;

@end

//@interface UINavigationBar (myNave)
//- (CGSize)changeHeight:(CGSize)size;
//@end
//
//@implementation UINavigationBar (customNav)
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = CGSizeMake(320,40);
//    return newSize;
//}
//@end

@implementation ExploreViewController

NSString *PCItemId;
NSString *PCPhotoURL;
NSString *PCTitle;
NSString *PCDescription;
NSString *PCPrice;
NSString *PCBuyerPhotoURL;
NSString *PCSellerId;
NSString *PCBuyerId;
NSString *PCChatType;

NSString *selectedCategory;
//ExploreDetailViewController *expDetailViewController;
HomeViewController *expDetailViewController;

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
    
    
    
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Category";
   
    /*
     Configuration for loading indicator
     */
//    // make the area larger
//    [_loadCatIndicator setFrame:self.view.frame];
//    // set a background color
//    [_loadCatIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
//    CGPoint center = self.view.center;
//    _loadCatIndicator.center = center;
    /*
     Configuration for loading indicator
     */
    
    // Populate array with categories
    _catArray = [NSArray arrayWithObjects:@"All",@"Books",@"Fashion",@"Beauty",
                         @"Furnitures",@"Digital",@"Household",
                @"Outdoors",@"Services",@"Others",nil];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *imageSection = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_catArray.count; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"%@", [_catArray objectAtIndex:i]]];
        [imageSection addObject:[NSString stringWithFormat:@"%@.png", [_catArray objectAtIndex:i]]];
    }
    
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCatCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.catview.cell"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(105, 105)];
    [flowLayout setMinimumInteritemSpacing:0.2];
    [flowLayout setMinimumLineSpacing:9.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(void) viewWillAppear:(BOOL)animated{
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Category";
    
    /*
     Configuration for loading indicator
     */
    //    // make the area larger
    //    [_loadCatIndicator setFrame:self.view.frame];
    //    // set a background color
    //    [_loadCatIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    //    CGPoint center = self.view.center;
    //    _loadCatIndicator.center = center;
    /*
     Configuration for loading indicator
     */
    
    // Populate array with categories
    _catArray = [NSArray arrayWithObjects:@"All",@"Books",@"Fashion",@"Beauty",
                 @"Furnitures",@"Digital",@"Household",
                 @"Outdoors",@"Services",@"Others",nil];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *imageSection = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_catArray.count; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"%@", [_catArray objectAtIndex:i]]];
        [imageSection addObject:[NSString stringWithFormat:@"%@.png", [_catArray objectAtIndex:i]]];
    }
    
    //    for (int i=0; i<catArray.count; i++) {
    //        [firstSection addObject:[NSString stringWithFormat:@"%@", [catArray objectAtIndex:i]]];
    //        [imageSection addObject:[NSString stringWithFormat:@"%@.png", [catArray objectAtIndex:i]]];
    //    }
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCatCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.catview.cell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(105, 105)];
    [flowLayout setMinimumInteritemSpacing:0.2];
    [flowLayout setMinimumLineSpacing:9.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

//-(UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size{
//    
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
//    
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
//    CGContextSetFillColorWithColor(currentContext, color.CGColor);
//    CGContextFillRect(currentContext, fillRect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

/*
 Initial category collectionView 
*/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    //    return [sectionArray count];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    NSMutableArray *imageData = [self.imageArray objectAtIndex:indexPath.section];
    
//    NSLog(@"%d %d",indexPath.row,data.count);
    
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *cellImageData = [imageData objectAtIndex:indexPath.row];

    static NSString *cellIdentifier = @"com.catview.cell";
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    UIButton *catButton = (UIButton *)[cell viewWithTag:9999];
    
    [catButton setTitle:cellData forState:UIControlStateNormal];
    [catButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    // Populate button image
    [catButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",cellImageData]] forState:UIControlStateNormal];
    // Assign button action method to button
    [catButton addTarget:self action:@selector(catDetailAction:) forControlEvents:UIControlEventTouchDown];
    // Assign new button tag according to index of catArray
//    for(int i=0; i<_catArray.count; i++){
//        if([cellData isEqual:[_catArray objectAtIndex:i]]){
//            catButton.tag = i;
//        }
//    }
//    catButton.tag = indexPath.row;
//    catButton.tag = indexPath.row;
    
//    NSLog(@"%@ %d",cellData,indexPath.row);
    
    // Populate product title label
    titleLabel.text = cellData;
    
    return cell;
}
/*
 Initial category collectionView
 */

-(void)catDetailAction:(UIButton *)sender {
//    NSLog(@"Clicked! %@",sender.currentTitle);
    for(int i=0; i<_catArray.count; i++){
        if([sender.currentTitle isEqual:[_catArray objectAtIndex:i]]){
//            NSLog(@"From clicking on category button: %@! :D",[_catArray objectAtIndex:i]);
            
            
            selectedCategory = [_catArray objectAtIndex:i];
//
            // Initialize new ExploreDetailViewController
            expDetailViewController = [[HomeViewController alloc] init];
            // Pass category selected into new ExploreDetailViewController
            expDetailViewController.categoryType = [_catArray objectAtIndex:i];
            
            // Change category detail header accordingly
//            _detailHeaderLabel.text = [catArray objectAtIndex:i];
            
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
            NSString *postData = [NSString stringWithFormat:@"limit=100&category=%@",[_catArray objectAtIndex:i]];
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
    }
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
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];

    NSString *titleArray;
    NSString *priceArray;
    NSString *imageArray;
    
    BOOL checkContent = true;
    
    for (NSDictionary *obj in fieldsArray){
        titleArray = [obj valueForKey:@"title"];
        priceArray = [obj valueForKey:@"price"];
        imageArray = [obj valueForKey:@"photo1"];
        
        if(titleArray == (id)[NSNull null])
            checkContent = false;
    }
    
    if(checkContent){
        // Push view controller into view
        [self.navigationController pushViewController:expDetailViewController animated:YES];
    }else{
        // Create alert message
        UIAlertView *catNoContent = [[UIAlertView alloc] initWithTitle:@"No Products"
                                                              message:[NSString stringWithFormat:@"Sorry! There is no product in %@ category yet! :(",selectedCategory]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        // Display alert message
        [catNoContent show];
    }
}
// NSURLConnection methods

-(void)triggerPrivateChat{
    PCItemId = self.PCItemId;
    PCPhotoURL = self.PCItemProfilePic;
    PCTitle = self.PCItemTitle;
    PCDescription = self.PCItemDescription;
    PCPrice = self.PCItemPrice;
    PCBuyerPhotoURL = self.PCBuyerProfilePic;
    PCSellerId = self.PCSellerId;
    PCBuyerId = self.PCBuyerId;
    PCChatType = self.PCChatType;
    
    PrivateChatViewController *privateChatViewController = [[PrivateChatViewController alloc] init];
    privateChatViewController.PCItemProfilePic = PCPhotoURL;
    privateChatViewController.PCItemTitle = PCTitle;
    privateChatViewController.PCItemDescription = PCDescription;
    privateChatViewController.PCItemPrice = PCPrice;
    privateChatViewController.PCBuyerProfilePic = PCBuyerPhotoURL;
    privateChatViewController.PCSellerId = PCSellerId;
    privateChatViewController.PCItemId = PCItemId;
    privateChatViewController.PCChatType = PCChatType;
    NSLog(@"PCPhotoURL: %@",PCPhotoURL);
    NSLog(@"PCTitle: %@",PCTitle);
    NSLog(@"PCDescription: %@",PCDescription);
    NSLog(@"PCPrice: %@",PCPrice);
    NSLog(@"PCBuyerPhotoURL: %@",PCBuyerPhotoURL);
    NSLog(@"PCSellerId: %@",PCSellerId);
    NSLog(@"PCItemId: %@",PCItemId);
    NSLog(@"PCChatType: %@",PCChatType);
    // Push view controller into view
    [self.navigationController pushViewController:privateChatViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
