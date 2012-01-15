//
//  Transaction.m
//  Budgee
//
//  Created by Adam Byram on 7/22/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "Transaction.h"
#import "BudgeeAppDelegate.h"
#import "SQLiteInstanceManager.h"
#import <sqlite3.h>

@implementation BudgetTransaction

@synthesize amount;
@synthesize categoryId;
@synthesize dateTime;
@synthesize note;


-(id)init
{
	if(self = [super init])
	{
		[self setNote:@""];
		[self setAmount:[NSNumber numberWithDouble:0.00]];
		[self setDateTime:[NSDate date]];
		[self setCategoryId:0];
	}
	
	return self;
}
 
-(NSInteger) primaryKey
{
	return [self pk];
}

-(BOOL)saveTransaction
{
	[self save];
	return YES;
}
-(BOOL)deleteTransaction
{
	[self deleteObject];
	return YES;
}
+(BudgetTransaction*)loadTransactionForKey:(NSInteger)key
{
	return (BudgetTransaction*)[BudgetTransaction findByPK:key];
}
+(NSArray*)loadAllTransactions
{
	return [BudgetTransaction findByCriteria:@"WHERE 1=1"];
}
+(NSArray*)loadAllTransactionsForCategoryId:(NSInteger)key
{
	return [BudgetTransaction findByCriteria:[NSString stringWithFormat:@"WHERE category_id=%d", key]];
}
-(BOOL)createTransaction
{
	[self save];
	return YES;
}
-(BOOL)updateTransation
{
	[self save];
	return YES;
}
/*
+(NSNumber*)transactionTotalForCategoryId:(NSInteger)key
{
	//[[SQLiteInstanceManager sharedManager] database]
	return [NSNumber numberWithDouble:0.0];
}
 */
+(BOOL)deleteAllTransactions
{
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	//if (sqlite3_prepare_v2( database, [@"DELETE FROM budget_transaction" cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	NSString* sqlString = [[NSString stringWithFormat:@"DELETE FROM budget_transaction WHERE budget_transaction.pk IN( SELECT budget_transaction.pk FROM budget_transaction JOIN budget_category ON budget_category.pk = budget_transaction.category_id JOIN budget ON budget.pk = budget_category.budget_id WHERE budget.pk = %i)", [[[[UIApplication sharedApplication] delegate] selectedBudget] pk]] retain];
	if (sqlite3_prepare_v2( database, [sqlString cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	{
		if(sqlite3_step(stmt) != SQLITE_DONE)
		{
			NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
		}
	}
	else
	{
		NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
	}
	[sqlString release];
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	
	return YES;
}

+(BOOL)deleteAllTransactionsForCategoryId:(NSInteger)key
{
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database, [@"DELETE FROM budget_transaction WHERE category_id=?" cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, key);

		if(sqlite3_step(stmt) != SQLITE_DONE)
		{
			NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
		}
	}
	else
	{
		NSLog([NSString stringWithFormat:@"%s", sqlite3_errmsg(database)]);
	}
		sqlite3_reset(stmt);
	sqlite3_finalize(stmt);

	return YES;
}

+(NSNumber*) totalNumberOfTransactionsForBudgetId:(NSInteger)budgetId
{
	NSNumber* result = nil;
	sqlite3* database = [[SQLiteInstanceManager sharedManager] database];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database, [@"SELECT COUNT(*) FROM budget_transaction" cStringUsingEncoding:NSUTF8StringEncoding], -1, &stmt, nil) == SQLITE_OK)
	{
		//sqlite3_bind_int(stmt, 1, budgetId);
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

-(void)dealloc
{
	[note release];
	[amount release];
	[dateTime release];
	[categoryId release];
	[super dealloc];
}

@end
