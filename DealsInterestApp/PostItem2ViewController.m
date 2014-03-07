//
//  PostItem2ViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "PostItem2ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SelectItemPhotoViewController.h"
#import "SBJsonParser.h"

@interface PostItem2ViewController ()

@end

@implementation PostItem2ViewController

CLLocationManager *locationManager;
int uploadImage;
int uploadImageCount;
NSMutableArray *imageUrls;
NSString *inTitle;
NSString *inPrice;
NSString *inDescription;
NSString *inEmail;
NSString *inHandphone;
NSString *inContactName;
NSString *inLocationAddress;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self LoadView];
}

-(void)LoadView
{
    // Allocate memory for imageUrls array
    imageUrls = [[NSMutableArray alloc] init];
    
    CGRect frame = CGRectMake(0, 0, 170, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Post Item (3/3)";
    
    // Load location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    // Adds button listener to select item photo button click
    [_photo1Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo2Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo3Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo4Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo5Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    // Load images for product if there is any
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]valueForKey:@"postItemPhotoArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"Image Array Count: %d",[arr count]);
    uploadImageCount = appDelegate.postItemPhotoCount;
    if(appDelegate.postItemPhotoCount == 1){
        _photo1.image = appDelegate.photo1;
        _photo2.image = [UIImage imageNamed: @"add_photo.png"];
        _photo3.image = [UIImage imageNamed: @"add_photo.png"];
        _photo4.image = [UIImage imageNamed: @"add_photo.png"];
        _photo5.image = [UIImage imageNamed: @"add_photo.png"];
    }else if(appDelegate.postItemPhotoCount == 2){
        _photo1.image = appDelegate.photo1;
        _photo2.image = appDelegate.photo2;
        _photo3.image = [UIImage imageNamed: @"add_photo.png"];
        _photo4.image = [UIImage imageNamed: @"add_photo.png"];
        _photo5.image = [UIImage imageNamed: @"add_photo.png"];
    }else if(appDelegate.postItemPhotoCount == 3){
        _photo1.image = appDelegate.photo1;
        _photo2.image = appDelegate.photo2;
        _photo3.image = appDelegate.photo3;
        _photo4.image = [UIImage imageNamed: @"add_photo.png"];
        _photo5.image = [UIImage imageNamed: @"add_photo.png"];
    }else if(appDelegate.postItemPhotoCount == 4){
        _photo1.image = appDelegate.photo1;
        _photo2.image = appDelegate.photo2;
        _photo3.image = appDelegate.photo3;
        _photo4.image = appDelegate.photo4;
        _photo5.image = [UIImage imageNamed: @"add_photo.png"];
    }else if(appDelegate.postItemPhotoCount == 5){
        _photo1.image = appDelegate.photo1;
        _photo2.image = appDelegate.photo2;
        _photo3.image = appDelegate.photo3;
        _photo4.image = appDelegate.photo4;
        _photo5.image = appDelegate.photo5;
    }else if(appDelegate.postItemPhotoCount == 0){
        _photo1.image = [UIImage imageNamed: @"add_photo.png"];
        _photo2.image = [UIImage imageNamed: @"add_photo.png"];
        _photo3.image = [UIImage imageNamed: @"add_photo.png"];
        _photo4.image = [UIImage imageNamed: @"add_photo.png"];
        _photo5.image = [UIImage imageNamed: @"add_photo.png"];
    }
    
    inTitle = _titleTextBox;
    inPrice = _priceTextBox;
    inDescription = _descriptionTextBox;
    inEmail = _emailTextBox;
    inHandphone = _handphoneTextBox;
    inContactName = _contactNameTextBox;
    inLocationAddress = _locationAddressTextBox;
    
    // Add post button
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(PostClick:)];
    self.navigationItem.rightBarButtonItem = done;
}

// Method trigger when user submit item to be posted
-(void)PostClick:(UIButton *)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // Validate inputs
    if([_locationNameTextBox.text isEqual:@""])
    {
        // Create alert message
        UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                             message:@"Please enter all fields!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        // Display alert message
        [postFailed show];
    }
    else
    {
        
            // Iterate through all the photos user select and upload them first
//            for (int i = 1; i <= appDelegate.postItemPhotoCount; i++)
//            {
        [self uploadImageMethod:uploadImageCount];
//        sleep(6);
//        [self uploadImageMethod:2];
//            }
//            NSLog(@"imageUrls: %d",[imageUrls count]);
    }
}

-(void)uploadImageMethod:(int)i
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    uploadImage = 0;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/image.uploadImage/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //                appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    // Append user_id to post
    // Note that user_id is taken from register user success json array
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",[prefs stringForKey:@"pk"]] dataUsingEncoding:NSUTF8StringEncoding]];  // user_id
    //            NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"udid"]] dataUsingEncoding:NSUTF8StringEncoding]];  // device_id
    //            NSLog(@"udid: %@",[prefs stringForKey:@"udid"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"token"]] dataUsingEncoding:NSUTF8StringEncoding]];  // token
            NSLog(@"token: %@",[prefs stringForKey:@"token"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"upload_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];  // upload_type
    
    if(i==1){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo1,1.0);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==2){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo2,1.0);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==3){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo3,1.0);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==4){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo4,1.0);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==5){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo5,1.0);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

