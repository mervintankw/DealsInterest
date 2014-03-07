//
//  PostItem1ViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "PostItem1ViewController.h"
#import "PostItem2ViewController.h"

@interface PostItem1ViewController ()

@end

@implementation PostItem1ViewController

NSString *inTitle;
NSString *inPrice;
NSString *inDescription;

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
    
    CGRect frame = CGRectMake(0, 0, 170, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Post Item (2/3)";
    
    // Add post button
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(PostClick:)];
    self.navigationItem.rightBarButtonItem = done;
    
    inTitle = self.titleTextBox;
    inPrice = self.priceTextBox;
    inDescription = self.descriptionTextBox;
    
}

-(void)PostClick:(UIButton *)sender
{
    // Declare post item 1 view controller
    PostItem2ViewController *postItem2ViewController = [[PostItem2ViewController alloc] init];
    // Validate inputs
    if([_emailTextBox.text isEqual:@""] || [_handphoneTextBox.text isEqual:@""] || [_contactNameTextBox.text isEqual:@""] || [_locationAddressTextBox.text isEqual:@""])
    {
        // Create alert message
        UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Post Item"
                                                             message:@"Please enter all fields!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        // Display alert message
        [postFailed show];
    }
    else
    {
        // Pass existing data to next controller
        postItem2ViewController.categoryType = _categoryType;
        postItem2ViewController.titleTextBox = inTitle;
        postItem2ViewController.priceTextBox = inPrice;
        postItem2ViewController.descriptionTextBox = inDescription;
        postItem2ViewController.emailTextBox = _emailTextBox.text;
        postItem2ViewController.handphoneTextBox = _handphoneTextBox.text;
        postItem2ViewController.contactNameTextBox = _contactNameTextBox.text;
        postItem2ViewController.locationAddressTextBox = _locationAddressTextBox.text;
        // Push view controller into view
        [self.navigationController pushViewController:postItem2ViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
