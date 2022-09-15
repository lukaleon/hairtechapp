//
//  TextView.h
//  hairtech
//
//  Created by Lion on 6/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextViewCustom : UITextView


@property UIImage * bgImage;
@property CGPoint coords_xy;
+(TextViewCustom*)addTextView:(CGRect)rect;
-(void)passText:(NSString *)text;
@end

