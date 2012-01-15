//
//  TransactionSummaryTableViewCell.m
//  Budgee
//
//  Created by Adam Byram on 9/7/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "TransactionSummaryTableViewCell.h"


@implementation TransactionSummaryTableViewCell

@synthesize noteLabel;
@synthesize dateLabel;
@synthesize amountLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		noteLabel.font = [UIFont systemFontOfSize:16.0];
		noteLabel.backgroundColor = [UIColor clearColor];
		dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dateLabel.font = [UIFont systemFontOfSize:14.0];
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.backgroundColor = [UIColor clearColor];
		amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountLabel.textAlignment = UITextAlignmentRight;
		amountLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:noteLabel];
		[self.contentView addSubview:dateLabel];
		[self.contentView addSubview:amountLabel];
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

-(void)layoutSubviews
{
		[super layoutSubviews];
	CGRect categoryNameRect;
	categoryNameRect.origin.x = self.contentView.frame.origin.x + 10;
	categoryNameRect.origin.y = 2;
	categoryNameRect.size.width = 195;
	categoryNameRect.size.height = self.contentView.frame.size.height*(.5)-2;
	noteLabel.frame = categoryNameRect;
	
	CGRect budgetedAmountRect;
	budgetedAmountRect.origin.x = self.contentView.frame.origin.x + 10;
	budgetedAmountRect.origin.y = self.contentView.frame.size.height*(0.5)-1;
	budgetedAmountRect.size.width = 195;
	budgetedAmountRect.size.height = self.contentView.frame.size.height*(.5)-2;
	dateLabel.frame = budgetedAmountRect;
	
	CGRect amountRemainingRect;
	amountRemainingRect.origin.x = 198;
	amountRemainingRect.origin.y = 0;
	
	//amountRemainingRect.size.width = 84;
	amountRemainingRect.size.width = self.contentView.bounds.size.width - 198 - 5;
	amountRemainingRect.size.height = self.contentView.frame.size.height;
	amountLabel.frame = amountRemainingRect;

}


- (void)dealloc {
	[noteLabel release];
	[dateLabel release];
	[amountLabel release];
	[super dealloc];
}


@end
