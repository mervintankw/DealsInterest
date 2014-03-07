//
//  SelectCategoryViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 4/11/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
