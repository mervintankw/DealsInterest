//
//  SearchViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 10/12/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "SearchViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "ViewItemViewController.h"
#import "FilterViewController.h"
#import "UserProfileViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) NSMutableArray *searchUserResultUserId;
@property (nonatomic, strong) NSMutableArray *searchUserResultImage;
@property (nonatomic, strong) NSMutableArray *searchUserResultUsername;
@property (nonatomic, strong) NSMutableArray *searchUserResultName;
@property (nonatomic, strong) NSMutableArray *searchUserResultFollowStatus;

@property (nonatomic, strong) NSMutableArray *searchProductResultPk;
@property (nonatomic, strong) NSMutableArray *searchProductResultProfilePic;
@property (nonatomic, strong) NSMutableArray *searchProductResultPrice;
@property (nonatomic, strong) NSMutableArray *searchProductResultTitle;
@property (nonatomic, strong) NSMutableArray *searchProductResultCondition;
@property (nonatomic, strong) NSMutableArray *searchProductResultAddress;
@property (nonatomic, strong) NSMutableArray *searchProductResultLikes;
@property (nonatomic, strong) NSMutableArray *searchProductResultDescription;

@end

@implementation SearchViewController

// 0 request for user result
// 1 request for product result
int requestType = 0;
NSString *searchToggle;
bool noResultFound = NO;

int tapCount;
NSIndexPath *tableSelection;
NSString *selectedTitle;
NSString *likesNo;


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
    
    // Add Filter Button to Navigation Bar right side
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(display_filter)];
    
    [self LoadView];
}

-(void)display_filter {
    NSLog(@"Displaying filter");
    FilterViewController *filterViewController = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    [self.navigationController pushViewController:filterViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self LoadView];
}

