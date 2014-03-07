//
//  ExploreDetailViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 21/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(weak,nonatomic) NSString *categoryType;
@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
