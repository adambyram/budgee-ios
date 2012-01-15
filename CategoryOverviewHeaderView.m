//
//  CategoryOverviewHeaderView.m
//  Budgee
//
//  Created by Adam Byram on 8/24/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "CategoryOverviewHeaderView.h"


@implementation CategoryOverviewHeaderView

@synthesize amountRemainingLabel;
@synthesize amountBudgetedLabel;
@synthesize amountRemainingHeaderLabel;
@synthesize amountBudgetedHeaderLabel;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		amountBudgetedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountBudgetedLabel.backgroundColor = [UIColor clearColor];
		amountBudgetedLabel.font = [UIFont systemFontOfSize:22.0];
		amountBudgetedLabel.textColor = [UIColor whiteColor];
		amountBudgetedLabel.textAlignment = UITextAlignmentCenter;
		
		amountRemainingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountRemainingLabel.backgroundColor = [UIColor clearColor];
		amountRemainingLabel.font = [UIFont systemFontOfSize:22.0];
		//amountRemainingLabel.textColor = [UIColor whiteColor];
		amountRemainingLabel.textAlignment = UITextAlignmentCenter;
		amountRemainingLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
		
		amountBudgetedHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountBudgetedHeaderLabel.backgroundColor = [UIColor clearColor];
		amountBudgetedHeaderLabel.font = [UIFont systemFontOfSize:15.0];
		amountBudgetedHeaderLabel.textColor = [UIColor lightGrayColor];
				amountBudgetedHeaderLabel.textAlignment = UITextAlignmentCenter;
		[amountBudgetedHeaderLabel setText:@"Budgeted"];
		
		amountRemainingHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountRemainingHeaderLabel.backgroundColor = [UIColor clearColor];
		amountRemainingHeaderLabel.font = [UIFont systemFontOfSize:15.0];
		amountRemainingHeaderLabel.textColor = [UIColor lightGrayColor];
				amountRemainingHeaderLabel.textAlignment = UITextAlignmentCenter;
		[amountRemainingHeaderLabel setText:@"Remaining"];

		backgroundImage = [UIImage imageNamed:@"HeaderBackgroundGradient.png"];
		
		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		[self addSubview:backgroundImageView];
		[self addSubview:amountBudgetedLabel];
		[self addSubview:amountRemainingLabel];
		[self addSubview:amountBudgetedHeaderLabel];
		[self addSubview:amountRemainingHeaderLabel];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}

-(void)layoutSubviews
{
	//testLabel.frame = self.frame;
	CGRect budgetRect = self.frame;
	budgetRect.size.width =  self.frame.size.width/2.0;
	budgetRect.size.height = self.frame.size.height*(2.0/3.0);
	budgetRect.origin.y = self.frame.size.height - budgetRect.size.height;
	amountBudgetedLabel.frame = budgetRect;
	
	CGRect budgetHeaderRect = self.frame;
	budgetHeaderRect.size.height = self.frame.size.height - budgetRect.size.height;
		budgetHeaderRect.size.width =  self.frame.size.width/2.0;
	budgetHeaderRect.origin.y = 2;
	amountBudgetedHeaderLabel.frame = budgetHeaderRect;
	
	CGRect remainingRect = self.frame;
	remainingRect.origin.x = self.frame.size.width/2.0;
	remainingRect.size.height = self.frame.size.height*(2.0/3.0);
	remainingRect.origin.y = self.frame.size.height - remainingRect.size.height;
	remainingRect.size.width =  self.frame.size.width/2.0;
	amountRemainingLabel.frame = remainingRect;
	
	CGRect remainingHeaderRect = self.frame;
	remainingHeaderRect.size.height = self.frame.size.height - remainingRect.size.height;
		remainingHeaderRect.size.width =  self.frame.size.width/2.0;
	remainingHeaderRect.origin.x = self.frame.size.width/2.0;
	remainingHeaderRect.origin.y = 2;
	amountRemainingHeaderLabel.frame = remainingHeaderRect;
}


- (void)dealloc {
	[amountBudgetedLabel release];
	[amountRemainingLabel release];
	[amountBudgetedHeaderLabel release];
	[amountRemainingHeaderLabel release];
	[super dealloc];
}


@end
