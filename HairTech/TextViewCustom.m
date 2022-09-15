//
//  TextView.m
//  hairtech
//
//  Created by Lion on 6/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TextViewCustom.h"
#import <QuartzCore/QuartzCore.h>

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
        self.text = @"TEXT";
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.editable = YES;
        self.selectable = YES;
        self.backgroundColor = [UIColor redColor];
        self.textContainer.lineFragmentPadding = 0;
        
    }
    return self;
}

+(TextViewCustom*)addTextView:(CGRect)rect
{
    TextViewCustom * textView = [[[self class] alloc] init];
    textView.frame = rect;
    [textView setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    textView.textColor = [UIColor blackColor];
    textView.text = @"TEXT";
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.editable = YES;
    textView.selectable = YES;
    textView.backgroundColor = [UIColor clearColor];
    textView.textContainer.lineFragmentPadding = 0;
   // textView.userInteractionEnabled = YES;
    
    return textView;
}


@end
