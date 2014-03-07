//
//  SelectItemPhotoViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 6/10/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "SelectItemPhotoViewController.h"
#import "AppDelegate.h"

@interface SelectItemPhotoViewController ()

@property BOOL newMedia;

@end

@implementation SelectItemPhotoViewController

UIImagePickerController *imagePicker;
NSMutableArray *postPhotoArray;

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
//        imagePicker = [[UIImagePickerController alloc] init];
//        //pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.delegate = self;
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        
//        // Displays a control that allows the user to choose picture or
//        // movie capture, if both are available:
//                imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        //pic.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        
//        // Hides the controls for moving & scaling pictures, or for
//        // trimming movies. To instead show the controls, use YES.
//        imagePicker.allowsEditing = NO;
//
        [self performSelector:@selector(useCamera:) withObject:nil afterDelay:0.3];
//
//        [self presentViewController:imagePicker animated:YES completion:nil];
    }

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    postPhotoArray = appDelegate.postItemPhoto;
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //    [[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    arr = [[NSUserDefaults standardUserDefaults]valueForKey:@"postItemPhotoArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [arr addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"%@",[info objectForKey:UIImagePickerControllerOriginalImage]);
    if(appDelegate.postItemPhotoCount == 0){
        appDelegate.photo1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else if(appDelegate.postItemPhotoCount == 1){
        appDelegate.photo2 = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else if(appDelegate.postItemPhotoCount == 2){
        appDelegate.photo3 = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else if(appDelegate.postItemPhotoCount == 3){
        appDelegate.photo4 = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else if(appDelegate.postItemPhotoCount == 4){
        appDelegate.photo5 = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    appDelegate.postItemPhotoCount = appDelegate.postItemPhotoCount + 1;
    [arr addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
//    NSLog(@"Image Array Count at selection: %d",[appDelegate.postItemPhoto count]);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker =
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
        imagePicker =
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
