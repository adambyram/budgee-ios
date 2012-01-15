//
//  CategoryOverviewController.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BudgetCategory,CategoryOverviewHeaderView,Budget,TransactionDetailViewController;

@interface CategoryOverviewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	BudgetCategory* category;
	NSArray* transactions;
	UITableView* tableView;
	CategoryOverviewHeaderView* headerView;
	UIToolbar* toolbar;
	TransactionDetailViewController* tdc;
}

@property (retain, nonatomic) BudgetCategory* category;
@property (retain, nonatomic) UITableView* tableView;
@property (retain, nonatomic) CategoryOverviewHeaderView* headerView;

-(void)reloadTransactions;
-(void)newTransaction:(id)sender;
-(void)toolbarAction:(id)sender;
-(void)updateDisplayData;

@end
