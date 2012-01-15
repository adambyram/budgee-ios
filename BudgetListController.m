//
//  BudgetListController.m
//  Budgee
//
//  Created by Adam Byram on 3/2/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import "BudgetListController.h"
#import "Budget.h"
#import "BudgetOverviewController.h"
#import "BudgeeAppDelegate.h"
#import "BudgeeWebController.h"
#import "BudgetDetailViewController.h"

@implementation BudgetListController

-(id)init
{
	if(self = [super init])
	{
		selectedBudget = nil;
		//budgets = [[Budget loadAllBudgets] retain];
		self.view = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
		[self.view setDataSource:self];
		[self.view setDelegate:self];
		[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[[self navigationItem] setTitle:@"Budgets"];

		UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Budgee Web" style:UIBarButtonItemStyleBordered target:self action:@selector(activateBudgeeWeb:)];
		[[self navigationItem] setLeftBarButtonItem:bbi];
		[bbi release];
		
		bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newBudget:)];
		[[self navigationItem] setRightBarButtonItem:bbi];
		[bbi release];
		
	}
	return self;
}

NSInteger budgetListSort(id b1, id b2, void *context)
{
	return [[b1 name] caseInsensitiveCompare:[b2 name]];
}

-(void)newBudget:(id)sender
{
	Budget* b = [[Budget alloc] init];
	BudgetDetailViewController* controller = [[BudgetDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[controller setBudget:b];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[b release];
}

-(void)activateBudgeeWeb:(id)sender
{
	BudgeeWebController* bwc = [[BudgeeWebController alloc] init];
	[self.navigationController pushViewController:bwc animated:YES];
	[bwc release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [budgets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString* tableViewCellIdentifier = @"BudgetTableViewCell";
	
	//static NSString *MyIdentifier = @"MyIdentifier";
	
	/*
	 static NSString *MyIdentifier = @"MyIdentifier";
	 
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	 if (cell == nil) {
	 cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	 }
	 */
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableViewCellIdentifier] autorelease];
	}
	
	[cell setText:[[budgets objectAtIndex:[indexPath row]] name]];
	
	//CategorySummaryTableViewCell* cell = [[[CategorySummaryTableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	/*
	 CategorySummaryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
	 if(cell == nil)
	 {
	 cell = [[[CategorySummaryTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableViewCellIdentifier] autorelease];
	 }
	 */
	/*
	// Configure the cell
	BudgetCategory* category = [[categories objectAtIndex:[indexPath row]] retain];
	NSString* categoryName = [[category name] retain];
	NSString* categoryAmountRemaining = [[TCDataConverter convertCurrencyToString:[category totalAmountRemaining] withSymbol:YES] retain];
	NSString* budgetedAmount = [[TCDataConverter convertCurrencyToString:[category budgetedAmount] withSymbol:YES] retain];
	//NSString* cellText = [[NSString stringWithFormat:@"%@ (%@ remaining)",  categoryName, categoryAmountRemaining] retain];
	//[cell setText:cellText];
	[cell.categoryNameLabel setText:categoryName];
	[cell.budgetedAmountLabel setText:budgetedAmount];
	[cell.amountRemainingLabel setText:categoryAmountRemaining];
	
	if([[category totalAmountRemaining] doubleValue] >= 0){
		cell.amountRemainingLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
		
	}
	else
	{
		cell.amountRemainingLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0];
		
	}
	[categoryAmountRemaining release];
	[categoryName release];
	[budgetedAmount release];
	//[cellText release];
	[category release];
	*/
	/*if([indexPath row] % 2 == 0)
	{
		UIView* backgroundView = [[UIView alloc] init];
		backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.backgroundView = backgroundView;
		[backgroundView release];
		cell.contentView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.accessoryView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.opaque = YES;
		cell.accessoryView.opaque = YES;
		cell.backgroundView.backgroundColor =[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	}
	else
	{
		UIView* backgroundView = [[UIView alloc] init];
		backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.backgroundView = backgroundView;
		[backgroundView release];
		cell.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		cell.accessoryView.backgroundColor =  [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		cell.accessoryView.opaque = YES;
		cell.opaque = YES;
		cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		
		cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
	} 
	*/ 
	return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	return UITableViewCellAccessoryDisclosureIndicator;
}

NSInteger budgetSort(id b1, id b2, void *context)
{
	return [[b1 name] caseInsensitiveCompare:[b2 name]];
}

-(void)dealloc
{
	[super dealloc];
}

-(void)reloadBudgets
{
	[budgets release];
	budgets = [[[Budget loadAllBudgets] sortedArrayUsingFunction:budgetSort context:NULL] retain];
	[self.view reloadData];
	
}

- (void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	[self reloadBudgets];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self.view deselectRowAtIndexPath:[self.view indexPathForSelectedRow] animated:YES];
	

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BudgetOverviewController* boc = [[BudgetOverviewController alloc] init];
	[boc setBudget:[budgets objectAtIndex:[indexPath row]]];
	
	[[[UIApplication sharedApplication] delegate] setSelectedBudget:[budgets objectAtIndex:[indexPath row]]];
	
	//CategoryOverviewController* controller = [[CategoryOverviewController alloc] init];
	//[controller setCategory:[categories objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:boc animated:YES];
	[boc release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[budgets objectAtIndex:[indexPath row]] deleteBudget];
		
		NSMutableArray* mutableArray = [budgets mutableCopy];
		[mutableArray removeObjectAtIndex:[indexPath row]];
		[budgets release];
		budgets = mutableArray;
		
		//[self updateHeaderDisplay];
		
		
		[self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//	[self updateHeaderDisplay];
		//[self reloadCategories];
	/*	if([categories count] > 0)
		{
			self.navigationItem.rightBarButtonItem.enabled = YES;	
		}
		else
		{
			self.navigationItem.rightBarButtonItem.enabled = NO;	
		}
		[self reloadCategories];
	*/
	 }
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
	
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


@end
