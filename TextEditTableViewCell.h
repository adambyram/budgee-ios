//
//  TextEditTableViewCell.h
//  Budgee
//
//  Created by Adam Byram on 8/23/08.
//  Copyright 2008 Adam Byram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextEditTableViewCell : UITableViewCell {
	UITextField* valueTextField;
	UILabel* nameLabel;
	BOOL isReadOnly;
}

@property (retain, nonatomic) UITextField* valueTextField;
@property (retain, nonatomic) UILabel* nameLabel;
@property (assign,nonatomic) BOOL isReadOnly;

@end
