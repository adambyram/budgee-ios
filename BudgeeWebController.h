//
//  BudgeeWebController.h
//  Budgee
//
//  Created by Adam Byram on 3/2/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPServer;

@interface BudgeeWebController : UIViewController {
	UILabel* ipDisplay;
	HTTPServer* httpServer;
		NSDictionary *addresses;
	BOOL isOn;
	UIActivityIndicatorView* progress;
}

@end
