//
//  UpdateProfileViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 24/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "SelectProfilePicViewController.h"

@interface UpdateProfileViewController ()

@end

@implementation UpdateProfileViewController

AppDelegate *appDelegate;
bool preLoad = true;
NSUserDefaults *prefs;

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

-(void)viewWillAppear:(BOOL)animated
{
    [self LoadView];
}

// View load method
-(void)LoadView
{
    CGRect frame = CGRectMake(0, 0, 170, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Edit Profile";
    
    // Add done button
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(UpdateClick:)];
    self.navigationItem.rightBarButtonItem = done;
    
    prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    NSLog(@"username: %@",[prefs stringForKey:@"user_name"]);
    NSLog(@"email: %@",[prefs stringForKey:@"email"]);
    
    [self getJsonObject];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.registerProfilePic != nil){
        _profilePicImageView.image = appDelegate.registerProfilePic;
    }
    else
    {
        // Gets default image from server
        NSMutableString* theString = [NSMutableString stringWithFormat:@"%@uploads/defaultimage.jpg",appDelegate.apiUrl];
        // Multi-threading
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Background thread running
            NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:theString]];
            UIImage *theImage=[UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Main thread updating GUI
                _profilePicImageView.image=theImage;
            });
        });
        // Gets default image from server
    }
    
    // Adds button listener to select profile pic click
    [_selectProfilePicBtn addTarget:self action:@selector(SelectProfilePic:) forControlEvents:UIControlEventTouchUpInside];
}

// Button event triggered when user wants to select a profile picture
-(void)SelectProfilePic:(UIButton *)sender
{
    // Declare register view controller
    SelectProfilePicViewController *selectProfilePicViewController = [[SelectProfilePicViewController alloc] init];
    // Push view controller into view
    [self.navigationController pushViewController:selectProfilePicViewController animated:YES];
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
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    if(preLoad){
        for(NSDictionary *obj in jsonDictionary){
            // Proceed to extracting user's username and store into session
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
            NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
            for (NSDictionary *obj in fieldsArray){
                NSLog(@"%@",[obj valueForKey:@"hp"]);
                // Get existing hp number
                _hpTextBox.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"hp"] ];
            }
        }
    }
    else
    {
        for(NSDictionary *obj in jsonDictionary){
            NSLog(@"%@", [obj objectForKey:@"responseCode"]);
            // Checks username and password
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
                // Create alert message
                UIAlertView *updateSuccess = [[UIAlertView alloc] initWithTitle:@"Update Profile"
                                                                          message:@"Update Profile Successful!"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                // Display alert message
                [updateSuccess show];
                // Go back to view profile view
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"2"]){
                // Create alert message
                UIAlertView *updateFail = [[UIAlertView alloc] initWithTitle:@"Update Profile"
                                                                    message:@"Update Profile Failed!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                // Display alert message
                [updateFail show];
            }
        }
    }
}
// NSURLConnection methods

- (void)UpdateClick:(UIButton *)sender
{
    preLoad = false;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.insert/",appDelegate.apiUrl]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.updatePic/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //        if(appDelegate.regiserProfilePic != nil){
    //            _profilePicImageView.image = appDelegate.regiserProfilePic;
    //        }
    
    //        //initialize a post data
    //        NSString *postData = [NSString stringWithFormat:@"username=%@&email=%@&password=%@&image=%@", inUsername,inEmail,inPassword,appDelegate.regiserProfilePic];
    //        //set request content type we MUST set this value.
    //
    //        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //
    //        //set post data of request
    //        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    //
    
    //        NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    //
    //        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //
    //        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",[prefs stringForKey:@"pk"]] dataUsingEncoding:NSUTF8StringEncoding]];  // user_id
    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:inUsername] dataUsingEncoding:NSUTF8StringEncoding]];  // username
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:inEmail] dataUsingEncoding:NSUTF8StringEncoding]];  // email
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:inPassword] dataUsingEncoding:NSUTF8StringEncoding]];  // password
    
    // Convert user profile picture into jpeg
    NSData *inImage = UIImageJPEGRepresentation(appDelegate.registerProfilePic,1.0);
    // Append image data to post
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"profile_pic\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:inImage]];  // profilePic
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    // Post request
}

- (void)getJsonObject{
    preLoad = true;
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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
    
    //    NSLog(@"inKey: '%@'", inKey);
    //
    //    NSString *str=@"http://54.224.4.212:8113/api/json/user.getUserById/73/";
    //    NSURL *url=[NSURL URLWithString:str];
    //    NSData *data=[NSData dataWithContentsOfURL:url];
    //    NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //
    //    //Remove last character
    //    if ( [response length] > 0)
    //        response = [response substringToIndex:[response length] - 1];
    //    // Remove first character
    //    response = [response substringFromIndex:1];
    //
    //    /* Gets value from JSON String */
    //    NSRange range = [response rangeOfString:inKey options:NSBackwardsSearch];
    //    NSLog(@"range.location: %lu", (unsigned long)range.location);
    //    NSString *substring = [response substringFromIndex:range.location];
    //    NSLog(@"substring: '%@'", substring);
    //    NSRange range1 = [substring rangeOfString:@"\": "];
    //    NSString *substring1 = [substring substringFromIndex:range1.location];
    //    NSLog(@"substring1: '%@'", substring1);
    //    NSString *newStr = [substring1 substringFromIndex:3];
    //    NSRange range2;
    //    NSString *correctString;
    //    @try {
    //        range2 = [newStr rangeOfString:@", "];
    //        correctString = [newStr substringWithRange:(NSMakeRange(0,range2.location))];
    //    }
    //    @catch (NSException *exception) {
    //        range2 = [newStr rangeOfString:@"}}"];
    //        correctString = [newStr substringWithRange:(NSMakeRange(0,range2.location))];
    //    }
    //    // Check for double quote
    //    if([correctString hasPrefix:@"\""]){
    //        // Remove first double quote
    //        correctString = [correctString substringFromIndex:1];
    //        // Remove last double quote
    //        correctString = [correctString substringToIndex:[correctString length] - 1];
    //    }
    //    NSLog(@"substring: '%@'", correctString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
