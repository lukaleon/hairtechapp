//
//  CAShapeLayer+Circle.m
//  hairtech
//
//  Created by Alexander Prent on 26.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "CircleLayer.h"

@implementation CircleLayer

- (instancetype)init:(CGPoint)point {
    if (self = [super init]) {
        
    }
    return self;
}

+(CircleLayer*)addCircleToPoint:(CGPoint)point scaleFactor:(CGFloat)scaleFactor
{
    
    CircleLayer * layer = [[[self class] alloc] init];

    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-5 / scaleFactor  , point.y-5 / scaleFactor , 10 / scaleFactor, 10 / scaleFactor )];
    layer.path=circlePath.CGPath;
    layer.fillColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;
    layer.opacity = 1.0;
    layer.lineWidth = 1.0 / scaleFactor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.shadowRadius = 1.0;
    layer.shadowOpacity = 0.6;
    layer.shadowOffset = CGSizeMake(0,0);
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
   // [self.arrayOfCircles addObject:circle];
    return layer;
}



@end
