//
//  MyBookmarksViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/3/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import "MyBookmarksViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewItemViewController.h"

@interface MyBookmarksViewController ()

@property (nonatomic, strong) NSArray *pkArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *likeArray;
@property (nonatomic, strong) NSArray *commentArray;

@end

@implementation MyBookmarksViewController

// 0 - retrieve user particulars
// 1 - retrieve user posts
// 2 - retrieve user followers
// 3 - retrieve user followings
// 4 - retrieve user statistics
int requestType;
NSString *postCount;
NSMutableArray *favouritePkArray;
int testInt1 = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self LoadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getBookmarkedPosts];
}

- (void)LoadView
{
    CGRect frame = CGRectMake(0, 0, 160, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"My Bookmarks";
}

NSIndexPath *tableSelection;
NSString *selectedTitle;
NSString *likesNo;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    tableSelection = indexPath;
    NSMutableArray *data = [self.pkArray objectAtIndex:indexPath.section];
    NSMutableArray *likeData = [self.likeArray objectAtIndex:indexPath.section];
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *likeCellData = [likeData objectAtIndex:indexPath.row];
    //    NSLog(@"Selected index: %@",cellData);
    selectedTitle = cellData;
    likesNo = likeCellData;
    [self performSelector:@selector(singleTap) withObject: nil afterDelay: .4];
}
- (void)singleTap {
    // Declare view item view controller
    ViewItemViewController *viewItemViewController = [[ViewItemViewController alloc] init];
    // Set category selected into post item view controller variable
    NSLog(@"%@",selectedTitle);
    viewItemViewController.itemId = selectedTitle;
    viewItemViewController.likesNo = likesNo;
    // Push view controller into view
    [self.navigationController pushViewController:viewItemViewController animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self.contentCollectionView.collectionViewLayout invalidateLayout];
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
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
    
    static NSString *cellIdentifier = @"com.mybookmarkview.cell";
    
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
    //    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchDown];
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
    
    //    [_loadProfileIndicator stopAnimating];
    
    return cell;
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
    
    if(requestType == 1){
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
            
            NSLog(@"first section size: %d",[firstSection count]);
            
            if (firstSection[0] != [NSNull null]) {
                testInt1++;
                UINib *cellNib = [UINib nibWithNibName:@"NibMyBookmarkCell" bundle:nil];
                [_contentCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.mybookmarkview.cell"];
                
                [_contentCollectionView.collectionViewLayout invalidateLayout];
                
                _contentCollectionView.delegate = self;
                _contentCollectionView.dataSource = self;
                
                UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
                [flowLayout1 setItemSize:CGSizeMake(155, 175)];
                [flowLayout1 setMinimumInteritemSpacing:0.1];
                [flowLayout1 setMinimumLineSpacing:3.0];
                [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
                //    [self.collectionView setContentOffset:CGPointZero animated:YES];
                [self.contentCollectionView setCollectionViewLayout:flowLayout1];
                
                //                [NSThread sleepForTimeInterval:1];
                
                //reload collection view data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentCollectionView reloadData];
                });
            }
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        _contentCollectionView.dataSource = nil;
        _contentCollectionView.delegate = nil;
        [_contentCollectionView reloadData];
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}

- (void)getBookmarkedPosts{
    requestType = 1;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/favourite.getItem/%@",appDelegate.apiUrl,[prefs stringForKey:@"pk"]]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //    //set http method
    [request setHTTPMethod:@"GET"];
    //    //initialize a post data
    //    NSString *postData = [NSString stringWithFormat:@"user_id=%@", [prefs stringForKey:@"pk"]];
    //    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    //    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
