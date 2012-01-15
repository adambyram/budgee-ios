//
//  TCLocaleManager.m
//  Budgee
//
//  Created by Adam Byram on 7/21/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "TCLocaleManager.h"

@implementation TCLocaleManager

+(NSString*)currencySymbol
{
	return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

+(NSString*)decimalSeparator
{
	return [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
}

+(NSString*)groupingSeparator
{
	return [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
}

@end