-(void)postItemMethod:(NSString *)inUrl
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/post.insert/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //                appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    // Append user_id to post
    // Note that user_id is taken from register user success json array
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",[prefs stringForKey:@"pk"]] dataUsingEncoding:NSUTF8StringEncoding]];  // user_id
    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"title\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inTitle] dataUsingEncoding:NSUTF8StringEncoding]];  // title
    NSLog(@"title: %@",_titleTextBox);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"price\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inPrice] dataUsingEncoding:NSUTF8StringEncoding]];  // price
    NSLog(@"price: %@",_priceTextBox);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"description\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inDescription] dataUsingEncoding:NSUTF8StringEncoding]];  // description
    NSLog(@"description: %@",_descriptionTextBox);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"category\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:_categoryType] dataUsingEncoding:NSUTF8StringEncoding]];  // category
    NSLog(@"category: %@",_categoryType);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inEmail] dataUsingEncoding:NSUTF8StringEncoding]];  // email
    NSLog(@"email: %@",_emailTextBox);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"hp\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inHandphone] dataUsingEncoding:NSUTF8StringEncoding]];  // hp
    NSLog(@"hp: %@",_handphoneTextBox);
    
    int urlCount = 1;
    for(NSString *val in imageUrls){
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo%d\"\r\n\r\n",urlCount] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@",val]] dataUsingEncoding:NSUTF8StringEncoding]];  // image_url
        urlCount = urlCount + 1;
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"photo1\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@",inUrl]] dataUsingEncoding:NSUTF8StringEncoding]];  // image_url
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"contact_name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inContactName] dataUsingEncoding:NSUTF8StringEncoding]];  // contact_name
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"location_name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:_locationNameTextBox.text] dataUsingEncoding:NSUTF8StringEncoding]];  // location_name
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"location_address\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:inLocationAddress] dataUsingEncoding:NSUTF8StringEncoding]];  // location_address
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude]] dataUsingEncoding:NSUTF8StringEncoding]];  // lat
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"lng\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude]] dataUsingEncoding:NSUTF8StringEncoding]];  // lng
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"udid"]] dataUsingEncoding:NSUTF8StringEncoding]];  // device_id
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"token"]] dataUsingEncoding:NSUTF8StringEncoding]];  // token
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
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
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Upload content: %@",htmlSTR);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    
    // Post Item
    if(uploadImage == 1){
        for(NSDictionary *obj in jsonDictionary){
            NSLog(@"Post Item Response Code: %@", [obj objectForKey:@"responseCode"]);
            // Checks username and password
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
                // Create alert message
                UIAlertView *postSuccess = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                                     message:@"Item Successfully Posted!"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                // Display alert message
                [postSuccess show];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.postItemPhotoCount = 0;
                // Direct user back to product home page on product posting success
                HomeViewController *homeViewController = [[HomeViewController alloc] init];
                UINavigationController *navigationController = self.navigationController;
                [navigationController popToRootViewControllerAnimated:NO];
                [navigationController pushViewController:homeViewController animated:YES];
            }else if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"3"]){
                // Create alert message
                UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                                    message:@"Invalid input!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                // Display alert message
                [postFailed show];
            }else{
                // Create alert message
                UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                                         message:@"Invalid token! Please contact your administrator!"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                // Display alert message
                [postFailed show];
            }
        }
    }else if(uploadImage == 0){ // Upload Picture
        for(NSDictionary *obj in jsonDictionary){
            NSLog(@"Upload Image Response Code: %@", [obj objectForKey:@"responseCode"]);
            NSLog(@"Image URL: %@",[obj objectForKey:@"image_url"]);
            // Store image urls into array
            [imageUrls addObject:[obj objectForKey:@"image_url"]];
            uploadImageCount--;
            if(uploadImageCount == 0){
//                NSLog(@"All images uploaded successfully!");
//                NSLog(@"Images array count: %d",imageUrls.count);
                // After uploading images, time to post item.
                uploadImage = 1;
                [self postItemMethod:[obj objectForKey:@"image_url"]];
            }else{
                [self uploadImageMethod:uploadImageCount];
            }
        }
    }
}
// NSURLConnection methods

// Method trigger when user selects to post photo for item
-(void)SelectItemPhoto:(UIButton *)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Checks that image box is not used before
    if(appDelegate.postItemPhotoCount <= (sender.tag-60))
    {
        // Declare select item photo controller
        SelectItemPhotoViewController *selectItemPhotoViewController = [[SelectItemPhotoViewController alloc] init];
        // Push view controller into view
        [self.navigationController pushViewController:selectItemPhotoViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
