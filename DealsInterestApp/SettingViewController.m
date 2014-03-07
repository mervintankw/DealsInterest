//
//  SettingViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize messageText, sendButton, messageList;

bool sending = false;

NSString *chatServerURL = @"http://172.22.100.57:8888/";
//NSString *chatServerURL = @"http://175.156.194.165:8888/";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        lastId = 0;
        chatParser = NULL;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (messageList.contentSize.height > messageList.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, messageList.contentSize.height - messageList.frame.size.height);
//        [self.messageList setContentOffset:offset animated:YES];
//    }
//}

- (void)viewDidUnload {
}

- (void)getNewMessages {
    NSString *url = [NSString stringWithFormat:
                     @"%@iOSChat/messages.php?past=%d&t=%ld",chatServerURL,
                     lastId, time(0) ];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        receivedData = [NSMutableData data];
    }
    else
    {
    }
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    if (chatParser)
//        [chatParser release];
    
    if ( messages == nil )
        messages = [[NSMutableArray alloc] init];
    
    chatParser = [[NSXMLParser alloc] initWithData:receivedData];
    [chatParser setDelegate:self];
    [chatParser parse];
    
//    [receivedData release];
    
    [messageList reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if([appDelegate.notify isEqualToString:@"0"] || sending == true){
        CGPoint bottomOffset = CGPointMake(0, messageList.contentSize.height - messageList.bounds.size.height);
        if ( bottomOffset.y > 0 ) {
            [messageList setContentOffset:bottomOffset animated:YES];
        }
        appDelegate.notify = @"1";
//        sending = false;
//    }
    
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
//                                [self methodSignatureForSelector: @selector(timerCallback)]];
//    [invocation setTarget:self];
//    [invocation setSelector:@selector(timerCallback)];
//    timer = [NSTimer scheduledTimerWithTimeInterval:5.0
//                                         invocation:invocation repeats:NO];
}

- (void)timerCallback {
//    [timer release];
    [self getNewMessages];
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
    label.text = @"Setting";
    
    messageList.dataSource = self;
    messageList.delegate = self;
    
    [self getNewMessages];
    
    // Customize register button
    [_logoutBtn.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_logoutBtn.layer setBorderWidth: 1.0];
    _logoutBtn.layer.cornerRadius=8.0;
    [_logoutBtn setBackgroundColor:[UIColor colorWithRed:29/255.0f green:185/255.0f blue:222/255.0f alpha:1]];
    
    // Setup button event listener
    [_logoutBtn addTarget:self action:@selector(LogoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.messageText.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendClicked:textField];
    return NO;
}



- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    if ( [elementName isEqualToString:@"message"] ) {
        msgAdded = [attributeDict objectForKey:@"added"];
        msgId = [[attributeDict objectForKey:@"id"] intValue];
        msgUser = [[NSMutableString alloc] init];
        msgText = [[NSMutableString alloc] init];
        inUser = NO;
        inText = NO;
    }
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = YES;
    }
    if ( [elementName isEqualToString:@"text"] ) {
        inText = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( inUser ) {
        [msgUser appendString:string];
    }
    if ( inText ) {
        [msgText appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ( [elementName isEqualToString:@"message"] ) {
        if(msgId > lastId){
            [messages addObject:[NSDictionary dictionaryWithObjectsAndKeys:msgAdded,
                                 @"added",msgUser,@"user",msgText,@"text",nil]];
            NSLog(@"Last message ID: %d",msgId);
            lastId = msgId;
        }
        
//        [msgAdded release];
//        [msgUser release];
//        [msgText release];
    }
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = NO;
    }
    if ( [elementName isEqualToString:@"text"] ) {
        inText = NO;
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:
(NSInteger)section {
    return ( messages == nil ) ? 0 : [messages count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.messageList
                                                dequeueReusableCellWithIdentifier:@"ChatListItem"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatListItem"
                                                     owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[messages objectAtIndex:indexPath.row];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    textLabel.text = [itemAtIndex objectForKey:@"text"];
    UILabel *userLabel = (UILabel *)[cell viewWithTag:2];
    userLabel.text = [itemAtIndex objectForKey:@"user"];
    
    return cell;
}


- (IBAction)sendClicked:(id)sender {
    [messageText resignFirstResponder];
    if ( [messageText.text length] > 0 ) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *url = [NSString stringWithFormat:
                         @"%@iOSChat/add.php",chatServerURL];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                         init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"user=%@&message=%@&devicetoken=%@",
                           [prefs stringForKey:@"user_name"],
                           messageText.text,[prefs stringForKey:@"deviceToken"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = [[NSError alloc] init];
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response error:&error];
        
        sending = true;
        
        [self getNewMessages];
    }
    
    messageText.text = @"";
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    messageList.dataSource = self;
//    messageList.delegate = self;
//    
//    [self getNewMessages];
//}




-(void)LogoutBtnClick:(id)sender
{
    // Clear user data from session
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    // Push user back to login page
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogout)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
