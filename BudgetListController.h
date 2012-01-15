//
//  BudgetListController.h
//  Budgee
//
//  Created by Adam Byram on 3/2/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Budget;
@interface BudgetListController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate> {
	NSArray* budgets;
	Budget* selectedBudget;
}

@end
