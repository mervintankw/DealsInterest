//
//  ProfileMenuViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 5/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import "ProfileMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MeViewController.h"
#import "AppDelegate.h"
#import "PKRevealController.h"
#import "UpdateProfileViewController.h"

@interface ProfileMenuViewController ()

@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;
//@property (nonatomic, strong) NSMutableArray *otherItems;

@end

@implementation ProfileMenuViewController

// 0 = populate account table view
// 1 = populate other table view
int populateTablePurpose = 0;

int tapCount;
NSIndexPath *tableSelection;

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
    
    UINib *cellNib;
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];
    
    NSString *accountKey = @"Account";
    NSString *othersKey = @"Others";
    NSString *logoutKey = @"Logout";
    
    [contents setObject:[NSArray arrayWithObjects:@"Edit Profile",@"My Products",@"My Offers",@"My Bookmarks",@"Transaction History", nil] forKey:accountKey];
    [contents setObject:[NSArray arrayWithObjects:@"Invite Friends",@"Notifications", nil] forKey:othersKey];
    [contents setObject:[NSArray arrayWithObjects:@"Logout", nil] forKey:logoutKey];
    
    [keys addObject:accountKey];
    [keys addObject:othersKey];
    [keys addObject:logoutKey];
    
    [self setSectionKeys:keys];
    [self setSectionContents:contents];
    
    populateTablePurpose = 0;
    
    cellNib = [UINib nibWithNibName:@"NibProfileMenuAccountCell" bundle:nil];
    [self.accountTableView registerNib:cellNib forCellReuseIdentifier:@"com.accountitem.cell"];
    
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    
    [self.accountTableView reloadData];
    
    
    
//    populateTablePurpose = 1;
//
//    cellNib = [UINib nibWithNibName:@"NibProfileMenuAccountCell" bundle:nil];
//    [self.otherTableView registerNib:cellNib forCellReuseIdentifier:@"com.accountitem.cell"];
//    
//    self.otherTableView.delegate = self;
//    self.otherTableView.dataSource = self;
//    
//    [self.otherTableView reloadData];

    
    // Set padding left to button texts
//    [_myProfileBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_editLayoutBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_myProductsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_myOffersBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_myBookmarksBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_transactionHistoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_inviteFriendsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_notificationsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    // Set border to buttons
//    float borderThickness = 1.0f;
//    [[_myProfileBtn layer] setBorderWidth:borderThickness];
//    [[_myProfileBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_editLayoutBtn layer] setBorderWidth:borderThickness];
//    [[_editLayoutBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_myProductsBtn layer] setBorderWidth:borderThickness];
//    [[_myProductsBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_myOffersBtn layer] setBorderWidth:borderThickness];
//    [[_myOffersBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_myBookmarksBtn layer] setBorderWidth:borderThickness];
//    [[_myBookmarksBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_transactionHistoryBtn layer] setBorderWidth:borderThickness];
//    [[_transactionHistoryBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_inviteFriendsBtn layer] setBorderWidth:borderThickness];
//    [[_inviteFriendsBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_notificationsBtn layer] setBorderWidth:borderThickness];
//    [[_notificationsBtn layer] setBorderColor:[UIColor blackColor].CGColor];
//    [[_logOutBtn layer] setBorderWidth:borderThickness];
//    [[_logOutBtn layer] setBorderColor:[UIColor blackColor].CGColor];
    
    // Set border radius to buttons
//    _myProfileBtn.layer.cornerRadius = 5;
//    _myProfileBtn.clipsToBounds = YES;
//    _editLayoutBtn.layer.cornerRadius = 5;
//    _editLayoutBtn.clipsToBounds = YES;
//    _myProductsBtn.layer.cornerRadius = 5;
//    _myProductsBtn.clipsToBounds = YES;
//    _myOffersBtn.layer.cornerRadius = 5;
//    _myOffersBtn.clipsToBounds = YES;
//    _myBookmarksBtn.layer.cornerRadius = 5;
//    _myBookmarksBtn.clipsToBounds = YES;
//    _transactionHistoryBtn.layer.cornerRadius = 5;
//    _transactionHistoryBtn.clipsToBounds = YES;
//    _inviteFriendsBtn.layer.cornerRadius = 5;
//    _inviteFriendsBtn.clipsToBounds = YES;
//    _notificationsBtn.layer.cornerRadius = 5;
//    _notificationsBtn.clipsToBounds = YES;
//    _logOutBtn.layer.cornerRadius = 5;
//    _logOutBtn.clipsToBounds = YES;
    
    // Setup button event listener
    [_myProfileBtn addTarget:self action:@selector(MyProfileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_logOutBtn addTarget:self action:@selector(LogoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)MyProfileBtnClick:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Declare me view controller
//    MeViewController *meViewController = [[MeViewController alloc] init];
    // Push view controller into view
//    [meViewController set setWantsFullScreenLayout:NO];
//    [self  presentViewController:meViewController animated:YES completion:nil];
//    [[self.view window] setRootViewController:appDelegate.self.revealController];
//    [self.view.window addSubview:appDelegate.self.revealController.view];
//    self.view.window.rootViewController = appDelegate.revealController;
//    [appDelegate.self.revealController setFrontViewController:meViewController];
    [appDelegate.self.tabBarController setSelectedIndex:4];
    [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
}

-(void)LogoutBtnClick:(id)sender
{
//    // Clear user data from session
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//    // Push user back to login page
//    [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogout)];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];

    if([contentForThisRow isEqualToString:@"Edit Profile"]){
        NSLog(@"in edit profile button click");
        [appDelegate.self.tabBarController setSelectedIndex:4];

//        UpdateProfileViewController *updateProfileViewController = [[UpdateProfileViewController alloc] init];
        appDelegate.loadProfilePurpose = contentForThisRow;
//        [appDelegate.self.revealController showViewController:updateProfileViewController];
//        [appDelegate.self.revealController.frontViewController.navigationController pushViewController:updateProfileViewController animated:TRUE];
        [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
//        [self.revealController.navigationController pushViewController:updateProfileViewController animated:TRUE];
//        [appDelegate.self.revealController presentModalViewController:updateProfileViewController animated:TRUE];
    }else if([contentForThisRow isEqualToString:@"My Products"]){
        [appDelegate.self.tabBarController setSelectedIndex:4];
        appDelegate.loadProfilePurpose = contentForThisRow;
        [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
    }else if([contentForThisRow isEqualToString:@"Logout"]){
        // Clear user data from session
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        // Push user back to login page
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogout)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self sectionContents] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSInteger rows = [contents count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    static NSString *CellIdentifier = @"com.accountitem.cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:200];
    
    contentLabel.text = contentForThisRow;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    return key;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
