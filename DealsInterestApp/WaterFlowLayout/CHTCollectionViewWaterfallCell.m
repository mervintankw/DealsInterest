//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@interface CHTCollectionViewWaterfallCell ()
@end

@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
	if (!_displayLabel) {
		_displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
		_displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_displayLabel.backgroundColor = [UIColor whiteColor];
		_displayLabel.textColor = [UIColor blackColor];
		_displayLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
	if (![_displayString isEqualToString:displayString]) {
		_displayString = [displayString copy];
		self.displayLabel.text = _displayString;
	}
}

#pragma mark - Life Cycle
- (void)dealloc {
	[_displayLabel removeFromSuperview];
	_displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		[self.contentView addSubview:self.displayLabel];
	}
	return self;
}

@end
