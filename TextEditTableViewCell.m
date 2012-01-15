//
//  TextEditTableViewCell.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "TextEditTableViewCell.h"


@implementation TextEditTableViewCell

@synthesize valueTextField;
@synthesize nameLabel;
@synthesize isReadOnly;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		valueTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		isReadOnly = NO;
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:valueTextField];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 10);
	CGRect rect = baseRect;
	
	rect.size.width = 60;
	
	nameLabel.frame = rect;
	nameLabel.textAlignment = UITextAlignmentRight;
	nameLabel.font = [UIFont systemFontOfSize:12.0];
	nameLabel.textColor = [UIColor darkGrayColor];
	
	rect.size.width = baseRect.size.width - 70;
	rect.origin.x += 70;
	
	valueTextField.frame = rect;
	if(!isReadOnly)
	{
		valueTextField.enabled = YES;
		valueTextField.returnKeyType = UIReturnKeyDone;
		valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	else
	{
		valueTextField.enabled = NO;
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[valueTextField release];
	[nameLabel release];
	[super dealloc];
}


@end
