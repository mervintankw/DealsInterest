//
//  PostViewController.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 1/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "PostViewController.h"
#import "PostItemViewController.h"

@interface PostViewController()

@property (nonatomic, strong) NSArray *catArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation PostViewController

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
    [self LoadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self LoadView];
}

- (void)LoadView
{
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Post";
    
//    // Camera function
//    if ((![UIImagePickerController isSourceTypeAvailable:
//           UIImagePickerControllerSourceTypeCamera] == NO)){
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                              message:@"Device has no camera"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles: nil];
//        [myAlertView show];
//    }else{
//        pic = [[UIImagePickerController alloc] init];
//        pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        pic.delegate = self;
//        //[pic setSourceType:UIImagePickerControllerSourceTypeCamera];
//        
//        // Displays a control that allows the user to choose picture or
//        // movie capture, if both are available:
//        //        pic.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        pic.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        
//        // Hides the controls for moving & scaling pictures, or for
//        // trimming movies. To instead show the controls, use YES.
//        pic.allowsEditing = NO;
//        
//        [self presentViewController:pic animated:YES completion:nil];
//    }
    
    //    int colCount = 0;
    //    int rowCount = 0;
    // Populate array with categories
    _catArray = [NSArray arrayWithObjects:@"Books",@"Fashion",@"Beauty",
                 @"Furnitures",@"Digital",@"Household",
                 @"Outdoors",@"Services",@"Others",nil];
    //    // Dynamically generate buttons for each category
    //    for(int i=0; i<catArray.count; i++){
    //        if(colCount == 3){
    //            rowCount++;
    //            colCount = 0;
    //        }
    //        NSString *categoryName = [catArray objectAtIndex:i];
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        //    [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    //        //        [button setTitle:categoryName forState:UIControlStateNormal];
    //        //        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //        //        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    //        //        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        //        button.titleLabel.font = [UIFont systemFontOfSize:12];
    //        //        CALayer *layer = button.layer;
    //        //        layer.cornerRadius = 8.0f;
    //        //        layer.masksToBounds = YES;
    //        //        layer.borderWidth = 1.0f;
    //        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",categoryName]]forState:UIControlStateNormal];
    //        button.frame = CGRectMake(((colCount*106)+7.0), ((rowCount*108)+83.0), 99, 90);
    //        [self.view addSubview:button];
    //
    //        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(((colCount*105)+20), ((rowCount*108)+172), 70, 15)];
    //        label.text = categoryName;
    //        label.font = [UIFont systemFontOfSize:10];
    //        label.textAlignment = NSTextAlignmentCenter;
    //        [self.view addSubview:label];
    //
    //        colCount++;
    //    }
    
    // Populate array with categories
    _catArray = [NSArray arrayWithObjects:@"Books",@"Fashion",@"Beauty",
                 @"Furnitures",@"Digital",@"Household",
                 @"Outdoors",@"Services",@"Others",nil];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *imageSection = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_catArray.count; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"%@", [_catArray objectAtIndex:i]]];
        [imageSection addObject:[NSString stringWithFormat:@"%@.png", [_catArray objectAtIndex:i]]];
    }
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    self.imageArray = [[NSArray alloc] initWithObjects:imageSection, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCatCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"com.catview.cell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(105, 105)];
    [flowLayout setMinimumInteritemSpacing:0.2];
    [flowLayout setMinimumLineSpacing:9.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

/*
 Initial category collectionView
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    //    return [sectionArray count];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    NSMutableArray *imageData = [self.imageArray objectAtIndex:indexPath.section];
    
    //    NSLog(@"%d %d",indexPath.row,data.count);
    
    NSString *cellData = [data objectAtIndex:indexPath.row];
    NSString *cellImageData = [imageData objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"com.catview.cell";
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    UIButton *catButton = (UIButton *)[cell viewWithTag:9999];
    
    [catButton setTitle:cellData forState:UIControlStateNormal];
    [catButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    // Populate button image
    [catButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",cellImageData]] forState:UIControlStateNormal];
    // Assign button action method to button
    [catButton addTarget:self action:@selector(catDetailAction:) forControlEvents:UIControlEventTouchDown];
    // Assign new button tag according to index of catArray
    //    for(int i=0; i<_catArray.count; i++){
    //        if([cellData isEqual:[_catArray objectAtIndex:i]]){
    //            catButton.tag = i;
    //        }
    //    }
    //    catButton.tag = indexPath.row;
    //    catButton.tag = indexPath.row;
    
    //    NSLog(@"%@ %d",cellData,indexPath.row);
    
    // Populate product title label
    titleLabel.text = cellData;
    
    return cell;
}
/*
 Initial category collectionView
 */

-(void)catDetailAction:(UIButton *)sender {
    //    NSLog(@"Clicked! %@",sender.currentTitle);
    for(int i=0; i<_catArray.count; i++){
        if([sender.currentTitle isEqual:[_catArray objectAtIndex:i]]){
//            NSLog(@"From clicking on category button: %@! :D",[_catArray objectAtIndex:i]);
            // Declare post item view controller
            PostItemViewController *postItemViewController = [[PostItemViewController alloc] init];
            // Set category selected into post item view controller variable
            postItemViewController.categoryType = [_catArray objectAtIndex:i];
            // Push view controller into view
            [self.navigationController pushViewController:postItemViewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
