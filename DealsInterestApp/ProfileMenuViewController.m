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

- (void)viewDidAppear:(BOOL)animated
{
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
    
    // Setup button event listener
    [_myProfileBtn addTarget:self action:@selector(MyProfileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_logOutBtn addTarget:self action:@selector(LogoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        [appDelegate.self.tabBarController setSelectedIndex:1];
        [appDelegate.self.tabBarController setSelectedIndex:4];
        appDelegate.loadProfilePurpose = contentForThisRow;
        [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
    }else if([contentForThisRow isEqualToString:@"My Products"]){
        [appDelegate.self.tabBarController setSelectedIndex:1];
        [appDelegate.self.tabBarController setSelectedIndex:4];
        appDelegate.loadProfilePurpose = contentForThisRow;
        [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
    }else if([contentForThisRow isEqualToString:@"My Bookmarks"]){
        [appDelegate.self.tabBarController setSelectedIndex:1];
        [appDelegate.self.tabBarController setSelectedIndex:4];
        appDelegate.loadProfilePurpose = contentForThisRow;
        [appDelegate.self.revealController showViewController:appDelegate.self.revealController.frontViewController];
    }else if([contentForThisRow isEqualToString:@"Logout"]){
        // Clear user data from session
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        // Push user back to login page
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(userDidLogout)];
    }else{
        appDelegate.loadProfilePurpose = @"";
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
