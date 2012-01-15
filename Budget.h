//
//  Budget.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface Budget : SQLitePersistentObject {
	NSString* name;
}

@property (copy, nonatomic) NSString* name;

-(NSNumber*) totalAmountBudgeted;
-(NSNumber*) totalAmountSpent;
-(NSInteger) primaryKey;

-(BOOL)saveBudget;
-(BOOL)deleteBudget;
+(Budget*)loadBudgetForKey:(NSInteger)key;
+(NSArray*)loadAllBudgets;
-(BOOL)createBudget;
-(BOOL)updateBudget;

@end
