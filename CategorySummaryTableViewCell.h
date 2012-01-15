//
//  CategorySummaryTableViewCell.h
//  Budgee
//
//  Created by Adam Byram on 9/7/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategorySummaryTableViewCell : UITableViewCell {
	UILabel* categoryNameLabel;
	UILabel* budgetedAmountLabel;
	UILabel* amountRemainingLabel;
}

@property (retain, nonatomic) UILabel* categoryNameLabel;
@property (retain, nonatomic) UILabel* budgetedAmountLabel;
@property (retain, nonatomic) UILabel* amountRemainingLabel;

@end
