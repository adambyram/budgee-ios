//
//  NSNumber-SQLitePersistence.m
// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//
// (c) 2008 Jeff LaMarche (jeff_Lamarche@mac.com)
// ----------------------------------------------------------------------
// This code may be used without restriction in any software, commercial,
// free, or otherwise. There are no attribution requirements, and no
// requirement that you distribute your changes, although bugfixes and 
// enhancements are welcome.
// 
// If you do choose to re-distribute the source code, you must retain the
// copyright notice and this license information. I also request that you
// place comments in to identify your changes.
//
// For information on how to use these classes, take a look at the 
// included eadme.txt file
// ----------------------------------------------------------------------
#import "NSNumber-SQLitePersistence.h"


@implementation NSNumber(SQLitePersistence)
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData
{
	//NSNumber* result = nil;
	double doubleValue = [columnData doubleValue];
	long longValue = [columnData longLongValue];
	
	if (doubleValue == longValue)
		self = [[NSNumber alloc] initWithLong:longValue];
	else
		self = [[NSNumber alloc] initWithDouble:doubleValue];
	
	return [self autorelease];
	//return [[NSNumber alloc] initWithDouble:doubleValue];
}
- (NSString *)sqlColumnRepresentationOfSelf
{
	return [self stringValue];
}
+ (BOOL)canBeStoredInSQLite
{
	return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
	return kSQLiteColumnTypeReal;
}
+ (BOOL)shouldBeStoredInBlob
{
	return NO;
}
@end
