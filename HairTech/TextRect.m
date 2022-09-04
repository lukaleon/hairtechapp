//
//  CAShapeLayer+textRect.m
//  hairtech
//
//  Created by Alexander Prent on 03.09.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "TextRect.h"

@implementation TextRect

- (instancetype)init:(CGPoint)point {
    if (self = [super init]) {
        
    }
    return self;
}


+(TextRect*)addRect:(CGRect)rect centerPoint:(CGPoint)centerPoint
{
    
    NSLog(@" %f %f", rect.size.width, rect.size.height);
    TextRect * layer = [[[self class] alloc] init];
    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithRect:rect];
//    layer.frame = rect;
    layer.path=circlePath.CGPath;
//    layer.position = centerPoint;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.opacity = 1.0;
    layer.lineWidth = 1.0;
    layer.strokeColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;
   // layer.shadowRadius = 1.0;
    //layer.shadowOpacity = 0.6;
    //layer.shadowOffset = CGSizeMake(0,0);
    //layer.shadowColor = [UIColor darkGrayColor].CGColor;
   // [self.arrayOfCircles addObject:circle];
    return layer;
}
@end
