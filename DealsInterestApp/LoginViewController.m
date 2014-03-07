//
//  LoginViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 3/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "LoginViewController.h"
#import "PKRevealController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "RegisterViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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
    label.text = @"Login";
    
    // Customize login button
    [_loginBtn.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_loginBtn.layer setBorderWidth: 1.0];
    _loginBtn.layer.cornerRadius=8.0;
    [_loginBtn setBackgroundColor:[UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1]];
    
    // Customize register button
    [_registerBtn.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_registerBtn.layer setBorderWidth: 1.0];
    _registerBtn.layer.cornerRadius=8.0;
    [_registerBtn setBackgroundColor:[UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1]];
    
    // Preload user email into email text box if there is any
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *pEmail = [prefs stringForKey:@"email"];
    if(pEmail.length != 0)
        _emailTextBox.text = pEmail;
    
    // Setup button event listener
    [_loginBtn addTarget:self action:@selector(LoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn addTarget:self action:@selector(RegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _passwordTextBox.delegate = self;
    
    // Check for available user session
    NSUserDefaults *checkPrefs = [NSUserDefaults standardUserDefaults];
    if(([checkPrefs stringForKey:@"pk"].length != 0) && ([checkPrefs stringForKey:@"user_name"].length != 0) && ([checkPrefs stringForKey:@"email"].length != 0)){
        NSLog(@"%@",[checkPrefs stringForKey:@"pk"]);
        NSLog(@"User auto login as session is found!");
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogin)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == _passwordTextBox) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

// Method trigger on button click on register button
-(void)RegisterBtnClick:(id)sender
{
    // Declare register view controller
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    // Push view controller into view
    [self.navigationController pushViewController:registerViewController animated:YES];
}

// Method trigger on button click on login button
-(void)LoginBtnClick:(id)sender
{
    //NSLog(@"BtnClick");
    
    // Get email text box value
    NSString *inEmail = _emailTextBox.text;
    // Get password text box value
    NSString *inPassword = _passwordTextBox.text;
    
    // Post request
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/user.LoginUser/",appDelegate.apiUrl]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"email=%1$@&password=%2$@&device_id=%3$@", inEmail,inPassword,[UIDevice currentDevice].identifierForVendor.UUIDString];
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
    
    
    
//    // Checks username and password
//    if([inEmail isEqual: @"mervin"] && [inPassword isEqual: @"mervin"]){
//        //NSLog(@"Good Job!!");
//        [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogin)];
//    }else{
//        // Create alert message
//        UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed"
//                                                        message:@"Username and Password don't match!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        // Display alert message
//        [loginFailed show];
//    }
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
    NSLog(@"%@",htmlSTR);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    for(NSDictionary *obj in jsonDictionary){
        NSLog(@"%@", [obj objectForKey:@"responseCode"]);
//    NSLog(@"%@",[jsonDictionary valueForKey:@"responseCode"]);
    // Checks username and password
    if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"responseCode"]] isEqual: @"1"]){
        // Proceed to extracting user's username and store into session
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
        // Store pk into session
        NSArray *pPkArray = [jsonDictionary valueForKey:@"pk"];
        for(NSString *obj in pPkArray){
            NSLog(@"user pk: %@",obj);
            [prefs setObject:obj forKey:@"pk"];
        }
        // Store token into session
        NSArray *tokenArray = [jsonDictionary valueForKey:@"token"];
        for(NSString *obj in tokenArray){
            
            [prefs setObject:obj forKey:@"token"];
        }
        // Store udid into session
        [prefs setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"udid"];
        
        NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
        for (NSDictionary *obj in fieldsArray){
            //objValue = obj;
            //NSLog(@"obj: %@", [obj valueForKey:@"email"]);
            
            // Populate profile picture
            NSString* user_name = [obj valueForKey:@"user_name"];
            NSString* email = [obj valueForKey:@"email"];
            
            // Store user_name into session
            [prefs setObject:user_name forKey:@"user_name"];
            // Store email into session
            [prefs setObject:email forKey:@"email"];
        }
        NSLog(@"User login success after registration!");
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogin)];
    }else{
        // Create alert message
        UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                              message:@"Username and Password don't match!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        // Display alert message
        [loginFailed show];
    }
    }

}
// NSURLConnection methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
