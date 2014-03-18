//
//  MyBookmarksViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 7/3/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookmarksViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

- (void)LoadView;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
