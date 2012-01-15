//
//  TransactionSummaryTableViewCell.h
//  Budgee
//
//  Created by Adam Byram on 9/7/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TransactionSummaryTableViewCell : UITableViewCell {
	UILabel* noteLabel;
	UILabel* dateLabel;
	UILabel* amountLabel;
}

@property (retain, nonatomic) UILabel* noteLabel;
@property (retain, nonatomic) UILabel* dateLabel;
@property (retain, nonatomic) UILabel* amountLabel;


@end
