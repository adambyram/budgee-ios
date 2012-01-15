//
//  CategoryOverviewController.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "CategoryOverviewController.h"
#import "Category.h"
#import "Transaction.h"
#import "TransactionDetailViewController.h"
#import "CategoryOverviewHeaderView.h"
#import "CategoryDetailViewController.h"
#import "TCDataConverter.h"
#import "TransactionSummaryTableViewCell.h"


@implementation CategoryOverviewController

@synthesize category;
@synthesize tableView;
@synthesize headerView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}
 */

-(void)toolbarAction:(id)sender
{
	if([sender tag] == 1)
	{
		CategoryDetailViewController* controller = [[CategoryDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[controller setCategory:[self category]];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

NSInteger transactionSort(id trans1, id trans2, void *context)
{
	NSInteger dateResult = [[trans2 dateTime] compare:[trans1 dateTime]];
	NSInteger keyResult =  ([trans2 primaryKey] > [trans1 primaryKey])? 1 : -1;
	return (dateResult == 0)? keyResult : dateResult;
}

-(void)reloadTransactions
{
	[transactions release];
	transactions = [[BudgetTransaction loadAllTransactionsForCategoryId:[category primaryKey]] retain];
	NSArray* sortedTransactions = [[transactions sortedArrayUsingFunction:transactionSort context:NULL] retain];
	[transactions release];
	transactions = sortedTransactions;
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [transactions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString* tableViewCellIdentifier = @"TransactionSummaryTableViewCell";
	
	/*
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	// Configure the cell
	[cell setText:[[transactions objectAtIndex:[indexPath row]] note]];
	 */
	BudgetTransaction* transaction = [[transactions objectAtIndex:[indexPath row]] retain];
	
	//TransactionSummaryTableViewCell* cell = [[[TransactionSummaryTableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	
	
	TransactionSummaryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
	if (cell == nil) {
		cell = [[[TransactionSummaryTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableViewCellIdentifier] autorelease];
		UIView* backgroundView = [[UIView alloc] init];
		cell.backgroundView = backgroundView;
		[backgroundView release];
	}
	
	
	if([transaction.note length] > 0){
		[cell.noteLabel setText:transaction.note];
	}else{
		[cell.noteLabel setText:@"[No Note]"];
		
	}

	[cell.dateLabel setText:[TCDataConverter convertDateToString:transaction.dateTime]];
	[cell.amountLabel setText:[TCDataConverter convertCurrencyToString:transaction.amount  withSymbol:YES]];
	
	 [transaction release];
	
	if([indexPath row] % 2 == 0)
	{
	//	UIView* backgroundView = [[UIView alloc] init];
	//	backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	//	cell.backgroundView = backgroundView;
	//	[backgroundView release];
		//cell.contentView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.accessoryView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.opaque = YES;
		cell.accessoryView.opaque = YES;
		cell.backgroundView.backgroundColor =[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	}
	else
	{

	//	backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	//	cell.backgroundView = backgroundView;
	//	[backgroundView release];
		//cell.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		//cell.accessoryView.backgroundColor =  [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		cell.accessoryView.opaque = YES;
		cell.opaque = YES;
		cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		
		//cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
	} 
	
	return cell;
}

-(void)newTransaction:(id)sender
{
	BudgetTransaction* transaction = [[BudgetTransaction alloc] init];
	[transaction setCategoryId:[NSNumber numberWithInt:[category primaryKey]]];
	//if(tdc == nil)
	//{
		tdc = [[TransactionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	}
	[tdc setTransaction:transaction];
	[transaction release];
	[self.navigationController pushViewController:tdc animated:YES];
	[tdc release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//TransactionDetailViewController* controller = [[TransactionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	if(tdc == nil)
//	{
		tdc = [[TransactionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	}
	[tdc setTransaction:[transactions objectAtIndex:[indexPath row]]];
	
	[self.navigationController pushViewController:tdc animated:YES];
	[tdc release];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	
		[[transactions objectAtIndex:[indexPath row]] deleteTransaction];
		NSMutableArray* mutableArray = [transactions mutableCopy];
		[mutableArray removeObjectAtIndex:[indexPath row]];
		[transactions release];
		transactions = mutableArray;
		//[self reloadTransactions];
		[headerView.amountBudgetedLabel setText:[TCDataConverter convertCurrencyToString:[category budgetedAmount] withSymbol:YES]];
		//[headerView.amountRemainingLabel setText:@"Remaing"];
		[headerView.amountRemainingLabel setText:[TCDataConverter convertCurrencyToString:[category totalAmountRemaining] withSymbol:YES]];
		if([[category totalAmountRemaining] doubleValue] >= 0){
			headerView.amountRemainingLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
			[headerView.amountRemainingHeaderLabel setText:@"Remaining"];
		}
		else
		{
			headerView.amountRemainingLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0];
			[headerView.amountRemainingHeaderLabel setText:@"Over Budget"];
			
		}
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self reloadTransactions];
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)dealloc {
	//[tdc release];
	[tableView release];
	[headerView release];
	[category release];
	[transactions release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		toolbar.barStyle = UIBarStyleBlackOpaque;
	NSMutableArray* toolbarItems = [[NSMutableArray alloc] init];
	UIBarButtonItem* barItem = nil;
	barItem = [[UIBarButtonItem alloc] init];
	[barItem setTitle:@"Edit Category"];
	[barItem setStyle:UIBarButtonItemStyleBordered];
	[barItem setTag:1];
	[barItem setTarget:self];
	[barItem setAction:@selector(toolbarAction:)];
	[toolbarItems addObject:barItem];
	[barItem release];
	
	[toolbar setItems:toolbarItems];
	
	[toolbarItems release];
	
	
	tableView = [[UITableView alloc] initWithFrame:CGRectZero];
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	
	headerView = [[CategoryOverviewHeaderView alloc] initWithFrame:CGRectZero];
	//[headerView.testLabel setText:@"Woot"];
	//[headerView.amountBudgetedLabel setText:@"Budget"];
	[self.view addSubview:headerView];
	[self.view addSubview:tableView];
	[self.view addSubview:toolbar];
	[self.navigationItem setTitle:[category name]];
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTransaction:)] autorelease]];
	[self reloadTransactions];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	CGRect baseFrame = self.view.frame;
	CGRect headerViewRect = baseFrame;
	headerViewRect.size.height = 50;
	headerView.frame = headerViewRect;
	
	CGRect toolbarRect = baseFrame;
	toolbarRect.origin.y = baseFrame.size.height - 40;
	toolbarRect.size.height = 40;
	toolbar.frame = toolbarRect;
	
	CGRect tableViewRect = baseFrame;
	tableViewRect.origin.y += headerViewRect.size.height;
	tableViewRect.size.height -= toolbarRect.size.height+50;
	tableView.frame = tableViewRect;
	
	//[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	//[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	[headerView.amountBudgetedLabel setText:[TCDataConverter convertCurrencyToString:[category budgetedAmount] withSymbol:YES]];
	//[headerView.amountRemainingLabel setText:@"Remaing"];
	[headerView.amountRemainingLabel setText:[TCDataConverter convertCurrencyToString:[category totalAmountRemaining] withSymbol:YES]];

	if([[category totalAmountRemaining] doubleValue] >= 0){
		headerView.amountRemainingLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
		[headerView.amountRemainingHeaderLabel setText:@"Remaining"];
		}
	else
	{
		headerView.amountRemainingLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0];
		[headerView.amountRemainingHeaderLabel setText:@"Over Budget"];
		
	}
	
}

-(void)updateDisplayData
{
	[self reloadTransactions];
	[self.navigationItem setTitle:[category name]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	[self performSelector:@selector(updateDisplayData) withObject:nil afterDelay:0.5];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

