//
//  TCDataConverter.m
//  Budgee
//
//  Created by Adam Byram on 7/21/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import "TCDataConverter.h"
#import "TCLocaleManager.h"

@implementation TCDataConverter

+(NSNumber*)convertStringToCurrency:(NSString*)string
{
	NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter  setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setPartialStringValidationEnabled:YES];
	[numberFormatter setLocale:[NSLocale currentLocale]];
	[numberFormatter setLenient:YES];
	// TODO: Settings this fixes everything, HOWEVER, it only works in the simulator and is not
	// actually usable on the device for some reason...it's not in the docs, but since it doesn't
	// work correctly without it, it seems like it's an issue with iPhone OS itself
	//[numberFormatter setLocalizesFormat:YES];
	
	// Try to convert a perfectly formatted currency string - sometimes this works and sometimes it doesn't
	NSDecimalNumber* convertedNumber = nil;
	
	if (string == nil) {
		string = @"0";
	}
	
	convertedNumber = [[numberFormatter numberFromString:string] retain];
	
	// If we didn't get a conversion yet, try to convert the string as a decimal
	if(convertedNumber == nil)
	{
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		convertedNumber = [[numberFormatter numberFromString:string] retain];
	}
	
	// If we didn't get a conversion yet, try to convert the string anything we can (using the converter)
	if(convertedNumber == nil)
	{
		[numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
		convertedNumber = [[numberFormatter numberFromString:string] retain];
	}
	
	[numberFormatter release];
	
	// The converter failed, so default to pretending it's a regular double (and if it isn't, we'll default to zero)
	if(convertedNumber == nil)
	{
		// Formatter didn't take the input
		convertedNumber = [[NSNumber numberWithDouble:[string doubleValue]] retain];
	}
	
	return [convertedNumber autorelease];
	
}

+(NSString*)convertCurrencyToString:(NSNumber*)currency
{
	return [TCDataConverter convertCurrencyToString:currency withSymbol:NO];
}

+(NSString*)convertCurrencyToString:(NSNumber*)currency withSymbol:(BOOL)includeSymbol
{
	NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter  setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	if(includeSymbol == NO)
		[numberFormatter setCurrencySymbol:@""];
	NSString* formatedString = [[numberFormatter stringFromNumber:currency] retain];
	[numberFormatter release];
	return [formatedString autorelease];
}

+(NSDate*)convertStringToDate:(NSString*)string
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	NSDate* convertedDate = [[dateFormatter dateFromString:string] retain];
	[dateFormatter release];
	return [convertedDate autorelease];
}

+(NSString*)convertDateToString:(NSDate*)date
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	NSString* formattedString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return formattedString;
}


+(NSTimeInterval)convertNSDateToSqlFormatDate:(NSDate*)date
{
	// TODO
	return [date timeIntervalSince1970];
}

+(NSDate*)convertSqlFormatDateToNSDate:(NSTimeInterval)sqlDate
{
	// TODO
	return [NSDate dateWithTimeIntervalSince1970:sqlDate];
}

@end
