//
//  SelectCategoryViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 4/11/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "AppDelegate.h"

@interface SelectCategoryViewController ()

@end

NSMutableArray *categoryList;

@implementation SelectCategoryViewController

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
    categoryList = [[NSMutableArray alloc] initWithObjects:@"Books",@"Fashion",@"Beauty",@"Furnitures",@"Digital",
                    @"Household",@"Outdoors",@"Services",@"Others", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    for(NSString *cat in categoryList){
//        if([appDelegate.uploadCategory isEqualToString:cat]){
//            [_tableView select:cat];
//        }
//    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSString *categoryName = [categoryList objectAtIndex: [indexPath row]];
    cell.textLabel.text = categoryName;
    
    return cell;
}

// Table row on select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.uploadCategory = [categoryList objectAtIndex: [indexPath row]];
    [[self navigationController] popViewControllerAnimated:TRUE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
