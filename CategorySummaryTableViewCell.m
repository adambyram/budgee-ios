//
//  CategorySummaryTableViewCell.m
//  Budgee
//
//  Created by Adam Byram on 9/7/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "CategorySummaryTableViewCell.h"


@implementation CategorySummaryTableViewCell

@synthesize categoryNameLabel;
@synthesize budgetedAmountLabel;
@synthesize amountRemainingLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		categoryNameLabel.font = [UIFont systemFontOfSize:16.0];
		categoryNameLabel.backgroundColor = [UIColor clearColor];
		budgetedAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		budgetedAmountLabel.font = [UIFont systemFontOfSize:14.0];
		budgetedAmountLabel.backgroundColor = [UIColor clearColor];
		budgetedAmountLabel.textColor = [UIColor grayColor];
		amountRemainingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountRemainingLabel.textAlignment = UITextAlignmentRight;
		amountRemainingLabel.backgroundColor = [UIColor clearColor];
		//self.userInteractionEnabled = YES;
		[self.contentView addSubview:categoryNameLabel];
		[self.contentView addSubview:budgetedAmountLabel];
		[self.contentView addSubview:amountRemainingLabel];
	}
	return self;
}

-(void)layoutSubviews
{
		[super layoutSubviews];
	CGRect categoryNameRect;
	categoryNameRect.origin.x = self.contentView.frame.origin.x + 10;
	categoryNameRect.origin.y = 2;
	categoryNameRect.size.width = 195;
	categoryNameRect.size.height = self.contentView.frame.size.height*(.5)-2;
	categoryNameLabel.frame = categoryNameRect;
	
	CGRect budgetedAmountRect;
	budgetedAmountRect.origin.x = self.contentView.frame.origin.x + 10;
	budgetedAmountRect.origin.y = self.contentView.frame.size.height*(0.5)-1;
	budgetedAmountRect.size.width = 195;
	budgetedAmountRect.size.height = self.contentView.frame.size.height*(0.5)-2;
	budgetedAmountLabel.frame = budgetedAmountRect;
	
	CGRect amountRemainingRect;
	amountRemainingRect.origin.x = 198;
	//amountRemainingRect.origin.x = self.contentView.bounds;
	amountRemainingRect.origin.y = 0;
	
	//amountRemainingRect.size.width = 84;
	//amountRemainingRect.size.width = self.contentView.bounds.size.width - 216 - 13 - self.accessoryView.bounds.size.width;
	amountRemainingRect.size.width = self.contentView.bounds.size.width - 198 - 5;
	amountRemainingRect.size.height = self.contentView.frame.size.height;
	amountRemainingLabel.frame = amountRemainingRect;

	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[categoryNameLabel release];
	[budgetedAmountLabel release];
	[amountRemainingLabel release];
	[super dealloc];
}


@end
