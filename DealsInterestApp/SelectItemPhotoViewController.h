//
//  SelectItemPhotoViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 6/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectItemPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
