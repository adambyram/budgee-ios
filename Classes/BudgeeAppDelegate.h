//
//  BudgeeAppDelegate.h
//  Budgee
//
//  Created by Adam Byram on 8/18/08.
//  Copyright Adam Byram 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Budget;
@interface BudgeeAppDelegate : NSObject <UIApplicationDelegate> {
	
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	Budget* selectedBudget;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Budget* selectedBudget;

@end