- (void)LoadView
{
    self.SearchTextBox.delegate = self;
    
    // Setup search button event listener
    [_SearchBtn addTarget:self action:@selector(SearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Initialize variables
    searchToggle = [[NSString alloc] init];
    if(_ProductUserSegementedControl.selectedSegmentIndex == 0){
        searchToggle = @"products";
    }
    if(_ProductUserSegementedControl.selectedSegmentIndex == 1){
        searchToggle = @"users";
    }
    
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Search";
    
    _searchUserResultUsername = [[NSMutableArray alloc] initWithObjects:@"Person 1",@"Person 2",@"Person 3",@"Person 4", nil];
    
//    UINib *cellNib;
//    if([searchToggle isEqualToString:@"users"]){
//        cellNib = [UINib nibWithNibName:@"NibSearchUserResultCell" bundle:nil];
//        [self.SearchResultTableView registerNib:cellNib forCellReuseIdentifier:@"com.searchuser.cell"];
//    }else if([searchToggle isEqualToString:@"products"]){
//        cellNib = [UINib nibWithNibName:@"NibSearchProductResultCell" bundle:nil];
//        [self.SearchResultTableView registerNib:cellNib forCellReuseIdentifier:@"com.searchproduct.cell"];
//    }
//    
//    
//    self.SearchResultTableView.delegate = self;
//    self.SearchResultTableView.dataSource = self;
//    
//    [self.SearchResultTableView reloadData];
}

- (void)singleTap {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Single tap detected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    tapCount = 0;
    
    // Unhide tab bar if its hidden
//    if(hidden){
//        hidden = NO;
//        [self.tabBarController setTabBarHidden:NO animated:YES];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
    
    // Declare view item view controller
    ViewItemViewController *viewItemViewController = [[ViewItemViewController alloc] init];
    // Set category selected into post item view controller variable
    NSLog(@"selectedTitle = %@",selectedTitle);
    viewItemViewController.itemId = selectedTitle;
    viewItemViewController.likesNo = likesNo;
    // Push view controller into view
    [self.navigationController pushViewController:viewItemViewController animated:YES];
}

-(void)SearchBtnClick:(id)sender
{
    if ([searchToggle isEqualToString:@"users"] || [searchToggle isEqualToString:@"products"]) {
        NSString *urlFunction;
        
        if ([searchToggle isEqualToString:@"users"]) { // For user search
            _searchUserResultImage = [[NSMutableArray alloc] init];
            _searchUserResultUsername = [[NSMutableArray alloc] init];
            _searchUserResultUserId = [[NSMutableArray alloc] init];
            
            requestType = 0;
            urlFunction = @"user.search";
        } else { // For product search
            _searchProductResultPk = [[NSMutableArray alloc] init];
            _searchProductResultProfilePic = [[NSMutableArray alloc] init];
            _searchProductResultPrice = [[NSMutableArray alloc] init];
            _searchProductResultTitle = [[NSMutableArray alloc] init];
            _searchProductResultCondition = [[NSMutableArray alloc] init];
            _searchProductResultAddress = [[NSMutableArray alloc] init];
            _searchProductResultLikes = [[NSMutableArray alloc] init];
            _searchProductResultDescription = [[NSMutableArray alloc] init];
            
            requestType = 1;
            urlFunction = @"search.searchItem";
        }
        
        // Post request
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/%@/",appDelegate.apiUrl, urlFunction]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        //initialize a post data
        NSString *postData = [NSString stringWithFormat:@"search=%@", _SearchTextBox.text];
        //set request content type we MUST set this value.
        
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //set post data of request
        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        
        //initialize a connection from request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = connection;
        
        //start the connection
        [connection start];
        
        // Start spinner
        [self.activityIndicator startAnimating];
        
        NSLog(@"Requesting URL: %@", [url absoluteString]);
    }
    
    [_SearchTextBox resignFirstResponder];
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if([searchToggle isEqualToString:@"users"]) {
        NSString *userId = [_searchUserResultUserId objectAtIndex:indexPath.row];
        NSLog(@"Go to user profile with Id %@", userId);
        
        // Declare user profile view controller
        UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] init];
        
        // Set user id selected into user profile view controller variable
        userProfileViewController.postUserId = userId;
        
        // Push view controller into view
        [self.navigationController pushViewController:userProfileViewController animated:YES];
    } else {
        tableSelection = indexPath;
        
        tapCount++;
        NSString *pkData = [_searchProductResultPk objectAtIndex:indexPath.row];
        NSString *likeData = [_searchProductResultLikes objectAtIndex:indexPath.row];
        
        NSLog(@"pkData = %@", pkData);
        switch (tapCount) {
            case 1: //single tap
                selectedTitle = pkData;
                likesNo = likeData;
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    
    if ([searchToggle isEqualToString:@"users"]){
        count = [_searchUserResultUsername count];
    } else {
        count = [_searchProductResultTitle count];
    }
    
    if (count == 0) {
        noResultFound = YES;
        NSLog(@"No of count: %d", count);
        return 1; // Return a row for display of "No Result" message
    } else {
        noResultFound = NO;
        NSLog(@"No of count: %d", count);
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITableViewCell *cell;
    
    if (noResultFound) {
        CellIdentifier = @"noResultTable";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"No Result";
        
        return cell;
    } else {
        if([searchToggle isEqualToString:@"users"]){
            CellIdentifier = @"com.searchuser.cell";
        }
        if([searchToggle isEqualToString:@"products"]){
            CellIdentifier = @"com.searchproduct.cell";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        if([searchToggle isEqualToString:@"users"]){
            UIImageView *profilePicImageView = (UIImageView *)[cell viewWithTag:220];
            UILabel *usernameLabel = (UILabel *)[cell viewWithTag:221];
            //UILabel *nameLabel = (UILabel *)[cell viewWithTag:222];
            //UIButton *followStatusButton = (UIButton *)[cell viewWithTag:223];

            usernameLabel.text = [_searchUserResultUsername objectAtIndex:[indexPath row]];
        }else if([searchToggle isEqualToString:@"products"]){
            if([indexPath row] < [_searchProductResultTitle count]){
                if(![[_searchProductResultTitle objectAtIndex:[indexPath row]]isEqualToString:@"notitle"]){
                                UIImageView *profilePicImageView = (UIImageView *)[cell viewWithTag:230];
                    UILabel *titleLabel = (UILabel *)[cell viewWithTag:231];
                    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:232];
                    UILabel *locationLabel = (UILabel *)[cell viewWithTag:233];
                    UILabel *likeLabel = (UILabel *)[cell viewWithTag:234];
                    UILabel *priceLabel = (UILabel *)[cell viewWithTag:235];
                    
        //            if(![[_searchProductResultProfilePic objectAtIndex:[indexPath row]]isEqual:@""]){
                        NSMutableString* theString = [NSMutableString stringWithFormat:@"%1$@%2$@",appDelegate.apiUrl,[_searchProductResultProfilePic objectAtIndex:[indexPath row]]];
                        // Here we use the new provided setImageWithURL: method to load the web image
                        [profilePicImageView setImageWithURL:[NSURL URLWithString:theString]
                                         placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        //            }
        //            NSLog(@"%d",[indexPath row]);
                    titleLabel.text = [_searchProductResultTitle objectAtIndex:[indexPath row]];
                    descriptionLabel.text = [NSString stringWithFormat:@"%@",[_searchProductResultDescription objectAtIndex:[indexPath row]]];
                    locationLabel.text = [_searchProductResultAddress objectAtIndex:[indexPath row]];
                    likeLabel.text = [_searchProductResultLikes objectAtIndex:[indexPath row]];
                    priceLabel.text = [NSString stringWithFormat:@"$%@",[_searchProductResultPrice objectAtIndex:[indexPath row]]];
                    
                    //        NSLog(@"%@",[_searchProductResultTitle objectAtIndex:[indexPath row]]);
                }
            }
            
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
//        //reload collection view data
//        [self.SearchResultTableView reloadData];
//    }
}

- (IBAction)segmentedControlSelectedIndexChanged:(UISegmentedControl*)segmentedControl
{
    if(segmentedControl.selectedSegmentIndex == 0){
        searchToggle = @"products";
    }
    if(segmentedControl.selectedSegmentIndex == 1){
        searchToggle = @"users";
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
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    NSLog(@"%@" , htmlSTR);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlSTR];
    
    NSString *responseText = [[jsonDictionary valueForKey:@"responseText"] objectAtIndex:0];
    NSLog(@"Response Text: %@",responseText);
    
    if ([responseText isEqualToString:@"Success!"]) {
        // User search
        if(requestType == 0){
            NSArray *postCountArray = [jsonDictionary valueForKey:@"pk"];
            for(NSDictionary *pCount in postCountArray){
                NSLog(@"ID: %@",pCount);
            }
            
            
            NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
            for (NSDictionary *obj in fieldsArray) {
                // Add User Id to array for loading of profile view later
                [_searchUserResultUserId addObject:[NSString stringWithFormat:@"%@", [obj valueForKey:@"user_id"]]];
                NSLog(@"User Id: %@", [obj valueForKey:@"user_id"]);
                
                // Add Username to array for table list to display later
                [_searchUserResultUsername addObject:[NSString stringWithFormat:@"%@", [obj valueForKey:@"user_name"]]];
                NSLog(@"Username: %@", [obj valueForKey:@"user_name"]);
                
                // Add User Image to array for table list to display later
                if([[obj valueForKey:@"profile_pic"] isEqual:@""]){
                    [_searchUserResultImage addObject:[NSString stringWithFormat:@"noimage"]];
                    NSLog(@"No Profile Pic");
                } else {
                    [_searchUserResultImage addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"profile_pic"]]];
                    NSLog(@"Profile Pic: %@", [obj valueForKey:@"profile_pic"]);
                }
                
                UINib *cellNib = [UINib nibWithNibName:@"NibSearchUserResultCell" bundle:nil];
                [self.SearchResultTableView registerNib:cellNib forCellReuseIdentifier:@"com.searchuser.cell"];
            }
        // Product search
        } else if (requestType == 1){
            for(NSDictionary *obj in jsonDictionary){
                NSArray *postCountArray = [jsonDictionary valueForKey:@"pk"];
                for(NSDictionary *pCount in postCountArray){
                    [_searchProductResultPk addObject:[NSString stringWithFormat:@"%@",pCount]];
                }
            }
            
            NSArray *fieldsArray = [jsonDictionary valueForKey:@"fields"];
            for (NSDictionary *obj in fieldsArray){
                if([[obj valueForKey:@"profile_pic"] isEqual:@""]){
                    [_searchProductResultProfilePic addObject:[NSString stringWithFormat:@"noimage"]];
                }else{
                    [_searchProductResultProfilePic addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"photo1"]]];
                }
                [_searchProductResultPrice addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"price"]]];
                if([[obj valueForKey:@"title"] isEqual:@""]){
                    [_searchProductResultTitle addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"notitle"]]];
                }else{
                    [_searchProductResultTitle addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"title"]]];
                }
                [_searchProductResultCondition addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"condition"]]];
                [_searchProductResultAddress addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"location_address"]]];
                [_searchProductResultLikes addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"like_no"]]];
                [_searchProductResultDescription addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"description"]]];
               
            }
            NSLog(@"%d",[_searchProductResultProfilePic count]);
            NSLog(@"%d",[_searchProductResultPrice count]);
            NSLog(@"%d",[_searchProductResultTitle count]);
            NSLog(@"%d",[_searchProductResultCondition count]);
            NSLog(@"%d",[_searchProductResultAddress count]);
            NSLog(@"%d",[_searchProductResultLikes count]);
            NSLog(@"%d",[_searchProductResultDescription count]);
            
            UINib *cellNib = [UINib nibWithNibName:@"NibSearchProductResultCell" bundle:nil];
            [self.SearchResultTableView registerNib:cellNib forCellReuseIdentifier:@"com.searchproduct.cell"];
            
        }
    }
    
    self.SearchResultTableView.delegate = self;
    self.SearchResultTableView.dataSource = self;
    
    [self.SearchResultTableView reloadData];
    
    [self.activityIndicator stopAnimating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([searchToggle isEqualToString:@"users"]){
        requestType = 0;
        
    }else if([searchToggle isEqualToString:@"products"]){
        _searchProductResultPk = [[NSMutableArray alloc] init];
        _searchProductResultProfilePic = [[NSMutableArray alloc] init];
        _searchProductResultPrice = [[NSMutableArray alloc] init];
        _searchProductResultTitle = [[NSMutableArray alloc] init];
        _searchProductResultCondition = [[NSMutableArray alloc] init];
        _searchProductResultAddress = [[NSMutableArray alloc] init];
        _searchProductResultLikes = [[NSMutableArray alloc] init];
        _searchProductResultDescription = [[NSMutableArray alloc] init];
        
        requestType = 1;
        // Post request
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        
        //initialize url that is going to be fetched.
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@json/search.searchItem/",appDelegate.apiUrl]];
        
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        [request setHTTPMethod:@"POST"];
        //initialize a post data
        NSString *postData = [NSString stringWithFormat:@"search=%@", _SearchTextBox.text];
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
    
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
