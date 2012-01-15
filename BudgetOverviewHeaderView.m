//
//  BudgetOverviewHeaderView.m
//  Budgee
//
//  Created by Adam Byram on 8/24/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "BudgetOverviewHeaderView.h"


@implementation BudgetOverviewHeaderView

@synthesize amountLabel;
@synthesize messageLabel;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		amountLabel.textAlignment = UITextAlignmentCenter;
		amountLabel.font = [UIFont systemFontOfSize:38.0];
		// Dark Green
		
		//amountLabel.shadowColor = [UIColor darkGrayColor];
		amountLabel.backgroundColor = [UIColor clearColor];
		messageLabel.textAlignment = UITextAlignmentCenter;
		messageLabel.backgroundColor = [UIColor clearColor];
		messageLabel.textColor = [UIColor lightGrayColor];
		messageLabel.font = [UIFont systemFontOfSize:14.0];
		backgroundImage = [UIImage imageNamed:@"HeaderBackgroundGradient.png"];
		
		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		[self addSubview:backgroundImageView];
		[self addSubview:amountLabel];
		[self addSubview:messageLabel];

		
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}

-(void)layoutSubviews
{
	CGRect baseFrame = [self frame];
	
	//backgroundImageView.frame = baseFrame;
	CGRect rect = baseFrame;
		
	//rect = baseFrame;
	
	rect.origin.y = 3;
	
	rect.size.height = (baseFrame.size.height * (1.0/3.0))-3;
	messageLabel.frame = rect;
	
	
	// Amount Label is 2/3 of frame high
	CGFloat amountLabelHeight = (int)(baseFrame.size.height * (2.0/3.0));
	rect.origin.y =(baseFrame.size.height * (1.0/3.0))+3;
	rect.size.height = amountLabelHeight-5-3;
	amountLabel.frame = rect;
	
	
		
	
}

- (void)dealloc {
	
	[backgroundImage release];
	[backgroundImageView release];
	[amountLabel release];
	[messageLabel release];
	[super dealloc];
}


@end
