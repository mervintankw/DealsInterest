//
//  SelectProfilePicViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 25/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "SelectProfilePicViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface SelectProfilePicViewController ()

@property BOOL newMedia;

@end

@implementation SelectProfilePicViewController

UIImagePickerController *pic;

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
    
    // Camera function
    if (([UIImagePickerController isSourceTypeAvailable:
           UIImagePickerControllerSourceTypeCamera] == NO)){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }else{
        pic = [[UIImagePickerController alloc] init];
        //pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pic.delegate = self;
        [pic setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // Displays a control that allows the user to choose picture or
        // movie capture, if both are available:
                pic.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //pic.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        pic.allowsEditing = NO;
        
        [self presentViewController:pic animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:NO completion:nil];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
//    [[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
//    registerViewController.registerProfilePic = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.registerProfilePic = [info objectForKey:UIImagePickerControllerOriginalImage];
//    appDelegate.regiserProfilePicData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 1) ;
//    NSLog(@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
    [self.navigationController popViewControllerAnimated:YES];
//    [Picker release];
    
}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}

- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
