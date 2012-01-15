//
//  BudgeeAppDelegate.m
//  Budgee
//
//  Created by Adam Byram on 8/18/08.
//  Copyright Adam Byram 2008. All rights reserved.
//

#import "BudgeeAppDelegate.h"
#import "Budget.h"
#import "Category.h"
#import "Transaction.h"
#import "BudgetListController.h"


@implementation BudgeeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize selectedBudget;

- (id)init {
	if (self = [super init]) {
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	//if([Budget findByPK:1] == nil)
	if([[Budget loadAllBudgets] count] == 0)
	{
		Budget* budget = [[Budget alloc] init];
		//budget.pk = 1;
		budget.name = @"My Budget";
		[budget save];
		[budget release];
	}
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
		
	// Configure and show the window
	[navigationController release];
	BudgetListController* blc = [[BudgetListController alloc] init];
	[navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	navigationController = [[UINavigationController alloc] initWithRootViewController:blc];
	//blc.navigationController = navigationController;
	[[blc.parentViewController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
	[blc release];
	[self setSelectedBudget:nil];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@"Memory warning...");
	[Budget clearCache];
	[BudgetCategory clearCache];
	[BudgetTransaction clearCache];
}

- (void)dealloc {
		[selectedBudget release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
