//
//  TCLocaleManager.h
//  Budgee
//
//  Created by Adam Byram on 7/21/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

@interface TCLocaleManager : NSObject {

}

+(NSString*)currencySymbol;
+(NSString*)decimalSeparator;
+(NSString*)groupingSeparator;

@end
