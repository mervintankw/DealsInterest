//
//  FollowViewCell.h
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 2/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UIButton *unfollowBtn;

@end
