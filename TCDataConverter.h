//
//  TCDataConverter.h
//  Budgee
//
//  Created by Adam Byram on 7/21/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

@interface TCDataConverter : NSObject {
}

+(NSNumber*)convertStringToCurrency:(NSString*)string;
+(NSString*)convertCurrencyToString:(NSNumber*)currency;
+(NSString*)convertCurrencyToString:(NSNumber*)currency withSymbol:(BOOL)includeSymbol;
+(NSDate*)convertStringToDate:(NSString*)string;
+(NSString*)convertDateToString:(NSDate*)date;
+(NSTimeInterval)convertNSDateToSqlFormatDate:(NSDate*)date;
+(NSDate*)convertSqlFormatDateToNSDate:(NSTimeInterval)sqlDate;

@end
