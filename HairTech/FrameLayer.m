//
//  CAShapeLayer+FrameLayer.m
//  hairtech
//
//  Created by Alexander Prent on 19.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "FrameLayer.h"

@implementation  FrameLayer

- (instancetype)init:(CGPoint)point {
    if (self = [super init]) {
        
    }
    return self;
}

+(FrameLayer*)addFrameToPoint:(CGPoint)point  endPoint:(CGPoint)endPoint scaleFactor:(CGFloat)scaleFactor
{
    
    CGFloat hypot = [self distanceBetweenStartPoint:point endPoint:endPoint];
    hypot = hypot * 2;
    hypot = hypot * hypot;
    hypot = hypot / 2;
    hypot = sqrt(hypot);

    NSLog(@"diagonal %f", hypot);

    FrameLayer * layer = [[[self class] alloc] init];
    CGRect rect = CGRectMake(point.x-(hypot /2), point.y-(hypot/2), hypot , hypot);
    
    UIBezierPath *framePath=[UIBezierPath bezierPath];
    framePath = [UIBezierPath bezierPathWithRect:rect];
    [framePath stroke];
    layer.path = framePath.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.opacity = 1.0;
    layer.lineWidth = 1.0 / scaleFactor;
    layer.strokeColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;

//    layer.shadowRadius = 1.0;
//    layer.shadowOpacity = 0.6;
//    layer.shadowOffset = CGSizeMake(0,0);
//    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    return layer;
}


+(FrameLayer*)addFrameToText:(CGPoint)point size:(CGRect)frame scaleFactor:(CGFloat)scaleFactor{
    FrameLayer * layer = [[[self class] alloc] init];

    CGRect rect = CGRectMake(point.x, point.y, frame.size.width , frame.size.height);
    NSLog(@"start point text frame x,y = %f, %f", point.x, point.y);

    UIBezierPath *framePath = [UIBezierPath bezierPath];
    framePath = [UIBezierPath bezierPathWithRect:rect];
    [framePath stroke];
    layer.path = framePath.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.opacity = 1.0;
    layer.lineWidth = 1.0 / scaleFactor;
    layer.strokeColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;

    return layer;
}

+ (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
  
    CGFloat xDist = (endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    return  hypot((xDist), (yDist));
}

@end
