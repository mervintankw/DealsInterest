//
//  ExploreDetailViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 21/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "ExploreDetailViewController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewItemViewController.h"

@interface ExploreDetailViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *detailDataArray;

@end

@implementation ExploreDetailViewController

// 1 for getting all items
// 2 for inserting favourite item
// 3 for removing favourite item
int connectPurpose;
NSString *currentItemId;

// Hide tab bar
CGFloat startContentOffset;
CGFloat lastContentOffset;
BOOL hidden;
// Hide tab bar

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
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = _categoryType;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    connectPurpose = 1;
    
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

}

int tapCount;
NSIndexPath *tableSelection;
NSString *selectedTitle;
NSString *likesNo;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    tableSelection = indexPath;
    tapCount++;
//    NSMutableArray *data = [self.pkArray objectAtIndex:indexPath.section];
//    NSMutableArray *likeData = [self.likeArray objectAtIndex:indexPath.section];
//    NSString *cellData = [data objectAtIndex:indexPath.row];
//    NSString *likeCellData = [likeData objectAtIndex:indexPath.row];
//    NSLog(@"Selected index: %@",cellData);
    switch (tapCount) {
        case 1: //single tap
//            selectedTitle = cellData;
//            likesNo = likeCellData;
            [self performSelector:@selector(singleTap) withObject: nil afterDelay: .4];
            break;
            NSLog(@"Single tap!");
            break;
        case 2: //double tap
//            selectedTitle = cellData;
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
//        [self.tabBarController setTabBarHidden:NO animated:YES];
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
    NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
    
    if(connectPurpose == 1){
    
        NSMutableArray *firstSection = [[NSMutableArray alloc] init];
        NSMutableArray *priceSection = [[NSMutableArray alloc] init];
        NSMutableArray *imageSection = [[NSMutableArray alloc] init];
        
        NSString *titleArray;
        NSString *priceArray;
        NSString *imageArray;
        
        BOOL checkContent = true;
        
        for (NSDictionary *obj in fieldsArray){
            titleArray = [obj valueForKey:@"title"];
            priceArray = [obj valueForKey:@"price"];
            imageArray = [obj valueForKey:@"photo1"];
            
            if([imageArray isEqual:@""])
                imageArray = @"noimage";
            //        NSLog(@"%@",imageArray);
            NSLog(@"before adding: %@",titleArray);
            //        if(![titleArray isEqual:@""]){
            [firstSection addObject:[NSString stringWithFormat:@"%@", titleArray]];
            [priceSection addObject:[NSString stringWithFormat:@"$%@", priceArray]];
            [imageSection addObject:[NSString stringWithFormat:@"%@", imageArray]];
            if(titleArray == (id)[NSNull null])
                checkContent = false;
            //        }
        }
        
        self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
        self.priceArray = [[NSArray alloc] initWithObjects:priceSection, nil];
        self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
        
        UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
        [self.detailCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.productview.cell"];
        
        self.detailCollectionView.delegate = self;
        self.detailCollectionView.dataSource = self;
        
        UICollectionViewFlowLayout *detailFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [detailFlowLayout setItemSize:CGSizeMake(155, 175)];
        [detailFlowLayout setMinimumInteritemSpacing:0.2];
        [detailFlowLayout setMinimumLineSpacing:0.2];
        [detailFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        if(checkContent){
            // Set reloading of content in collection view
            [self.detailCollectionView performBatchUpdates:^{
                [self.detailCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.detailCollectionView.numberOfSections)]];
            } completion:nil];
            [self.detailCollectionView setCollectionViewLayout:detailFlowLayout];
            // Get category detail view
            UIView *catDetailView = (UIView *)[self.view viewWithTag:200];
            
            // Push view controller into view
            
    //        [self.navigationController pushViewController:expDetailViewController animated:YES];
            
            // Unhide category detail view
            [catDetailView setHidden:NO];
            UIButton *catDetailBackBtn = (UIButton *)[catDetailView viewWithTag:31];
            [catDetailBackBtn addTarget:self
                                 action:@selector(backToCat:)
                       forControlEvents:UIControlEventTouchDown];
            CALayer *layer = catDetailBackBtn.layer;
            layer.cornerRadius = 8.0f;
            layer.masksToBounds = YES;
            layer.borderWidth = 1.0f;
            // Force display first content on the list
            [self.detailCollectionView setContentOffset:CGPointMake(0, -70) animated:YES];
        }else{
            // Create alert message
            UIAlertView *catNoContent = [[UIAlertView alloc] initWithTitle:@"No Products"
                                                                   message:@"Sorry! There is no product in this category yet! :("
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            // Display alert message
            [catNoContent show];
        }
    }else if(connectPurpose == 2){
        
    }
}
// NSURLConnection methods

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
        NSMutableArray *priceData = [self.priceArray objectAtIndex:indexPath.section];
        NSMutableArray *imageData = [self.imageArray objectAtIndex:indexPath.section];
//        NSString *checkNull = [data objectAtIndex:0];

        NSString *cellData = [data objectAtIndex:indexPath.row];
        NSString *cellPriceData = [priceData objectAtIndex:indexPath.row];
        NSString *cellImageData = [imageData objectAtIndex:indexPath.row];
        
        static NSString *cellIdentifier = @"com.productview.cell";
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:101];
        UIImageView *productImageView = (UIImageView *)[cell viewWithTag:102];
        
        // Populate product title label
        titleLabel.text = cellData;
        // Populate product price label
        priceLabel.layer.cornerRadius = 8;
        priceLabel.text = cellPriceData;
    
        productImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // Check for products with no image
        if(![cellImageData isEqual: @"noimage"]){
            NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,cellImageData];
            //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://wallgood.com/wp-content/uploads/2013/07/Jackie-Chan-Meme-Template.jpg"];
            
            [productImageView setImageWithURL:[NSURL URLWithString:theString]
                             placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            
            // Multi-threading
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                // Background thread running
//                NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//                UIImage *theImage=[UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Main thread updating GUI
//                    productImageView.image=theImage;
//                });
//            });
            //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            //        productImageView.image = [UIImage imageWithData:imageData];
            // Display default image if there is not image for product
        }else{
//            NSMutableString* theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
//            //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://www.bubblews.com/assets/images/news/763574121_1373118355.jpg"];
//            
//            // Multi-threading
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                // Background thread running
//                NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
//                UIImage *theImage=[UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Main thread updating GUI
//                    productImageView.image=theImage;
//                });
//            });
            //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            //        productImageView.image = [UIImage imageWithData:imageData];
        }
        
//    [self.detailCollectionView  selectItemAtIndexPath:0 animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    return cell;
}
/*
 Initial category collectionView
 */

// Hide tab bar
#pragma mark - The Magic!
-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
//    [self.tabBarController setTabBarHidden:YES
//                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
//    [self.tabBarController setTabBarHidden:NO
//                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
