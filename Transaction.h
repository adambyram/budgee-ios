//
//  Transaction.h
//  Budgee
//
//  Created by Adam Byram on 7/22/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface BudgetTransaction : SQLitePersistentObject {
	NSNumber* amount;
	NSNumber* categoryId;
	NSDate* dateTime;
	NSString* note;
}

@property (retain, nonatomic) NSNumber* amount;
@property (retain, nonatomic) NSNumber* categoryId;
@property (retain, nonatomic) NSDate* dateTime;
@property (retain, nonatomic) NSString* note;

-(NSInteger) primaryKey;

-(BOOL)saveTransaction;
-(BOOL)deleteTransaction;
+(BudgetTransaction*)loadTransactionForKey:(NSInteger)key;
+(NSArray*)loadAllTransactions;
+(NSArray*)loadAllTransactionsForCategoryId:(NSInteger)key;
-(BOOL)createTransaction;
-(BOOL)updateTransation;
//+(NSNumber*)transactionTotalForCategoryId:(NSInteger)key;
+(BOOL)deleteAllTransactions;
+(BOOL)deleteAllTransactionsForCategoryId:(NSInteger)key;
+(NSNumber*) totalNumberOfTransactionsForBudgetId:(NSInteger)budgetId;

@end
