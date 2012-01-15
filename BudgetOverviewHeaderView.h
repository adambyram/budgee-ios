//
//  BudgetOverviewHeaderView.h
//  Budgee
//
//  Created by Adam Byram on 8/24/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BudgetOverviewHeaderView : UIView {
	UILabel* amountLabel;
	UILabel* messageLabel;
	UIImage* backgroundImage;
	UIImageView* backgroundImageView;
}

@property (retain, nonatomic) UILabel* amountLabel;
@property (retain, nonatomic) UILabel* messageLabel;

@end
