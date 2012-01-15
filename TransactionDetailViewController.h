//
//  TransactionDetailViewController.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BudgetTransaction;
@class TextEditTableViewCell;

@interface TransactionDetailViewController : UITableViewController <UITextFieldDelegate> {
	BudgetTransaction* transaction;
	NSMutableArray* controls;
	TextEditTableViewCell* selectedCell;
	UIDatePicker* datePicker;
	BOOL viewHasBeenScrolled;
	UIAlertView* deleteTransactionAlertView;
}

@property (retain, nonatomic) BudgetTransaction* transaction;
@property (retain, nonatomic) UIAlertView* deleteTransactionAlertView;
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
-(void)datePickerChanged:(id)sender;
-(void)returnToParent:(id)sender;
-(void)saveTransaction:(id)sender;
@end
