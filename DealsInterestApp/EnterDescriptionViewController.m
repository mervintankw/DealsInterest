//
//  EnterDescriptionViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 4/11/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "EnterDescriptionViewController.h"
#import "AppDelegate.h"

@interface EnterDescriptionViewController ()

@end

@implementation EnterDescriptionViewController

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
    CGRect frame = CGRectMake(0, 0, 170, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Description";
    
    //To make the border look very close to a UITextField
    [_descriptionTextBox.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
    [_descriptionTextBox.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    _descriptionTextBox.layer.cornerRadius = 5;
    _descriptionTextBox.clipsToBounds = YES;
    
    _descriptionTextBox.contentInset = UIEdgeInsetsMake(-70.0,0.0,0,0.0);
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![appDelegate.uploadDescription isEqualToString:@""]){
        _descriptionTextBox.text = appDelegate.uploadDescription;
    }
    
    // Add post button
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(PostClick:)];
    self.navigationItem.rightBarButtonItem = done;
}

-(void)PostClick:(UIButton *)sender
{
    // Validates title text box input for empty input
    if([_descriptionTextBox.text isEqualToString:@""]){
        // Create alert message
        UIAlertView *postFailed = [[UIAlertView alloc] initWithTitle:@"Enter Description"
                                                             message:@"Description cannot be blank!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        // Display alert message
        [postFailed show];
        // Else redirect user back to post item view
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.uploadDescription = _descriptionTextBox.text;
        [[self navigationController] popViewControllerAnimated:TRUE];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
