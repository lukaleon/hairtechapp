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

+(CircleLayer*)addZoomToFrame:(CGPoint)point scaleFactor:(CGFloat)scaleFactor
{
    CircleLayer * layer = [[[self class] alloc] init];

    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-7 / scaleFactor   , point.y-7 / scaleFactor , 14 / scaleFactor, 14 / scaleFactor )];
    
    CGPoint upperPoint = CGPointMake(point.x - 4 / scaleFactor,  point.y - 4 / scaleFactor);
    CGPoint lowerPoint = CGPointMake(point.x + 4 / scaleFactor, point.y + 4 / scaleFactor);

    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:CGPointMake(upperPoint.x, upperPoint.y + 4 / scaleFactor)];
    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:CGPointMake(upperPoint.x + 4 / scaleFactor, upperPoint.y)];
    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:lowerPoint];
    [circlePath addLineToPoint:CGPointMake(lowerPoint.x - 4 / scaleFactor, lowerPoint.y)];
    [circlePath moveToPoint:lowerPoint];
    [circlePath addLineToPoint:CGPointMake(lowerPoint.x, lowerPoint.y - 4 / scaleFactor)];
    [circlePath stroke];
    circlePath.lineWidth = 1 / scaleFactor;

    
    
    layer.path = circlePath.CGPath;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.opacity = 1;
    layer.lineWidth = 1 / scaleFactor ;
    layer.strokeColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;
//    layer.shadowRadius = 1.0;
//    layer.shadowOpacity = 0.6;
//    layer.shadowOffset = CGSizeMake(0,0);
//    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
    return layer;
}
//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize scale:(CGFloat)scale {
//    
//    CGSize scaledSize = CGSizeMake(newSize.width * scale, newSize.height * scale);
//    NSLog(@"zooming scale");
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


@end
