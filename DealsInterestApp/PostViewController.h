//
//  PostViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)LoadView;

@end
