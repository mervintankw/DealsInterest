//
//  SelectProfilePicViewController.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 25/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProfilePicViewController : UIViewController <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectLibraryBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectCameraBtn;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
