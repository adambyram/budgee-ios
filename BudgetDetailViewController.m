//
//  BudgetDetailViewController.m
//  Budgee
//
//  Created by Adam Byram on 3/3/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import "BudgetDetailViewController.h"
#import "Budget.h"
#import "TextEditTableViewCell.h"

@implementation BudgetDetailViewController

@synthesize budget;
@synthesize deleteBudgetAlertView;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToParent:)] autorelease]];		
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBudget:)] autorelease]];
	}
	return self;
}

-(void)returnToParent:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)saveBudget:(id)sender
{
	[budget setName:[[[controls objectAtIndex:0] valueTextField] text]];
	
	//	[category setIsDirty:YES];
	[budget saveBudget];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return ([budget existsInDB])?2:1;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		// Delete this category & all transactions under it
		[budget deleteBudget];
		[self.navigationController popToRootViewControllerAnimated:YES];
		
	}
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0)?1:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0){
		return [controls objectAtIndex:[indexPath row]];
	}else
	{
		UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
		UILabel* deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, cell.frame.size.width-40, cell.frame.size.height-10)];
		[deleteLabel setText:@"Delete Budget"];
		[deleteLabel setTextAlignment:UITextAlignmentCenter];
		[cell addSubview:deleteLabel];
		[deleteLabel release];
		return [cell autorelease];
		
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0){
		//[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
	}
	else
	{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		[deleteBudgetAlertView show];
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
	return UITableViewCellAccessoryNone;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	// Close the keyboard when the user presses Done
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[budget release];
	[deleteBudgetAlertView release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.scrollEnabled = NO;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	[controls release];
	controls = [[NSMutableArray alloc] initWithCapacity:4];
	
	TextEditTableViewCell* cell = nil;
	
	// Name - 0
	cell = [[TextEditTableViewCell alloc] initWithFrame:CGRectZero];
	[cell.nameLabel setText:@"Name"];
	[cell.valueTextField setText:[budget name]];
	[cell setIsReadOnly:NO];
	[cell.valueTextField setDelegate:self];
	//[cell.valueTextField becomeFirstResponder];
	[controls insertObject:cell atIndex:0];
	[cell release];

	
	[deleteBudgetAlertView release];
	deleteBudgetAlertView = [[UIAlertView alloc] init];
	deleteBudgetAlertView.title = @"Confirm Delete";
	deleteBudgetAlertView.message = @"You are about to delete this budget and any associated transactions.  Do you want to continue?";
	deleteBudgetAlertView.delegate = self;
	deleteBudgetAlertView.cancelButtonIndex = 0;
	[deleteBudgetAlertView addButtonWithTitle:@"Cancel"];
	[deleteBudgetAlertView addButtonWithTitle:@"OK"];
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(![budget existsInDB]){
		[self.navigationItem setTitle:@"New Budget"];
	}else{
		[self.navigationItem setTitle:@"Budget"];
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
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
