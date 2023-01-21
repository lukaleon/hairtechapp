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

+(FrameLayer*)addCircleToPoint:(CGPoint)point  endPoint:(CGPoint)endPoint scaleFactor:(CGFloat)scaleFactor
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
    layer.strokeColor = [UIColor colorNamed:@"deepblue"].CGColor;
    layer.shadowRadius = 1.0;
    layer.shadowOpacity = 0.6;
    layer.shadowOffset = CGSizeMake(0,0);
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    return layer;
}

+ (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
  
    CGFloat xDist = (endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    return  hypot((xDist), (yDist));
}

@end
