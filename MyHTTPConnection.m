//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import "MyHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "Budget.h"
#import "Category.h"
#import "Transaction.h"
#import "TCDataConverter.h"


@implementation MyHTTPConnection

/**
 * Returns whether or not the requested resource is browseable.
**/
- (BOOL)isBrowseable:(NSString *)path
{
	// Override me to provide custom configuration...
	// You can configure it for the entire server, or based on the current request
	
	return YES;
}

-(void)dealloc
{
	[super dealloc];
}

/**
 * This method creates a html browseable page.
 * Customize to fit your needs
**/
- (NSString *) createBrowseableIndex:(NSString *)path
{
    NSArray *array = [[NSFileManager defaultManager] directoryContentsAtPath:path];
    
    NSMutableString *outdata = [NSMutableString new];
	[outdata appendString:@"<html><head>"];
	[outdata appendFormat:@"<title>Files from %@</title>", server.name];
    [outdata appendString:@"<style>html {background-color:#eeeeee} body { background-color:#FFFFFF; font-family:Tahoma,Arial,Helvetica,sans-serif; font-size:18x; margin-left:15%; margin-right:15%; border:3px groove #006600; padding:15px; } </style>"];
    [outdata appendString:@"</head><body>"];
	[outdata appendFormat:@"<h1>Files from %@</h1>", server.name];
    [outdata appendString:@"<bq>The following files are hosted live from the iPhone's Docs folder.</bq>"];
    [outdata appendString:@"<p>"];
	[outdata appendFormat:@"<a href=\"..\">..</a><br />\n"];
    for (NSString *fname in array)
    {
        NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:[path stringByAppendingPathComponent:fname] traverseLink:NO];
		//NSLog(@"fileDict: %@", fileDict);
        NSString *modDate = [[fileDict objectForKey:NSFileModificationDate] description];
		if ([[fileDict objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"]) fname = [fname stringByAppendingString:@"/"];
		[outdata appendFormat:@"<a href=\"%@\">%@</a>		(%8.1f Kb, %@)<br />\n", fname, fname, [[fileDict objectForKey:NSFileSize] floatValue] / 1024, modDate];
    }
    [outdata appendString:@"</p>"];
	
	if ([self supportsPOST:path withSize:0])
	{
		[outdata appendString:@"<form action=\"\" method=\"post\" enctype=\"multipart/form-data\" name=\"form1\" id=\"form1\">"];
		[outdata appendString:@"<label>upload file"];
		[outdata appendString:@"<input type=\"file\" name=\"file\" id=\"file\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"<label>"];
		[outdata appendString:@"<input type=\"submit\" name=\"button\" id=\"button\" value=\"Submit\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"</form>"];
	}
	
	[outdata appendString:@"</body></html>"];
    
	//NSLog(@"outData: %@", outdata);
    return [outdata autorelease];
}

- (NSString *) createBudgeeWebHome
{
	contentType = @"text/html;charset=UTF-8";
    NSMutableString *outdata = [NSMutableString new];
	[outdata appendString:@"<html><head>"];
	[outdata appendString:@"<title>Budgee Web</title>"];
	
    [outdata appendString:@"<style>html {background-color:#eeeeee} body { background-color:#FFFFFF; font-family:Tahoma,Arial,Helvetica,sans-serif; font-size:18x; margin-left:15%; margin-right:15%; border:3px groove #006600; padding:15px; } </style>"];
    [outdata appendString:@"</head><body>"];
	[outdata appendString:@"<h1>Budgee Web - Data Download</h1><br/>"];
	[outdata appendString:@"<p>Click on a link to view/download Budgee data for each budget.</p><br/>"];
   
	NSArray* budgets = [Budget loadAllBudgets];
	for(Budget* b in budgets)
	{
		[outdata appendFormat:@"%@&nbsp;&nbsp;&nbsp;<a href=\"/CSV/%i\">[Transaction CSV]</a>&nbsp;&nbsp;&nbsp;<a href=\"/TXT/%i\">[All Data - Text Export]</a><br/>",[b name], [b pk], [b pk] ];
	}

	
	[outdata appendString:@"</body></html>"];
    
	//NSLog(@"outData: %@", outdata);
    return [outdata autorelease];
}

/**
 * Returns whether or not the server will accept POSTs.
 * That is, whether the server will accept uploaded data for the given URI.
**/
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
//	NSLog(@"POST:%@", path);
	
	dataStartIndex = 0;
	multipartData = [[NSMutableArray alloc] init];
	postHeaderOK = FALSE;
	
	return YES;
}

/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
**/
- (NSObject<HTTPResponse> *)httpResponseForURI:(NSString *)path
{
//	NSLog(@"httpResponseForURI: %@", path);
	
	if (postContentLength > 0)		//process POST data
	{
		NSLog(@"processing post data: %i", postContentLength);
		
		NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
		NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
		postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
		postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
		NSString* filename = [postInfoComponents lastObject];
		
		if (![filename isEqualToString:@""]) //this makes sure we did not submitted upload form without selecting file
		{
			UInt16 separatorBytes = 0x0A0D;
			NSMutableData* separatorData = [NSMutableData dataWithBytes:&separatorBytes length:2];
			[separatorData appendData:[multipartData objectAtIndex:0]];
			int l = [separatorData length];
			int count = 2;	//number of times the separator shows up at the end of file data
			
			NSFileHandle* dataToTrim = [multipartData lastObject];
			NSLog(@"data: %@", dataToTrim);
			
			for (unsigned long long i = [dataToTrim offsetInFile] - l; i > 0; i--)
			{
				[dataToTrim seekToFileOffset:i];
				if ([[dataToTrim readDataOfLength:l] isEqualToData:separatorData])
				{
					[dataToTrim truncateFileAtOffset:i];
					i -= l;
					if (--count == 0) break;
				}
			}
			
			NSLog(@"NewFileUploaded");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NewFileUploaded" object:nil];
		}
		
		//for (int n = 1; n < [multipartData count] - 1; n++)
		//	NSLog(@"%@", [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:n] bytes] length:[[multipartData objectAtIndex:n] length] encoding:NSUTF8StringEncoding]);
		
		[postInfo release];
		[multipartData release];
		postContentLength = 0;
		
	}
	
	contentType = nil;
	contentDisposition = nil;
	
	NSString *filePath = [self filePathForURI:path];
	
	// TODO: Load files from bundle too
	
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return [[[HTTPFileResponse alloc] initWithFilePath:filePath] autorelease];
	}
	else
	{
		NSString *folder = [path isEqualToString:@"/"] ? [[server documentRoot] path] : [NSString stringWithFormat: @"%@%@", [[server documentRoot] path],path];
		if ([self isBrowseable:folder])
		{
			//NSLog(@"folder: %@", folder);
			//int a = [[path componentsSeparatedByString:@"/"] count];
			if([path caseInsensitiveCompare:@"/"] == NSOrderedSame)
			{
				NSData *browseData = [[self createBudgeeWebHome] dataUsingEncoding:NSUTF8StringEncoding];
				return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
				
			}
			else if([[path componentsSeparatedByString:@"/"] count] == 3 && [[[path componentsSeparatedByString:@"/"] objectAtIndex:1] caseInsensitiveCompare:@"CSV"] == NSOrderedSame)
			{
				int budgetId = [[[path componentsSeparatedByString:@"/"] objectAtIndex:2] intValue];
				NSData *browseData = [[self getCsvDataForBudgetId:budgetId asText:NO] dataUsingEncoding:NSUTF8StringEncoding];
				return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
			}
			else if([[path componentsSeparatedByString:@"/"] count] == 3 && [[[path componentsSeparatedByString:@"/"] objectAtIndex:1] caseInsensitiveCompare:@"TXT"] == NSOrderedSame)
			{
				int budgetId = [[[path componentsSeparatedByString:@"/"] objectAtIndex:2] intValue];
				NSData *browseData = [[self getCsvDataForBudgetId:budgetId asText:YES] dataUsingEncoding:NSUTF8StringEncoding];
				return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
			}
		/*	else if([path caseInsensitiveCompare:@"/DB/"] == 0)
			{
			NSData *browseData = [[self createBrowseableIndex:folder] dataUsingEncoding:NSUTF8StringEncoding];
				//NSData *browseData = [[self createBrowseableIndex:[[server documentRoot] path]] dataUsingEncoding:NSUTF8StringEncoding];

			return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
			}*/
		}
	}
	
	return nil;
}

-(NSString*)getCsvDataForBudgetId:(int)budgetId asText:(BOOL)asText
{
	Budget* b = [[Budget findByPK:budgetId] retain];
	NSArray* categories = [[BudgetCategory loadAllCategoriesForBudgetId:budgetId] retain];
	if(!asText) 
	{
		contentType = [[NSString stringWithFormat:@"text/csv; name=\"%@.csv\";charset=UTF-8", [b name]] retain];
		contentDisposition = [[NSString stringWithFormat:@"attachment; filename=\"%@.csv\";", [b name]] retain];
	}else
	{
		contentType = nil;
		contentDisposition = [[NSString stringWithFormat:@"attachment; filename=\"%@.txt\"", [b name]] retain];
	}

	
	// Archive Data to Email
	NSMutableString* summaryEmailBody = [[NSMutableString alloc] init];
if(asText)
{
	[summaryEmailBody appendFormat:@"Budgee Data Export (%@)\n", [[NSDate date] retain]];
	[summaryEmailBody appendString:@"\n"];
	[summaryEmailBody appendString:@"Budget Summary\n"];
	[summaryEmailBody appendFormat:@"Budget Name: %@\n", [b name]];
	[summaryEmailBody appendFormat:@"Budgeted: %@\n", [[TCDataConverter convertCurrencyToString:[[b totalAmountBudgeted]  retain]] retain]];
	[summaryEmailBody appendFormat:@"Spent: %@\n", [[TCDataConverter convertCurrencyToString:[[b totalAmountSpent] retain]] retain]];
	NSNumber* amountRemaining = [[NSNumber numberWithDouble:[[[b totalAmountBudgeted] retain] doubleValue] - [[[b totalAmountSpent] retain] doubleValue]] retain];
	[summaryEmailBody appendFormat:@"Remaining: %@\n", [TCDataConverter convertCurrencyToString:amountRemaining]];
	[amountRemaining release];
	[summaryEmailBody appendString:@"\n"];
	[summaryEmailBody appendString:@"Category Summary\n"];
	[summaryEmailBody appendString:@"=== BEGIN CATEGORY CSV ===\n"];
	[summaryEmailBody appendString:@"\"Name\",\"Budgeted\",\"Spent\",\"Remaining\"\n"];
	for(BudgetCategory* category in categories)
	{
		[summaryEmailBody appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\"\n", [[category name] retain], [[TCDataConverter convertCurrencyToString:[[category budgetedAmount] retain]] retain], [[TCDataConverter convertCurrencyToString:[[category totalAmountSpent] retain]] retain], [[TCDataConverter convertCurrencyToString:[[category totalAmountRemaining] retain]] retain]];
	}
	[summaryEmailBody appendString:@"=== END CATEGORY CSV ===\n"];
	[summaryEmailBody appendString:@"\n"];
	
	[summaryEmailBody appendString:@"Transaction Summary\n"];
	[summaryEmailBody appendString:@"=== BEGIN TRANSACTION CSV ===\n"];
}
	[summaryEmailBody appendString:@"\"Date\",\"Note\",\"Amount\",\"Category\"\n"];
	for(BudgetCategory* category in categories)
	{
		NSArray* transactions = [[BudgetTransaction loadAllTransactionsForCategoryId:[category primaryKey]] retain];
		for(BudgetTransaction* transaction in transactions)
		{
			[summaryEmailBody appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\"\n", [[TCDataConverter convertDateToString:[[transaction dateTime] retain]] retain], [[transaction note] retain], [[TCDataConverter convertCurrencyToString:[[transaction amount] retain]] retain], [[category name] retain]];
		}
		[transactions release];
	} 
if(asText)
{
	[summaryEmailBody appendString:@"=== END TRANSACTION CSV ===\n"];
}
	[categories release];
	[b release];
	
	return [summaryEmailBody autorelease];
	
}

/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
**/
- (void)processPostDataChunk:(NSData *)postDataChunk
{
	// Override me to do something useful with a POST.
	// If the post is small, such as a simple form, you may want to simply append the data to the request.
	// If the post is big, such as a file upload, you may want to store the file to disk.
	// 
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	//NSLog(@"processPostDataChunk");
	
	if (!postHeaderOK)
	{
		UInt16 separatorBytes = 0x0A0D;
		NSData* separatorData = [NSData dataWithBytes:&separatorBytes length:2];
		
		int l = [separatorData length];
		for (int i = 0; i < [postDataChunk length] - l; i++)
		{
			NSRange searchRange = {i, l};
			if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
			{
				NSRange newDataRange = {dataStartIndex, i - dataStartIndex};
				dataStartIndex = i + l;
				i += l - 1;
				NSData *newData = [postDataChunk subdataWithRange:newDataRange];
				if ([newData length])
				{
					[multipartData addObject:newData];
					
				}
				else
				{
					postHeaderOK = TRUE;
					
					NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
					NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
					postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
					postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
					NSString* filename = [[[server documentRoot] path] stringByAppendingPathComponent:[postInfoComponents lastObject]];
					NSRange fileDataRange = {dataStartIndex, [postDataChunk length] - dataStartIndex};
					
					[[NSFileManager defaultManager] createFileAtPath:filename contents:[postDataChunk subdataWithRange:fileDataRange] attributes:nil];
					NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filename] retain];
					if (file)
					{
						[file seekToEndOfFile];
						[multipartData addObject:file];
					}
					
					[postInfo release];
					
					break;
				}
			}
		}
	}
	else
	{
		[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
	}
}

@end
