//
//  CategoryDetailViewController.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetCategory;

@interface CategoryDetailViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	BudgetCategory* category;
	NSMutableArray* controls;
	UIAlertView* deleteCategoryAlertView;
}

@property (retain, nonatomic) BudgetCategory* category;
@property (retain, nonatomic) UIAlertView* deleteCategoryAlertView;
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
-(void)returnToParent:(id)sender;
-(void)saveCategory:(id)sender;

@end
