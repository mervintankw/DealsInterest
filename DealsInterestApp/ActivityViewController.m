//
//  ActivityViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 2/3/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import "ActivityViewController.h"
#import "SearchViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

NSString *activityToggle;

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

- (void)viewDidAppear:(BOOL)animated
{
    [self LoadView];
}

-(void)LoadView
{
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Activity";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(triggerSearch)];
}

-(void)triggerSearch
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    // Push view controller into view
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
