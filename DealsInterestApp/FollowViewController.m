//
//  FollowViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "FollowViewController.h"
#import "PKRevealController.h"
#import "FollowViewCell.h"

@interface FollowViewController () 

@end

@implementation FollowViewController {
    NSMutableArray *tableData;
    NSMutableArray *tableImageData;
    NSMutableArray *fStatusData;
    
    NSMutableArray *followingTableData;
    NSMutableArray *followingTableImageData;
    NSMutableArray *followingStatusData;
    
    NSMutableArray *followerTableData;
    NSMutableArray *followerTableImageData;
    NSMutableArray *followerStatusData;
}

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
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.revealController setMinimumWidth:280.0f maximumWidth:324.0f forViewController:self];
    
    self.title = @"Items";
    
    // Initialize table data
//    tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

    // Initialize table data
    tableData = [NSMutableArray arrayWithObjects:@"Steve Jobs", @"Tim Cook", nil];
    // Initialize table image data
    tableImageData = [NSMutableArray arrayWithObjects:@"steve_jobs_profile_pic.png", @"tim_cook_profile_pic.png", nil];
    // Initialize follow status data
    fStatusData = [NSMutableArray arrayWithObjects:@"1", @"1", nil];
    
    // Adjust color for segmented control
    _followControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIColor *newTintColor = [UIColor colorWithRed:.60 green:.60 blue:.60 alpha:1];
    _followControl.tintColor = newTintColor;
    UIColor *newSelectedTintColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:1];
    [[[_followControl subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
    
    // Adds action control for segmented control
    [_followControl addTarget:self action:@selector(segmentedControlSelectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
}

// Method triggered on segmented control change
- (void)segmentedControlSelectedIndexChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    //NSLog(@"%@",[segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]);
    
    // Clear array data
    [tableData removeAllObjects];
    [tableImageData removeAllObjects];
    [fStatusData removeAllObjects];
    
    // Checks for segmented control on click index
    if([[segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]] isEqual: @"Following"]){
        // Repopulate data
        tableData = [NSMutableArray arrayWithObjects:@"Steve Jobs", @"Tim Cook", nil];
        tableImageData = [NSMutableArray arrayWithObjects:@"steve_jobs_profile_pic.png", @"tim_cook_profile_pic.png", nil];
    
    }else if([[segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]] isEqual: @"Follower"]){
        // Repopulate data
        tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
        for (int i = 0; i < [tableData count]; i++){
            [tableImageData addObject:@"steve_jobs_profile_pic.png"];
        }
    }
    
    // Reload table data
    [_followDataTable reloadData];
}

-(void)followBtnPressed:(id)sender{
    NSLog(@"%@",[sender titleForState:(UIControlStateNormal)]);
    // Checks if button is unfollow then change to follow on click
    if([[sender titleForState:(UIControlStateNormal)] isEqual: @"Unfollow"]){
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
    // Reload table data
    //[_followDataTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Dealing with text
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.textColor = [UIColor lightGrayColor];
    
    // Dealing with thumb nail image
    NSString *imageName = [tableImageData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    // Convert thumb nail image to size 40 x 40
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    cell.imageView.image = [UIImage imageNamed:@"steve_jobs_profile_pic.png"];
    
    // Follow status
    //NSString *followStatus = [fStatusData objectAtIndex:indexPath.row];
    
    // Dealing with button
    // Creating Button For Check Order
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // Assign tag id for each button
    button.tag = indexPath.row;
    //set the position of the button
    button.frame = CGRectMake(50.0f, 5.0f, 65.0f, 30.0f);
//    if([followStatus isEqual: @"1"])
        [button setTitle:@"Unfollow" forState:UIControlStateNormal];
//    else if([followStatus isEqual: @"0"])
//        [button setTitle:@"Follow" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:self action:@selector(followBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"follow.png"]forState:UIControlStateNormal];
    button.backgroundColor= [UIColor clearColor];
//    [cell.contentView addSubview:button];
    cell.accessoryView = button;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [tableData removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

#pragma mark - Autorotation

/*
 * Please get familiar with iOS 6 new rotation handling as if you were to nest this controller within a UINavigationController,
 * the UINavigationController would _NOT_ relay rotation requests to his children on its own!
 */

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
