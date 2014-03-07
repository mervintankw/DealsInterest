//
//  HomeViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
//@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadProductIndicator;
@property (nonatomic) CGFloat cellWidth;
@property (weak, nonatomic) IBOutlet UIView *productView;

@property(weak,nonatomic) NSString *categoryType;

// For SBJson
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
// For SBJson

@end
