//
//  BudgetOverviewController.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "BudgetOverviewController.h"
#import "Category.h"
#import "CategoryOverviewController.h"
#import "Transaction.h"
#import "TransactionDetailViewController.h"
#import "CategoryDetailViewController.h"
#import "BudgetOverviewHeaderView.h"
#import "TCDataConverter.h"
#import	"CategorySummaryTableViewCell.h"
#import "BudgetDetailViewController.h"

@implementation BudgetOverviewController

@synthesize budget;
@synthesize tableView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		categories = nil;
			}
	return self;
}
*/
-(void)resetBudget:(id)sender
{
	[alertView show];

}
-(void)toolbarAction:(id)sender
{
	if([sender tag] == 1)
	{
		// Add Category
		BudgetCategory* category = [[BudgetCategory alloc] init];
		CategoryDetailViewController* controller = [[CategoryDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[controller setCategory:category];
		[category release];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	
	if([sender tag] == 2)
	{
		// Reset Budget
			[alertView show];
		//[alertView release];
	}
	
	if([sender tag] == 3)
	{
			// TODO: Show action sheet
		[actionSheet showInView:self.view];
	}
	
	if([sender tag] == 4)
	{
		BudgetDetailViewController* bdvc = [[BudgetDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[bdvc setBudget:budget];
		[self.navigationController pushViewController:bdvc animated:YES];
		[bdvc release];
	}
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//int i = 1;
	if(buttonIndex == 0)
	{
		[self exportCsvDataToEmail];
	}
	if(buttonIndex == 1)
	{
		[alertView show];
	}
}

-(void)exportCsvDataToEmail
{
	// Archive Data to Email
	NSMutableString* summaryEmailBody = [[NSMutableString alloc] init];
	
	[summaryEmailBody appendFormat:@"Budgee Data Export (%@)\n", [[NSDate date] retain]];
	[summaryEmailBody appendString:@"\n"];
	[summaryEmailBody appendString:@"Budget Summary\n"];
	[summaryEmailBody appendFormat:@"Budget Name: %@\n", [budget name]];
	[summaryEmailBody appendFormat:@"Budgeted: %@\n", [[TCDataConverter convertCurrencyToString:[[budget totalAmountBudgeted]  retain]] retain]];
	[summaryEmailBody appendFormat:@"Spent: %@\n", [[TCDataConverter convertCurrencyToString:[[budget totalAmountSpent] retain]] retain]];
	NSNumber* amountRemaining = [[NSNumber numberWithDouble:[[[budget totalAmountBudgeted] retain] doubleValue] - [[[budget totalAmountSpent] retain] doubleValue]] retain];
	[summaryEmailBody appendFormat:@"Remaining: %@\n", [TCDataConverter convertCurrencyToString:amountRemaining]];
	[amountRemaining release];
	[summaryEmailBody appendString:@"\n"];
	[summaryEmailBody appendString:@"Category Summary\n"];
	[summaryEmailBody appendString:@"=== BEGIN CATEGORY CSV ===\n"];
	[summaryEmailBody appendString:@"\"Name\",\"Budgeted\",\"Spent\",\"Remaining\"\n"];
	for(BudgetCategory* category in categories)
	{
		[summaryEmailBody appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\"\n", [[category name] retain], [[TCDataConverter convertCurrencyToString:[[category budgetedAmount] retain]] retain], [[TCDataConverter convertCurrencyToString:[[category totalAmountSpent] retain]] retain], [[TCDataConverter convertCurrencyToString:[[category totalAmountRemaining] retain]] retain]];
	}
	[summaryEmailBody appendString:@"=== END CATEGORY CSV ===\n"];
	[summaryEmailBody appendString:@"\n"];
	
	[summaryEmailBody appendString:@"Transaction Summary\n"];
	[summaryEmailBody appendString:@"=== BEGIN TRANSACTION CSV ===\n"];
	[summaryEmailBody appendString:@"\"Date\",\"Note\",\"Amount\",\"Category\"\n"];
	for(BudgetCategory* category in categories)
	{
		NSArray* transactions = [[BudgetTransaction loadAllTransactionsForCategoryId:[category primaryKey]] retain];
		for(BudgetTransaction* transaction in transactions)
		{
			[summaryEmailBody appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\"\n", [[TCDataConverter convertDateToString:[[transaction dateTime] retain]] retain], [[transaction note] retain], [[TCDataConverter convertCurrencyToString:[[transaction amount] retain]] retain], [[category name] retain]];
		}
		[transactions release];
	} 
	[summaryEmailBody appendString:@"=== END TRANSACTION CSV ===\n"];
	
		
	//NSString* emailSubject = [self htmlEncode:];
	//NSString* emailSubject = [NSString stringWithFormat:@"Budgee Data Export (%@)\n", [NSDate date]];
	//NSString* emailSubject = [[[[NSString alloc] initWithFormat:@"Budgee Data Export (%@)\n", [NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	
	
	//NSString* updatedBody = [[summaryEmailBody stringByReplacingOccurrencesOfString:@"&" withString:@" "] retain];
	//NSString* updatedBody2 = [[updatedBody stringByReplacingOccurrencesOfString:@"?" withString:@" "] retain];


	//NSString* updatedBody3 = [updatedBody2 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	
	//NSString* emailBody2 = [[updatedBody2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	//	NSLog(emailBody2);
	//NSString* emailBody = [[summaryEmailBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	
	//NSString* emailUrlString = [[NSString alloc] initWithFormat:@"mailto:?Subject=%@", emailSubject];
	//NSString* emailUrlString = [[NSString alloc] initWithFormat:@"mailto:?Subject=%@", @"Works"];
	
	//NSString* emailUrlString = [[[NSString alloc] initWithFormat:@"mailto:?Subject=%@&Body=%@", emailSubject, emailBody2] retain];
	//NSLog([NSString stringWithFormat:@"Length: %@", [emailUrlString length], nil]);
	//	NSLog([NSString stringWithFormat:@"URL: %@", emailUrlString, nil]);
	
	//int l = [emailUrlString length];
	//NSURL* emailUrl = [[NSURL URLWithString:emailUrlString] retain];//[[[NSURL alloc] initWithString:emailUrlString] retain];
	//* emailUrl = [[ alloc] init];
	//[emailUrlString writeToURL:emailUrl	atomically:NO encoding:NSUTF8StringEncoding error:NULL];
	//[[UIApplication sharedApplication] openURL:emailUrl];
	
	// BEGIN TEST CODE
	// First escape the body using a CF call
	NSString *escapedBody = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (CFStringRef)summaryEmailBody, NULL,  CFSTR("?=&+"), kCFStringEncodingUTF8) autorelease];
	
	[summaryEmailBody release];
	
	// Then escape the prefix using the NSString method
	NSString *mailtoPrefix = [[NSString stringWithFormat:@"mailto:?subject=Budgee Data Export (%@)\n&body=",[NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	// Finally, combine to create the fully escaped URL string
	NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
	
	// And let the application open the merged URL
	BOOL result = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
	
	
	
	if(result == NO)
	{
		UIAlertView* cannotExportAlertView = [[UIAlertView alloc] initWithTitle:@"CSV Export Error" message:@"Your data could not be exported via e-mail.  Please use the new Budgee Web feature to download the CSV file." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[cannotExportAlertView show];
		[cannotExportAlertView release];
	}
	// END TEST CODE
	
	//BOOL result = [[UIApplication sharedApplication] openURL:emailUrl];
	//[emailUrl release];
	//[emailUrlString release];
	//[emailSubject release];
	//[summaryEmailBody release];
	//[emailBody release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		// Perform the actual reset
		[BudgetTransaction deleteAllTransactions];
		[self reloadCategories];
		
		[self updateHeaderDisplay];
	}
}

NSInteger categorySort(id cat1, id cat2, void *context)
{
	return [[cat1 name] caseInsensitiveCompare:[cat2 name]];
}

-(void)reloadCategories
{
	[categories release];
	categories = [[BudgetCategory loadAllCategoriesForBudgetId:[budget primaryKey]] retain];
	NSArray* sortedCategories = [[categories sortedArrayUsingFunction:categorySort context:NULL] retain];
	[categories release];
	categories = sortedCategories;
	
	if([categories count] > 0)
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;	
	}
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;	
	}
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString* tableViewCellIdentifier = @"CategorySummaryTableViewCell";
	
	//static NSString *MyIdentifier = @"MyIdentifier";

	/*
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	*/
	
	
	//CategorySummaryTableViewCell* cell = [[[CategorySummaryTableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	
	CategorySummaryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
	if(cell == nil)
	{
		cell = [[[CategorySummaryTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableViewCellIdentifier] autorelease];
		UIView* backgroundView = [[UIView alloc] init];
		//backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.backgroundView = backgroundView;
		[backgroundView release];
	}
	
	
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
	
	if([indexPath row] % 2 == 0)
	{
		//UIView* backgroundView = [[UIView alloc] init];
		//backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.backgroundView = backgroundView;
		//[backgroundView release];
		//cell.contentView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.accessoryView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.opaque = YES;
		cell.accessoryView.opaque = YES;
		cell.backgroundView.backgroundColor =[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	}
	else
	{
		//UIView* backgroundView = [[UIView alloc] init];
		//backgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		//cell.backgroundView = backgroundView;
		//[backgroundView release];
		//cell.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		//cell.accessoryView.backgroundColor =  [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
		cell.accessoryView.opaque = YES;
				cell.opaque = YES;
		cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];

		//cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
	} 
	return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{

		return UITableViewCellAccessoryDisclosureIndicator;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryOverviewController* controller = [[CategoryOverviewController alloc] init];
	[controller setCategory:[categories objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[categories objectAtIndex:[indexPath row]] deleteCategory];
		
		NSMutableArray* mutableArray = [categories mutableCopy];
		[mutableArray removeObjectAtIndex:[indexPath row]];
		[categories release];
		categories = mutableArray;
		
		[self updateHeaderDisplay];

		
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self updateHeaderDisplay];
		//[self reloadCategories];
		if([categories count] > 0)
		{
			self.navigationItem.rightBarButtonItem.enabled = YES;	
		}
		else
		{
			self.navigationItem.rightBarButtonItem.enabled = NO;	
		}
		[self reloadCategories];
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
	[tableView release];
	[budget release];
	[toolbar release];
	[actionSheet release];
	[categories release];
	[super dealloc];
	
}

-(void)newTransaction:(id)sender
{
	
	BudgetTransaction* transaction = [[BudgetTransaction alloc] init];
	[transaction setCategoryId:[NSNumber numberWithInt:[[[BudgetCategory loadAllCategoriesForBudgetId:[budget pk]] objectAtIndex:0] primaryKey]]];
	TransactionDetailViewController* controller = [[TransactionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[controller setTransaction:transaction];
	[transaction release];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	 
	

}

- (void)viewDidLoad {
	[alertView release];
	// alertView = [[UIAlertView alloc] initWithTitle:@"Reset Budget" message:@"Resetting this budget will remove all existing transactions and put the budget back into its original state.  Do you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK"];
	alertView = [[UIAlertView alloc] init];
	alertView.title = @"Reset Budget";
	alertView.message = @"Resetting this budget will remove all existing transactions and put the budget back into its original state.  Do you want to continue?";
	alertView.delegate = self;
	alertView.cancelButtonIndex = 0;
	//alertView.numberOfButtons = 2;
		[alertView addButtonWithTitle:@"Cancel"];
	[alertView addButtonWithTitle:@"OK"];
	
	[super viewDidLoad];
	tableView = [[UITableView alloc] initWithFrame:CGRectZero];
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[self.view addSubview:tableView];
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	toolbar.barStyle = UIBarStyleBlackOpaque;
	NSMutableArray* toolbarItems = [[NSMutableArray alloc] init];
	UIBarButtonItem* barItem = nil;
	barItem = [[UIBarButtonItem alloc] init];
	[barItem setTitle:@"Add Category"];
		[barItem setStyle:UIBarButtonItemStyleBordered];
	[barItem setTag:1];
	[barItem setTarget:self];
	[barItem setAction:@selector(toolbarAction:)];
	[toolbarItems addObject:barItem];
	[barItem release];
	barItem = [[UIBarButtonItem alloc] init];
	[barItem setTitle:@"Edit Budget"];
	[barItem setStyle:UIBarButtonItemStyleBordered];
	[barItem setTag:4];
	[barItem setTarget:self];
	[barItem setAction:@selector(toolbarAction:)];
	[toolbarItems addObject:barItem];
	[barItem release];
	/*barItem = [[UIBarButtonItem alloc] init];
	[barItem setTitle:@"Reset"];
	[barItem setStyle:UIBarButtonItemStyleBordered];
	[barItem setTag:2];
	[barItem setTarget:self];
	[barItem setAction:@selector(toolbarAction:)];
	[toolbarItems addObject:barItem];
	[barItem release];
	*/
	barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(toolbarAction:)];
	[barItem setStyle:UIBarButtonItemStylePlain];
	[barItem setTag:4];
	[toolbarItems addObject:barItem];
	[barItem release];
	
	barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toolbarAction:)];
	[barItem setTag:3];
	
		[toolbarItems addObject:barItem];
	[barItem release];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	headerView = [[BudgetOverviewHeaderView alloc] initWithFrame:CGRectZero];
	//[headerView.amountLabel setText:@"Woot"];
	[headerView.messageLabel setText:@"Remaining"];
	[self.view addSubview:headerView];
	/*
	 [headerView.amountLabel setText:@"Woot"];
	[headerView.messageLabel setText:@"Message"];
	[self.parentViewController.view addSubview:headerView];
	*/
	
	/*
	barItem = [[UIBarButtonItem alloc] init];
	[barItem setTitle:@"Reset Budget"];
	[barItem setTag:2];
	[barItem setTarget:self];
	[barItem setAction:@selector(toolbarAction:)];
	[toolbarItems addObject:barItem];
	[barItem release];
	*/
	[toolbar setItems:toolbarItems];
	
	[toolbarItems release];
	//[self.parentViewController.view addSubview:toolbar];
	[self.view addSubview:toolbar];
	
	if(budget == nil)
	{
		// In this version, only one budget is supported, so load it by default
		budget = [[Budget loadBudgetForKey:1] retain];
	}
	
	actionSheet = [[UIActionSheet alloc] initWithTitle:@"Budget Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Export CSV to E-mail", @"Reset Budget", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	
	[[self navigationItem] setTitle:budget.name];
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTransaction:)] autorelease]];
//	[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetBudget:)]];

	[self reloadCategories];
}

- (void)viewWillAppear:(BOOL)animated {
	//[tableView selectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	if(![budget existsInDB])
	{
		[self.navigationController popViewControllerAnimated:NO];
		return;
	}
	
	[super viewWillAppear:animated];
		[[self navigationItem] setTitle:budget.name];
	CGRect baseFrame = self.view.frame;
	CGRect headerViewRect = baseFrame;
	headerViewRect.size.height = 60;
	headerView.frame = headerViewRect;
	
	CGRect toolbarRect = baseFrame;
	toolbarRect.origin.y = baseFrame.size.height - 40;
	toolbarRect.size.height = 40;
	toolbar.frame = toolbarRect;
	
	CGRect tableViewRect = baseFrame;
	tableViewRect.origin.y += headerViewRect.size.height;
	tableViewRect.size.height -= toolbarRect.size.height + headerViewRect.size.height;
	tableView.frame = tableViewRect;
	
	
	//[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	//[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	[self reloadCategories];

	[self updateHeaderDisplay];
}

-(void) updateHeaderDisplay
{
	NSNumber* totalBudget = [[budget totalAmountBudgeted] retain];
	NSNumber* totalSpent = [[budget totalAmountSpent] retain];
	
	NSNumber* amountRemaining = [[NSNumber numberWithDouble:[totalBudget doubleValue] - [totalSpent doubleValue]] retain];
	NSString* amountRemainingString = [[TCDataConverter convertCurrencyToString:amountRemaining withSymbol:YES] retain];
	
	[headerView.amountLabel setText:amountRemainingString];
	if([amountRemaining doubleValue] >= 0){
		headerView.amountLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
		[headerView.messageLabel setText:@"Remaining"];
	}else
	{
		headerView.amountLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0];
		[headerView.messageLabel setText:@"Over Budget"];
	}
	[amountRemaining release];
	[amountRemainingString release];
	[totalSpent release];
	[totalBudget release];
	
	// Check for existing transactions - if there are none, then disable the Reset button
	NSNumber* totalTransactions = [[BudgetTransaction totalNumberOfTransactionsForBudgetId:[budget pk]] retain];
	
	if([totalTransactions intValue] > 0)
	{
		[[self.navigationItem leftBarButtonItem] setEnabled:YES];
	}
	else
	{
		[[self.navigationItem leftBarButtonItem] setEnabled:NO];
	}
	
	[totalTransactions release];
}

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	/*CGRect baseFrame = self.view.frame;
	//baseFrame.size.height = 40;
	//baseFrame.origin.y = self.view.frame.size.height - 40;
	toolbar.frame = CGRectZero;
	[toolbar setHidden:YES];
	
	baseFrame = self.tableView.frame;
	baseFrame.size.height += 40;
	self.tableView.frame = baseFrame;
*/
}

- (void)viewDidDisappear:(BOOL)animated {
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

