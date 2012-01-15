//
//  BudgetOverviewController.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Budget.h"
@class BudgetOverviewHeaderView;

@interface BudgetOverviewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate> {
	Budget* budget;
	NSArray* categories;
	UIToolbar* toolbar;
	BudgetOverviewHeaderView* headerView;
	UITableView* tableView;
	UIAlertView* alertView;
	UIActionSheet* actionSheet;
}

@property (retain,nonatomic) Budget* budget;
@property (retain, nonatomic) UITableView* tableView;

-(void)reloadCategories;
-(void)newTransaction:(id)sender;
-(void)toolbarAction:(id)sender;
-(void) updateHeaderDisplay;
-(void)resetBudget:(id)sender;
-(void)exportCsvDataToEmail;

@end
