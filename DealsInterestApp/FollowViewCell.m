//
//  FollowViewCell.m
//  DealsInterestApp
//
//  Created by Mervin Tan Kok Wei on 2/9/13.
//  Copyright (c) 2013 com.dealsinterest. All rights reserved.
//

#import "FollowViewCell.h"

@interface FollowViewCell ()

@end

@implementation FollowViewCell

@synthesize nameLabel = _nameLabel;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize unfollowBtn = _unfollowBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
