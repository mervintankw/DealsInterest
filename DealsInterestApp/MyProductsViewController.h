//
//  MyProductsViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 13/1/14.
//  Copyright (c) 2014 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProductsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

- (void)LoadView;

@end
