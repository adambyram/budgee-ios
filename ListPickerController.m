//
//  ListPickerController.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "ListPickerController.h"
#import "Category.h"

@implementation ListPickerController

@synthesize valueList;
@synthesize objectToModify;
@synthesize sourceObjectKeyName;
@synthesize listObjectKeyName;
@synthesize listObjectValueName;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [valueList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	// Configure the cell
	BudgetCategory* category = [valueList objectAtIndex:[indexPath row]];
	[cell setText:[category valueForKey:listObjectValueName]];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id tempObject = [[valueList objectAtIndex:[indexPath row]] retain];
	[objectToModify setValue:[tempObject valueForKey:listObjectKeyName] forKey:sourceObjectKeyName];
	[tempObject release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if([[valueList objectAtIndex:[indexPath row]] valueForKey:listObjectKeyName] == [objectToModify valueForKey:sourceObjectKeyName])
	{
		return UITableViewCellAccessoryCheckmark;
	}
	else
	{
		return UITableViewCellAccessoryNone;
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


- (void)dealloc {
	[valueList release];
	[objectToModify release];
	[sourceObjectKeyName release];
	[listObjectKeyName release];
	[listObjectValueName release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
		[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
}

NSInteger valueSort(id v1, id v2, void *context)
{
	NSString* lovn = (NSString*) context;
	return [[v1 valueForKey:lovn] caseInsensitiveCompare:[v2 valueForKey:lovn]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSArray* sortedValues = [[valueList sortedArrayUsingFunction:valueSort context:listObjectValueName] retain];
	[valueList release];
	valueList = sortedValues;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

