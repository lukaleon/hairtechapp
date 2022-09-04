//
//  TextView.m
//  hairtech
//
//  Created by Lion on 6/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
//        self.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:0.1] ;
//        self.layer.borderWidth = 1.0f;
//         self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self.layer setCornerRadius:5.0f];
//        self.layer.borderColor=[[UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0] CGColor];
        
        self.backgroundColor = [UIColor yellowColor];
        self.text = @"Text";

        
        //        self.layer.borderWidth = 1.0f;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
@end
