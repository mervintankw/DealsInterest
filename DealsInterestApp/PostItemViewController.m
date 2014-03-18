//
//  PostItemViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 26/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "PostItemViewController.h"
#import "PostItem1ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SelectItemPhotoViewController.h"
#import "SBJsonParser.h"
#import "SelectCategoryViewController.h"
#import "EnterTitleViewController.h"
#import "EnterDescriptionViewController.h"
//#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"

@interface PostItemViewController ()

@property (nonatomic, strong) NSMutableArray *contentHeader;
@property (nonatomic, strong) NSArray *contentDetail;

@end

@implementation PostItemViewController

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
int uploadImage;
int uploadImageCount;
NSMutableArray *imageUrls;
NSString *inLocationAddress;
bool checkKeyboard;
int currentRowIndex;

int categoryRow = 0;
int titleRow = 1;
int locationRow = 2;
int priceRow = 4;
int conditionRow = 3;
int descriptionRow = 5;
int typeRow = 6;

UIToolbar* numberToolbar;
UITextField *priceTextBox;
UITextField *titleTextBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self.tableView reloadData];
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
    CGRect frame = CGRectMake(0, 0, 170, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Uploads";
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _contentHeader = [[NSMutableArray alloc] init];
    _contentHeader = [NSMutableArray arrayWithObjects:@"Category",@"Price",@"Location",@"Title",@"Condition",@"Description",@"Type", nil];
//    [_contentHeader setValue:@"Category" forKey:[NSString stringWithFormat:@"%d",categoryRow]];
//    [_contentHeader setValue:@"Price" forKey:[NSString stringWithFormat:@"%d",priceRow]];
//    [_contentHeader setValue:@"Location" forKey:[NSString stringWithFormat:@"%d",locationRow]];
//    [_contentHeader setValue:@"Title" forKey:[NSString stringWithFormat:@"%d",titleRow]];
//    [_contentHeader setValue:@"Condition" forKey:[NSString stringWithFormat:@"%d",conditionRow]];
//    [_contentHeader setValue:@"Description" forKey:[NSString stringWithFormat:@"%d",descriptionRow]];
//    [_contentHeader setValue:@"Type" forKey:[NSString stringWithFormat:@"%d",typeRow]];
//    _contentHeader set
    
    _contentDetail = [[NSMutableArray alloc] init];
    _contentDetail = [NSMutableArray arrayWithObjects:appDelegate.uploadCategory,appDelegate.uploadPrice,
                      appDelegate.uploadLocation,appDelegate.uploadTitle,appDelegate.uploadCondition,
                      appDelegate.uploadDescription,@"",nil];
    
    //To make the border look very close to a UITextField
    [_descriptionTextBox.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
    [_descriptionTextBox.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    _descriptionTextBox.layer.cornerRadius = 5;
    _descriptionTextBox.clipsToBounds = YES;
    
    /*
     Configuration for loading indicator
     */
    // make the area larger
    [_loadIndicator setFrame:self.view.frame];
    // set a background color
    [_loadIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    CGPoint center = self.view.center;
    _loadIndicator.center = center;
    [_loadIndicator stopAnimating];
    /*
     Configuration for loading indicator
     */
    
    // Load location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    
    imageUrls = [[NSMutableArray alloc] init];
    
    // Adds button listener to select item photo button click
    [_photo1Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo2Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo3Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo4Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photo5Btn addTarget:self action:@selector(SelectItemPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    // Load images for product if there is any
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] synchronize];
    arr = [[NSUserDefaults standardUserDefaults]valueForKey:@"postItemPhotoArray"];
    NSLog(@"Image Array Count: %d",[arr count]);
//    NSLog(@"Photo 1: %@",appDelegate.photo1);
    uploadImageCount = appDelegate.postItemPhotoCount;
    NSLog(@"image upload count: %d",uploadImageCount);
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
    
    UINib *cellNib = [UINib nibWithNibName:@"UploadItemTableCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"com.uploaditem.cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    self.tableView.frame= CGRectMake(0, 170, self.tableView.frame.size.width, self.tableView.frame.size.height);
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    inLocationAddress = [[NSString alloc] init];
    
    // Add post button
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(PostClick:)];
    self.navigationItem.rightBarButtonItem = done;
    
    [self.tableView reloadData];
    
    
    // Check that cover photo must be selected before doing anything else
    if (_photo1.image == [UIImage imageNamed: @"add_photo.png"]){
        // Load photo selection when arrive at posting view
        // Declare select item photo controller
        SelectItemPhotoViewController *selectItemPhotoViewController = [[SelectItemPhotoViewController alloc] init];
        // Push view controller into view
        [self.navigationController pushViewController:selectItemPhotoViewController animated:YES];
        // Load photo selection when arrive at posting view
    }
}

//-(void)cancelNumberPad{
//    [priceTextBox resignFirstResponder];
//    priceTextBox.text = @"";
//    [self.view endEditing:YES];
//}

-(void)doneWithNumberPad{
//    NSString *numberFromTheKeyboard = priceTextBox.text;
    NSLog(@"done with numberpad");
    [priceTextBox resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)PostClick:(UIButton *)sender
{
//    _contentHeader = [NSMutableArray arrayWithObjects:@"Category",@"Price",@"Location",@"Title",@"Condition",@"Description",@"Type", nil];
//    _contentDetail = [[NSMutableArray alloc] init];
//    _contentDetail = [NSMutableArray arrayWithObjects:appDelegate.uploadCategory,appDelegate.uploadPrice,
//                      appDelegate.uploadLocation,appDelegate.uploadTitle,appDelegate.uploadCondition,
//                      appDelegate.uploadDescription,@"",nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Validate inputs
    if([appDelegate.uploadCategory isEqualToString:@""] || [appDelegate.uploadPrice isEqualToString:@""] ||
       [appDelegate.uploadLocation isEqualToString:@""] || [appDelegate.uploadTitle isEqualToString:@""] ||
       [appDelegate.uploadCondition isEqualToString:@""] || [appDelegate.uploadDescription isEqualToString:@""]){
        // Create alert message
        UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                                 message:@"Please enter all fields!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
        // Display alert message
        [postFailed show];
    }else{
        [_loadIndicator startAnimating];
        [self uploadImageMethod:uploadImageCount];
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentHeader count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"com.uploaditem.cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    UILabel *headerLabel = (UILabel *)[cell viewWithTag:202];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:203];
    UISegmentedControl *conditionSwitch = (UISegmentedControl *)[cell viewWithTag:204];
    priceTextBox = (UITextField *)[cell viewWithTag:205];
    UIButton *locationIconButton = (UIButton *)[cell viewWithTag:206];
    UITextField *locationTextBox = (UITextField *)[cell viewWithTag:207];
    titleTextBox = (UITextField *)[cell viewWithTag:208];
    
    // Add return key to price textbox keyboard
//    priceTextBox.returnKeyType = UIReturnKeyDone;
    
    // toolbar for price text field
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           /*[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],*/
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    priceTextBox.inputAccessoryView = numberToolbar;
    // toolbar for price text field
    
    
//    headerLabel.text = [self.contentHeader objectAtIndex: [indexPath row]];
//    headerLabel.text = [self.contentHeader valueForKey:[NSString stringWithFormat:@"%d",[indexPath row]]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleTextBox.delegate = self;
    
    [conditionSwitch setHidden:TRUE];
    [priceTextBox setHidden:TRUE];
    [locationIconButton setHidden:TRUE];
    [locationTextBox setHidden:TRUE];
    [titleTextBox setHidden:TRUE];
    
    // Category row
    if([indexPath row] == categoryRow){
//        if(![appDelegate.uploadCategory isEqualToString:@""]){
            contentLabel.text = appDelegate.uploadCategory;
//        }
        headerLabel.text = @"Category";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Title row
    if([indexPath row] == titleRow){
//        if(![appDelegate.uploadTitle isEqualToString:@""]){
//            contentLabel.text = appDelegate.uploadTitle;
//        }
        headerLabel.text = @"Title";
        
        [titleTextBox setHidden:FALSE];
        [priceTextBox setHidden:TRUE];
        [conditionSwitch setHidden:TRUE];
        [contentLabel setHidden:TRUE];
        [titleTextBox addTarget:self action:@selector(updateTitleUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Price row
    if([indexPath row] == priceRow){
        [priceTextBox setHidden:FALSE];
        [conditionSwitch setHidden:TRUE];
        [contentLabel setHidden:TRUE];
        [titleTextBox setHidden:TRUE];
        [priceTextBox addTarget:self action:@selector(updateLabelUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
//        if(![appDelegate.uploadPrice isEqualToString:@""]){
//            contentLabel.text = appDelegate.uploadPrice;
//        }
        contentLabel.text = appDelegate.uploadPrice;
        headerLabel.text = @"Price";
    }
    // Condition row
    if([indexPath row] == conditionRow){
        [conditionSwitch setHidden:FALSE];
        [contentLabel setHidden:TRUE];
        [titleTextBox setHidden:TRUE];
        // Adds action control for segmented control
        [conditionSwitch addTarget:self action:@selector(segmentedControlSelectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
//        if(![appDelegate.uploadPrice isEqualToString:@""]){
//            contentLabel.text = appDelegate.uploadPrice;
//        }
        headerLabel.text = @"Condition";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Location row
    if([indexPath row] == locationRow){
        [locationIconButton setHidden:FALSE];
        [locationTextBox setHidden:FALSE];
        [contentLabel setHidden:TRUE];
        [titleTextBox setHidden:TRUE];
        [locationIconButton addTarget:self action:@selector(getAddressFromLocation:) forControlEvents:UIControlEventTouchDown];
        locationTextBox.text = appDelegate.uploadLocation;
        headerLabel.text = @"Location";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Description row
    if([indexPath row] == descriptionRow){
        [contentLabel setHidden:FALSE];
//        if(![appDelegate.uploadDescription isEqualToString:@""]){
            contentLabel.text = appDelegate.uploadDescription;
//        }
        headerLabel.text = @"Description";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Type row
    if([indexPath row] == typeRow){
        headerLabel.text = @"Type";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        }
    }
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDefault) {
        [textField resignFirstResponder];
    }
    
    return YES;  //dismisses the keyboard
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    currentRowIndex = [indexPath row];
    // Check that when keyboard is up do not allow row selection
    if(!checkKeyboard){
        // Category row
        if([indexPath row] == categoryRow){
            SelectCategoryViewController *selectCategoryViewController = [[SelectCategoryViewController alloc] init];
            [[self navigationController] pushViewController:selectCategoryViewController animated:YES];
        }
        // Price row
        if([indexPath row] == priceRow){
            
        }
        // Title row
        if([indexPath row] == titleRow){
            EnterTitleViewController *enterTitleViewController = [[EnterTitleViewController alloc] init];
            [[self navigationController] pushViewController:enterTitleViewController animated:YES];
        }
        // Description row
        if([indexPath row] == descriptionRow){
            EnterDescriptionViewController *enterDescriptionViewController = [[EnterDescriptionViewController alloc] init];
            [[self navigationController] pushViewController:enterDescriptionViewController animated:YES];
        }
    }else{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.view endEditing:YES];
    }
}

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

- (void)updateTitleUsingContentsOfTextField:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITextField *titleTextBox = (UITextField *)sender;
    NSLog(@"price: %@",titleTextBox.text);
    appDelegate.uploadTitle = titleTextBox.text;
}

- (void)updateLabelUsingContentsOfTextField:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITextField *priceTextBox = (UITextField *)sender;
    NSLog(@"price: %@",priceTextBox.text);
    // Convert string to nsmutablestring first
    NSMutableString *ms = [NSMutableString stringWithString:priceTextBox.text];
    // Remove all decimal points in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"." withString:@""] mutableCopy];
    // Remove all commas in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"," withString:@""] mutableCopy];
    // Remove all dollar sign in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"$" withString:@""] mutableCopy];
    if([ms hasPrefix:@"0"]){
        priceTextBox.text = [ms substringFromIndex:1];
        // Convert string to nsmutablestring first
        ms = [NSMutableString stringWithString:priceTextBox.text];
        // Remove all decimal points in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"." withString:@""] mutableCopy];
        // Remove all commas in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"," withString:@""] mutableCopy];
        // Remove all dollar sign in string
        ms = [[ms stringByReplacingOccurrencesOfString:@"$" withString:@""] mutableCopy];
        NSLog(@"Modified string: %@",ms);
    }
    
    int dollarLength = 0;
    if([ms length] >= 6){
        dollarLength = [ms length] - 2;
        while(dollarLength > 0){
            if(dollarLength != [ms length] - 2){
                [ms insertString:@"," atIndex:dollarLength];
            }
            dollarLength = dollarLength - 3;
        }
    }
    if([ms length] > 2){
        [ms insertString:@"." atIndex:[ms length]-2];
    }
    if([ms length] == 1){
        [ms insertString:@"0.0" atIndex:0];
    }
    if([ms length] == 2){
        [ms insertString:@"0." atIndex:0];
    }
    appDelegate.uploadPrice = [NSString stringWithFormat:@"%@",ms];
    if(![ms hasPrefix:@"$"]){
        priceTextBox.text = [NSString stringWithFormat:@"$%@",ms];
    }
}

-(void)getAddressFromLocation:(id)sender
{
    NSLog(@"In location button");
//    [self getAddressFromLatLon:locationManager.location.coordinate.latitude withLongitude:locationManager.location.coordinate.longitude];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    [self.tableView reloadData];
    NSLog(@"Current Location: %@",inLocationAddress);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.uploadLocation = inLocationAddress;
}

-(void)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:pdblLatitude longitude:pdblLongitude];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            inLocationAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                          placemark.subThoroughfare, placemark.thoroughfare,
                                          placemark.postalCode, placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
//    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            inLocationAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

- (IBAction)segmentedControlSelectedIndexChanged:(UISegmentedControl*)segmentedControl
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(segmentedControl.selectedSegmentIndex == 0){
        appDelegate.uploadCondition = @"new";
    }
    if(segmentedControl.selectedSegmentIndex == 1){
        appDelegate.uploadCondition = @"used";
    }
}

// Method trigger whenever use touches somewhere other than the keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)keyboardDidShow: (NSNotification *) notif{
//    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, 170, self.tableView.frame.size.width, self.tableView.frame.size.height - 170);
//    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:3 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:currentRowIndex inSection:0];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-40, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    [self.tableView scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    checkKeyboard = TRUE;
}

- (void)keyboardDidHide: (NSNotification *) notif{
//    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, 170, self.tableView.frame.size.width, self.tableView.frame.size.height + 170);
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [UIView animateWithDuration:.3 animations:^(void)
     {
         self.tableView.contentInset = UIEdgeInsetsZero;
         self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
     }];
    checkKeyboard = FALSE;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)uploadImageMethod:(int)i
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSLog(@"pk: %@",[prefs objectForKey:@"pk"]);
//    NSLog(@"UDID: %@",[prefs objectForKey:@"udid"]);
//    NSLog(@"token: %@",[prefs objectForKey:@"token"]);
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
            NSLog(@"pk: %@",[prefs stringForKey:@"pk"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"device_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"udid"]] dataUsingEncoding:NSUTF8StringEncoding]];  // device_id
            NSLog(@"udid: %@",[prefs stringForKey:@"udid"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[prefs stringForKey:@"token"]] dataUsingEncoding:NSUTF8StringEncoding]];  // token
    NSLog(@"token: %@",[prefs stringForKey:@"token"]);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"upload_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];  // upload_type
    
//    // Convert user profile picture into jpeg
//    NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo1,1.0);
//    // Append image data to post
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"test.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:inImage]];  // profilePic
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(i==1){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo1,0.1);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==2){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo2,0.1);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==3){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo3,0.1);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==4){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo4,0.1);
        // Append image data to post
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"hello.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:inImage]];  // itemPic
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(i==5){
        // Convert user profile picture into jpeg
        NSData *inImage = UIImageJPEGRepresentation(appDelegate.photo5,0.1);
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
    [body appendData:[[NSString stringWithString:appDelegate.uploadTitle] dataUsingEncoding:NSUTF8StringEncoding]];  // title
    NSLog(@"title: %@",appDelegate.uploadTitle);
    
    appDelegate.uploadPrice = [appDelegate.uploadPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"price\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appDelegate.uploadPrice] dataUsingEncoding:NSUTF8StringEncoding]];  // price
    NSLog(@"price: %@",appDelegate.uploadPrice);
    
    // Convert string to nsmutablestring first
    NSMutableString *ms1 = [NSMutableString stringWithString:appDelegate.uploadDescription];
    // Remove all decimal points in string
    ms1 = [[ms1 stringByReplacingOccurrencesOfString:@"\n" withString:@" "] mutableCopy];
    appDelegate.uploadDescription = [NSString stringWithFormat:@"%@",ms1];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"description\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appDelegate.uploadDescription] dataUsingEncoding:NSUTF8StringEncoding]];  // description
    NSLog(@"description: %@",appDelegate.uploadDescription);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"category\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appDelegate.uploadCategory] dataUsingEncoding:NSUTF8StringEncoding]];  // category
    NSLog(@"category: %@",appDelegate.uploadCategory);
    
//    int urlCount = 1;
    NSLog(@"Total number of image URLs: %d",[imageUrls count]);
    for(int i=1;i<=[imageUrls count];i--){
        NSString *val = [imageUrls objectAtIndex:i];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo%d\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@",val]] dataUsingEncoding:NSUTF8StringEncoding]];  // image_url
        NSLog(@"Post Image URL Upload: %@",val);
//        urlCount = urlCount + 1;
    }
    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"photo1\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@",inUrl]] dataUsingEncoding:NSUTF8StringEncoding]];  // image_url
    
    // Convert string to nsmutablestring first
    NSMutableString *ms = [NSMutableString stringWithString:appDelegate.uploadLocation];
    // Remove all decimal points in string
    ms = [[ms stringByReplacingOccurrencesOfString:@"\n" withString:@" "] mutableCopy];
    appDelegate.uploadLocation = [NSString stringWithFormat:@"%@",ms];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"location_name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appDelegate.uploadLocation] dataUsingEncoding:NSUTF8StringEncoding]];  // location_name
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"location_address\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appDelegate.uploadLocation] dataUsingEncoding:NSUTF8StringEncoding]];  // location_address
    
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
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"hp\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"90938379"] dataUsingEncoding:NSUTF8StringEncoding]];  // hp
    
    NSString *con = [[NSString alloc] init];
    if([appDelegate.uploadCondition isEqualToString:@"new"]){
        con = @"0";
    }else{
        con = @"1";
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"condition\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:con] dataUsingEncoding:NSUTF8StringEncoding]];  // token

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
                [_loadIndicator stopAnimating];
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
        NSLog(@"Uploading image ...");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
