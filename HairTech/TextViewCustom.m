//
//  TextView.m
//  hairtech
//
//  Created by Lion on 6/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TextViewCustom.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation TextViewCustom

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
//        self.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:0.1] ;
//        self.layer.borderWidth = 1.0f;
//         self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self.layer setCornerRadius:5.0f];
//        self.layer.borderColor=[[UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0] CGColor];
        
//        self.backgroundColor = [UIColor yellowColor];
//        self.text = @"Text";

        
        //        self.layer.borderWidth = 1.0f;
        //self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //        [self.layer setCornerRadius:5.0f];
        //        self.layer.borderColor=[[UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0] CGColor];
        

    
      }
    
    
    return self;
}





/*
- (void)textViewDidChange:(UITextView *)txtView{
    float height = txtView.contentSize.height;
    
    [UITextView beginAnimations:nil context:nil];
    [UITextView setAnimationDuration:0.5];
    
    CGRect frame = txtView.frame;
    frame.size.height = height + 10.0; //Give it some padding
    txtView.frame = frame;
    [UITextView commitAnimations];
}
*/
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        self.frame = frame;
        [self setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.textContainerInset = UIEdgeInsetsMake(1.8, 0.8, 1.8, 1.2);
        self.editable = YES;
        self.selectable = YES;
        self.textContainer.lineFragmentPadding = 0;
        //[self sizeToFit];
        
        //self.textContainerInset = UIEdgeInsetsZero;
       
       

    }
    return self;
}
-(void)passText:(NSString *)text color:(UIColor*)color{
   // self.textColor = color;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = -0.20;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrsDictionary =
    @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f],
     NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName : color};
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
}
@end
