//
//  ListPickerController.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListPickerController : UITableViewController {
	NSArray* valueList;
	NSObject* objectToModify;
	NSString* sourceObjectKeyName;
	NSString* listObjectKeyName;
	NSString* listObjectValueName;
}

@property (retain, nonatomic) NSArray* valueList;
@property (retain, nonatomic) NSObject* objectToModify;
@property (retain, nonatomic) NSString* sourceObjectKeyName;
@property (retain, nonatomic) NSString* listObjectKeyName;
@property (retain, nonatomic) NSString* listObjectValueName;

@end
