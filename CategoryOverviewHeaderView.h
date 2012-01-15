//
//  CategoryOverviewHeaderView.h
//  Budgee
//
//  Created by Adam Byram on 8/24/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryOverviewHeaderView : UIView {
	UILabel* amountBudgetedLabel;
	UILabel* amountRemainingLabel;
	UILabel* amountBudgetedHeaderLabel;
	UILabel* amountRemainingHeaderLabel;
	UIImageView* backgroundImageView;
	UIImage* backgroundImage;
}

@property (retain, nonatomic) UILabel* amountBudgetedLabel;
@property (retain, nonatomic) UILabel* amountRemainingLabel;
@property (retain, nonatomic) UILabel* amountBudgetedHeaderLabel;
@property (retain, nonatomic) UILabel* amountRemainingHeaderLabel;


@end
