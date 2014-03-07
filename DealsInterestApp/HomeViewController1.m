//
//  HomeViewController1.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 23/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "HomeViewController1.h"
#import "SBJson.h"
#import "AppDelegate.h"

@interface HomeViewController1 (){
    NSMutableArray *viewSectionData;
    NSMutableArray *viewData;
    NSMutableArray *viewImageData;
    NSMutableArray *itemIdArray;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation HomeViewController1

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
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    [_productCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.productview.cell"];
    
    _productCollectionView.delegate = self;
    _productCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(155, 175)];
    [flowLayout setMinimumInteritemSpacing:0.2];
    [flowLayout setMinimumLineSpacing:0.2];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [_productCollectionView setCollectionViewLayout:flowLayout];

    
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Home";
    
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
    NSLog(@"%d %d",indexPath.row,data.count);
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *cellPriceData = [priceData objectAtIndex:indexPath.row];
    NSString *cellImageData = [imageData objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"com.productview.cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:101];
    UIImageView *productImageView = (UIImageView *)[cell viewWithTag:102];
    
    // Populate product title label
    titleLabel.text = cellData;
    // Populate product price label
    priceLabel.layer.cornerRadius = 8;
    priceLabel.text = cellPriceData;
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Check for products with no image
    if(![cellImageData isEqual: @"noimage"]){
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,cellImageData];
        //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://wallgood.com/wp-content/uploads/2013/07/Jackie-Chan-Meme-Template.jpg"];
        
        // Multi-threading
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Background thread running
            NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            UIImage *theImage=[UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Main thread updating GUI
                productImageView.image=theImage;
            });
        });
        //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
        //        productImageView.image = [UIImage imageWithData:imageData];
        // Display default image if there is not image for product
    }else{
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
        //        NSMutableString* theString = [NSMutableString stringWithFormat:@"http://www.bubblews.com/assets/images/news/763574121_1373118355.jpg"];
        
        // Multi-threading
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Background thread running
            NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            UIImage *theImage=[UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Main thread updating GUI
                productImageView.image=theImage;
            });
        });
        //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
        //        productImageView.image = [UIImage imageWithData:imageData];
    }
    
//    [_loadProductIndicator stopAnimating];
    
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
//    [_loadProductIndicator startAnimating];
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@" , htmlSTR);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *priceSection = [[NSMutableArray alloc] init];
    NSMutableArray *imageSection = [[NSMutableArray alloc] init];
    
    NSString *titleArray;
    NSString *priceArray;
    NSString *imageArray;
    
    for (NSDictionary *obj in fieldsArray){
        titleArray = [obj valueForKey:@"title"];
        priceArray = [obj valueForKey:@"price"];
        imageArray = [obj valueForKey:@"photo1"];
        
        if([imageArray isEqual:@""])
            imageArray = @"noimage";
        //        NSLog(@"%@",imageArray);
        [firstSection addObject:[NSString stringWithFormat:@"%@", titleArray]];
        [priceSection addObject:[NSString stringWithFormat:@"$%@", priceArray]];
        [imageSection addObject:[NSString stringWithFormat:@"%@", imageArray]];
    }
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    self.priceArray = [[NSArray alloc] initWithObjects:priceSection, nil];
    self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    [_productCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.productview.cell"];
    
    _productCollectionView.delegate = self;
    _productCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(155, 175)];
    [flowLayout setMinimumInteritemSpacing:0.2];
    [flowLayout setMinimumLineSpacing:0.2];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [_productCollectionView setCollectionViewLayout:flowLayout];
    
    //    //initialize a new webviewcontroller
    //    WebViewController *controller = [[WebViewController alloc] initWithString:htmlSTR];
    //
    //    //show controller with navigation
    //    [self.navigationController pushViewController:controller animated:YES];
}
// NSURLConnection methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
