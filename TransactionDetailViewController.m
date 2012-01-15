//
//  TransactionDetailViewController.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//


#import "TransactionDetailViewController.h"
#import "Category.h"
#import "Transaction.h"
#import "TextEditTableViewCell.h"
#import "TCDataConverter.h"
#import "ListPickerController.h"
#import "BudgeeAppDelegate.h"

@implementation TransactionDetailViewController

@synthesize transaction;
@synthesize deleteTransactionAlertView;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		//datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 480.0f - 200.0f, 320.0f, 200.0f)];
		datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 480.0f-280.0f, 320.0f, 280.0f)];
		[datePicker setHidden:YES];
		datePicker.datePickerMode = UIDatePickerModeDate;
		[datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
		
		//[self.view addSubview:datePicker];
		viewHasBeenScrolled = NO;
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToParent:)] autorelease]];
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTransaction:)] autorelease]];
	}
	return self;
}

-(void)returnToParent:(id)sender
{
	if(viewHasBeenScrolled)
	{
		CGRect newFrame = self.tableView.frame;
		newFrame.size.height += 200;
		self.tableView.frame = newFrame;
		[datePicker setHidden:YES];
		viewHasBeenScrolled = NO;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)saveTransaction:(id)sender
{
	if(viewHasBeenScrolled)
	{
		CGRect newFrame = self.tableView.frame;
		newFrame.size.height += 200;
		self.tableView.frame = newFrame;
		[datePicker setHidden:YES];
		viewHasBeenScrolled = NO;
	}
	[transaction setNote:[[[controls objectAtIndex:0] valueTextField] text]];
	[transaction setAmount:[TCDataConverter convertStringToCurrency:[[[controls objectAtIndex:1] valueTextField] text]]];
	[transaction setDateTime:[TCDataConverter convertStringToDate:[[[controls objectAtIndex:2] valueTextField] text]]];
	
	//[transaction setIsDirty:YES];
	[transaction saveTransaction];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return ([transaction existsInDB])?2:1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0)?4:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0){
	return [controls objectAtIndex:[indexPath row]];
	}else
	   {
		   UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
		   UILabel* deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, cell.frame.size.width-40, cell.frame.size.height-10)];
		   [deleteLabel setText:@"Delete Transaction"];
		   [deleteLabel setTextAlignment:UITextAlignmentCenter];
		   [cell addSubview:deleteLabel];
		   [deleteLabel release];
		   return [cell autorelease];
	}
}

