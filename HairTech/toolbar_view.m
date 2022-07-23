//
//  toolbar.m
//  hairtech
//
//  Created by Lion on 6/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "toolbar_view.h"
#import <QuartzCore/QuartzCore.h>



@implementation toolbar_view

- (void)drawRect:(CGRect)rect {
   // UIImage *image = [UIImage imageNamed: @"toolbar.png"];
    
    //[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIColor *fillColor =  [UIColor colorWithRed:101.0/255.0 green:149.0/255.0 blue:217.0/255.0 alpha:1.0];

    self.backgroundColor = fillColor;
    
}


@end


