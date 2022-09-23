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
- (id)initWithFrame:(CGRect)frame font:(CGFloat)fontSize text:(NSString*)text color:(UIColor*)color;

+(TextViewCustom*)addTextView:(CGRect)rect;
//-(void)passText:(NSString *)text color:(UIColor*)color;
@end

