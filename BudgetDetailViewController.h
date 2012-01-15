//
//  BudgetDetailViewController.h
//  Budgee
//
//  Created by Adam Byram on 3/3/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Budget;

@interface BudgetDetailViewController: UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	Budget* budget;
	NSMutableArray* controls;
	UIAlertView* deleteBudgetAlertView;
}

@property (retain, nonatomic) Budget* budget;
@property (retain, nonatomic) UIAlertView* deleteBudgetAlertView;
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
-(void)returnToParent:(id)sender;
-(void)saveBudget:(id)sender;

@end
