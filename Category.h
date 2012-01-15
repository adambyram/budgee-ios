//
//  Category.h
//  Budgee
//
//  Created by Adam Byram on 7/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface BudgetCategory : SQLitePersistentObject {
	NSNumber* budgetedAmount;
	NSNumber* budgetId;
	NSString* name;
}

@property (copy, nonatomic) NSNumber* budgetedAmount;
@property (copy, nonatomic) NSNumber* budgetId;
@property (copy, nonatomic) NSString* name;

-(NSInteger) primaryKey;
-(NSNumber*) totalAmountRemaining;
//-(NSNumber*) totalAmountBudgeted;
-(NSNumber*) totalAmountSpent;

-(BOOL)saveCategory;
-(BOOL)deleteCategory;
+(BudgetCategory*)loadCategoryForKey:(NSInteger)key;
+(NSArray*)loadAllCategories;
+(NSArray*)loadAllCategoriesForBudgetId:(NSInteger)key;
-(BOOL)createCategory;
-(BOOL)updateCategory;
+(NSNumber*)budgetedTotalForBudgetId:(NSInteger)key;

@end
