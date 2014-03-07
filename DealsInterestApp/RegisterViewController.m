//
//  RegisterViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 23/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "SelectProfilePicViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

AppDelegate *appDelegate;
NSString *udid;
int updateImage;
//NSString *imageURL;

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

-(void)LoadView
{
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Register";
    
    // Get device unique ID
    udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(@" Device UDID: %@",udid);
    // Customize register button
    [_registerBtn.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_registerBtn.layer setBorderWidth: 1.0];
    _registerBtn.layer.cornerRadius=8.0;
    [_registerBtn setBackgroundColor:[UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1]];
    
    // Setup button event listener
    [_registerBtn addTarget:self action:@selector(RegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // To enable return key to hide keyboard
    _passwordTextBox.delegate = self;
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == _passwordTextBox) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(void)RegisterBtnClick:(id)sender
{
    // Get username text box value
    NSString *inUsername = _usernameTextBox.text;
    // Get email text box value
    NSString *inEmail = _emailTextBox.text;
    // Get password text box value
    NSString *inPassword = _passwordTextBox.text;
    
    if([inUsername isEqual:@""] || [inEmail isEqual:@""] || [inPassword isEqual:@""])
    {
        // Create alert message
        UIAlertView *registerFailed = [[UIAlertView alloc] initWithTitle:@"Registration"
                                                              message:@"Please enter all fields!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        // Display alert message
        [registerFailed show];
    }
    else if(![self NSStringIsValidEmail:inEmail])
    {
        // Create alert message
        UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Registration"
                                                                 message:@"Invalid email address entered!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
        // Display alert message
        [invalidEmail show];
    }
    else
    {
        updateImage = 0;
        
        // Post request
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.insert/",appDelegate.apiUrl]];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.updatePic/",appDelegate.apiUrl]];
        
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
        
        
        
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"92" dataUsingEncoding:NSUTF8StringEncoding]];  // user_id
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:inUsername] dataUsingEncoding:NSUTF8StringEncoding]];  // username
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:inEmail] dataUsingEncoding:NSUTF8StringEncoding]];  // email
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:inPassword] dataUsingEncoding:NSUTF8StringEncoding]];  // password
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[udid dataUsingEncoding:NSUTF8StringEncoding]];  // udid
        
//        // Convert user profile picture into jpeg
//        NSData *inImage = UIImageJPEGRepresentation(appDelegate.regiserProfilePic,1.0);
//        // Append image data to post
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: form-data; name=\"profile_pic\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[NSData dataWithData:inImage]];  // profilePic
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // adding the body we've created to the request
        [request setHTTPBody:body];

        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = connection;
        
        //start the connection
        [connection start];
        // Post request
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
    NSLog(@"%@",htmlSTR);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];

    // Register user
    if(updateImage == 0){
        NSLog(@"Update image count: %d",updateImage);
        for(NSDictionary *obj in jsonDictionary){
            NSLog(@"%@", [obj objectForKey:@"responseCode"]);
            //    NSLog(@"%@",[jsonDictionary valueForKey:@"responseCode"]);
            // Checks username and password
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                // Store userid into session
                [prefs setObject:[obj objectForKey:@"result"] forKey:@"pk"];
                // Store user_name into session
                [prefs setObject:_usernameTextBox.text forKey:@"user_name"];
                // Store email into session
                [prefs setObject:_emailTextBox.text forKey:@"email"];
                // Store token into session
                [prefs setObject:[NSString stringWithFormat:@"%@",[obj objectForKey:@"token"]] forKey:@"token"];
                // Store udid into session
                [prefs setObject:udid forKey:@"udid"];
//                NSLog(@"%@",[NSString stringWithFormat:@"%@",[obj objectForKey:@"token"]]);
                // Set update image to true so that it will proceed to udpating of user's profile picture
                updateImage = 1;
                
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
                [body appendData:[[NSString stringWithFormat:@"%@",[obj objectForKey:@"result"]] dataUsingEncoding:NSUTF8StringEncoding]];  // user_id
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:udid] dataUsingEncoding:NSUTF8StringEncoding]];  // device_id
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:[prefs stringForKey:@"token"]] dataUsingEncoding:NSUTF8StringEncoding]];  // token
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"upload_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];  // upload_type
                
                // Convert user profile picture into jpeg
                NSData *inImage = UIImageJPEGRepresentation(appDelegate.registerProfilePic,1.0);
                // Append image data to post
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
                
        }else if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"5"]){
                // Create alert message
                UIAlertView *userExist = [[UIAlertView alloc] initWithTitle:@"Registration"
                                                                      message:@"User already exists!"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                // Display alert message
                [userExist show];
            }else{
                // Create alert message
                UIAlertView *registerFailed = [[UIAlertView alloc] initWithTitle:@"Registration"
                                                                         message:@"Invalid input for registration!"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                // Display alert message
                [registerFailed show];
            }
        }
    }else if(updateImage == 1){ // Upload Picture
        NSLog(@"Update image count: %d",updateImage);
        updateImage = 2;
        for(NSDictionary *obj in jsonDictionary){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSLog(@"update image 2 response code: %@", [obj objectForKey:@"responseCode"]);
            NSLog(@"2 user id: %@",[prefs stringForKey:@"pk"]);
            NSLog(@"2 token: %@",[prefs stringForKey:@"token"]);
            NSLog(@"2 UDID: %@",udid);
            NSLog(@"2 img url: %@",[NSString stringWithString:[obj objectForKey:@"image_url"]]);
//            imageURL = [obj objectForKey:@"img_url"];
            //    NSLog(@"%@",[jsonDictionary valueForKey:@"responseCode"]);
            
            // Post request
            //if there is a connection going on just cancel it.
            [self.connection cancel];
            
            //initialize new mutable data
            NSMutableData *data = [[NSMutableData alloc] init];
            self.receivedData = data;
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.updatePic/",appDelegate.apiUrl]];
            
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
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:udid] dataUsingEncoding:NSUTF8StringEncoding]];  // device_id
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:[prefs stringForKey:@"token"]] dataUsingEncoding:NSUTF8StringEncoding]];  // token
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"image_url\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:[obj objectForKey:@"image_url"]] dataUsingEncoding:NSUTF8StringEncoding]];  // image url
            
//            // Convert user profile picture into jpeg
//            NSData *inImage = UIImageJPEGRepresentation(appDelegate.registerProfilePic,1.0);
//            // Append image data to post
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[NSData dataWithData:inImage]];  // profilePic
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // adding the body we've created to the request
            [request setHTTPBody:body];
            
            //initialize a connection from request
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            self.connection = connection;
            
            //start the connection
            [connection start];
            // Post request
        }
    }else if(updateImage == 2){ // Update Profile Picture
        NSLog(@"Update image count: %d",updateImage);
        for(NSDictionary *obj in jsonDictionary){
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
                // Create alert message
                UIAlertView *registerSuccess = [[UIAlertView alloc] initWithTitle:@"Registration"
                                                                          message:@"Registration Success!"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                // Display alert message
                [registerSuccess show];
                // Auto login user once registration is successfully
                [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogin)];
            }
        }
    }
}
// NSURLConnection methods

// Email Validation method
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