-(void)datePickerChanged:(id)sender
{
	// TODO
	TextEditTableViewCell* cell = [controls objectAtIndex:2];
	[cell.valueTextField setText:[TCDataConverter convertDateToString:[datePicker date]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if([indexPath section] == 0){
	NSUInteger start = 0;
	for(start = 0; start < [controls count]; start++)
	{
		[[[controls objectAtIndex:start] valueTextField] endEditing:YES];
	}
	
	/*
	UIAlertView* alert = [UIAlertView new];
	[alert setTitle:@"Clicked Row"];
	[alert setMessage:[NSString stringWithFormat:@"%d", [indexPath row]]];
	[alert addButtonWithTitle:@"OK"];
	[alert setCancelButtonIndex:0];
	[alert show];
	[alert release];
	 */
	if([indexPath row] == 2)
	{
	//	if(!viewHasBeenScrolled)
	//	{
			//CGRect newFrame = self.view.frame;
			//newFrame.size.height -= 200;
			//self.view.frame = newFrame;
	//		viewHasBeenScrolled = YES;
			[datePicker setDate:[transaction dateTime]];
			[datePicker setHidden:NO];
	//	}
	}
	else
	{
		//if(viewHasBeenScrolled)
		//{
		//	CGRect newFrame = self.tableView.frame;
		//	newFrame.size.height += 200;
		//	self.tableView.frame = newFrame;
			[datePicker setHidden:YES];
		//	viewHasBeenScrolled = NO;
		//}
		if([indexPath row] == 3)
		{
			ListPickerController* controller = [[ListPickerController alloc] initWithStyle:UITableViewStyleGrouped];
			Budget* selectedBudget = [[[[UIApplication sharedApplication] delegate] selectedBudget] retain];
			[controller setValueList:[[BudgetCategory loadAllCategoriesForBudgetId:[selectedBudget pk]] retain]];
			[selectedBudget release];
			[controller setListObjectKeyName:@"primaryKey"];
			[controller setListObjectValueName:@"name"];
			[controller setObjectToModify:transaction];
			[controller setSourceObjectKeyName:@"categoryId"];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
	}else
	{
		[deleteTransactionAlertView show];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		// Delete this transaction
		[transaction deleteTransaction];
		[self.navigationController popViewControllerAnimated:YES]; 
	}
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if([indexPath section] == 0 && [indexPath row] == 3)
	{
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	else
	{
		return UITableViewCellAccessoryNone;
	}
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	// Close the keyboard when the user presses Done
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[datePicker release];
	[deleteTransactionAlertView release];
	[transaction release];
	[controls release];
	[super dealloc];
}


- (void)viewDidLoad {


	self.tableView.scrollEnabled = NO;
		[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	[controls release];
	controls = [[NSMutableArray alloc] initWithCapacity:4];
	
	TextEditTableViewCell* cell = nil;
	
	// Note - 0
	cell = [[TextEditTableViewCell alloc] initWithFrame:CGRectZero];
	[cell.nameLabel setText:@"Note"];
	[cell.valueTextField setText:[transaction note]];
	[cell setIsReadOnly:NO];
	[cell.valueTextField setDelegate:self];
	//[cell.valueTextField becomeFirstResponder];
	[controls insertObject:cell atIndex:0];
	[cell release];
	
	// Amount - 1
	cell = [[TextEditTableViewCell alloc] initWithFrame:CGRectZero];
	[cell.nameLabel setText:@"Amount"];
	if([transaction existsInDB]){
		[cell.valueTextField setText:[TCDataConverter convertCurrencyToString:[transaction amount]]];
	}
	
	[cell setIsReadOnly:NO];
	[cell.valueTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[cell.valueTextField setDelegate:self];
	[controls insertObject:cell atIndex:1];
	[cell release];
	
	// Date - 2
	cell = [[TextEditTableViewCell alloc] initWithFrame:CGRectZero];
	[cell.nameLabel setText:@"Date"];
	[cell.valueTextField setText:[TCDataConverter convertDateToString:[transaction dateTime]]];
	[cell setIsReadOnly:YES];
	[controls insertObject:cell atIndex:2];
	[cell release];
	
	// Category - 3
	cell = [[TextEditTableViewCell alloc] initWithFrame:CGRectZero];
	[cell.nameLabel setText:@"Category"];
	BudgetCategory* category = [[BudgetCategory loadCategoryForKey:[[transaction categoryId] intValue]] retain];
	[cell.valueTextField setText:[category name]];
	[category release];
	[cell setIsReadOnly:YES];
	[controls insertObject:cell atIndex:3];
	[cell release];
	
	[deleteTransactionAlertView release];
	deleteTransactionAlertView = [[UIAlertView alloc] init];
	deleteTransactionAlertView.title = @"Confirm Delete";
	deleteTransactionAlertView.message = @"You are about to delete this transaction.  Do you want to continue?";
	deleteTransactionAlertView.delegate = self;
	deleteTransactionAlertView.cancelButtonIndex = 0;
	[deleteTransactionAlertView addButtonWithTitle:@"Cancel"];
	[deleteTransactionAlertView addButtonWithTitle:@"OK"];
	

	//[self.parentViewController.view addSubview:datePicker];
	[self.view addSubview:datePicker];
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(![transaction existsInDB]){
		[self.navigationItem setTitle:@"New Transaction"];
	}else{
		[self.navigationItem setTitle:@"Transaction"];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	TextEditTableViewCell* cell = [[controls objectAtIndex:3] retain];
	BudgetCategory* category = [[BudgetCategory loadCategoryForKey:[[transaction categoryId] intValue]] retain];
	[cell.valueTextField setText:[category name]];
	[category release];	
	[cell release];
	
	[[[controls objectAtIndex:0] valueTextField] becomeFirstResponder];
	 
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

