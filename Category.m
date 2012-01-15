//
//  Category.m
//  Budgee
//
//  Created by Adam Byram on 7/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "Category.h"
#import "SQLiteInstanceManager.h"
#import "Transaction.h"
#import <sqlite3.h>

@implementation BudgetCategory

@synthesize budgetedAmount;
@synthesize budgetId;
@synthesize name;


-(id)init
{
	if(self = [super init])
	{
		self.name = @"";
		self.budgetId = [NSNumber numberWithInt:1];
		self.budgetedAmount = [NSNumber numberWithDouble:0.0];
	}
	return self;
}

-(void)dealloc
{
	[name release];
	[budgetId release];
	[budgetedAmount release];
	[super dealloc];
}
 

-(NSInteger) primaryKey
{
	return [self pk];
}
/*
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
	
	sqlite3_finalize(stmt);
	sqlite3_reset(stmt);
	return result;
}
*/

-(NSNumber*) totalAmountRemaining
{
	return [NSNumber numberWithDouble:[budgetedAmount doubleValue] - [[self totalAmountSpent] doubleValue]];
}

-(NSNumber*) totalAmountSpent
{
	NSNumber* result = nil;
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database, [@"SELECT SUM(amount) FROM budget_transaction WHERE category_id=?" cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
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

-(BOOL)saveCategory
{
	[self save];
	return YES;
}
-(BOOL)deleteCategory
{
	[self deleteObject];
	[BudgetTransaction deleteAllTransactionsForCategoryId:[self primaryKey]];
	return YES;
}
+(BudgetCategory*)loadCategoryForKey:(NSInteger)key
{
	return (BudgetCategory*)[BudgetCategory findByPK:key];
}
+(NSArray*)loadAllCategories
{
	return [BudgetCategory findByCriteria:@"WHERE 1=1"];
}
+(NSArray*)loadAllCategoriesForBudgetId:(NSInteger)key
{
	//return [BudgetCategory loadAllCategories];
	return [BudgetCategory findByCriteria:[NSString stringWithFormat:@"WHERE budget_id=%d", key]];
}
-(BOOL)createCategory
{
	[self save];
	return YES;
}
-(BOOL)updateCategory
{
	[self save];
	return YES;
}
+(NSNumber*)budgetedTotalForBudgetId:(NSInteger)key
{
	return [NSNumber numberWithDouble:0.0];
}

@end
