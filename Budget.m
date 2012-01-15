//
//  Budget.m
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "Budget.h"
#import "SQLiteInstanceManager.h"
#import "/usr/include/sqlite3.h"
#import "Category.h"

@implementation Budget

@synthesize name;

-(NSNumber*) totalAmountBudgeted
{
	NSNumber* result = nil;
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database, [@"SELECT SUM(budgeted_amount) FROM budget_category WHERE budget_id=?" cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, [self primaryKey]);
		if (sqlite3_step(stmt) == SQLITE_ROW)
		{
			result = [NSNumber numberWithDouble:sqlite3_column_double(stmt, 0)];
		}
	}
	else
	{
		NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
	}
		sqlite3_reset(stmt);
	sqlite3_finalize(stmt);

	return result;
}

-(NSNumber*) totalAmountSpent
{
	NSNumber* result = nil;
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database, [[NSString stringWithFormat:@"SELECT SUM(budget_transaction.amount) FROM budget_transaction JOIN budget_category ON budget_category.pk = budget_transaction.category_id WHERE budget_category.budget_id = %i",[[[[UIApplication sharedApplication] delegate] selectedBudget] pk] ] cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	{
		if (sqlite3_step(stmt) == SQLITE_ROW)
		{
			result = [NSNumber numberWithDouble:sqlite3_column_double(stmt, 0)];
		}
	}
	else
	{
		NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
	}
		sqlite3_reset(stmt);
	sqlite3_finalize(stmt);

	return result;
}


-(id)init
{
	if(self = [super init])
	{
		self.name = @"";
	}
	return self;
}

-(void)dealloc
{
	[name release];
	[super dealloc];
}


-(NSInteger) primaryKey
{
	return [self pk];
}

-(BOOL)saveBudget
{
	[self save];
	return YES;
}
-(BOOL)deleteBudget
{
	NSArray* categoryList = [[BudgetCategory loadAllCategoriesForBudgetId:[self pk]] retain];
	for(BudgetCategory* bc in categoryList)
	{
		[bc deleteCategory];
	}
	[categoryList release];
	[self deleteObject];
	return YES;
}
+(Budget*)loadBudgetForKey:(NSInteger)key
{
	return (Budget*)[Budget findByPK:key];
}
+(NSArray*)loadAllBudgets
{
	return [Budget findByCriteria:@"WHERE 1=1"];
}
-(BOOL)createBudget
{
	[self save];
	return YES;
}
-(BOOL)updateBudget
{
	[self save];
	return YES;
}

@end
