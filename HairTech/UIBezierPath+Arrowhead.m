//
//  NSObject+ArrowPath.m
//  hairtech
//
//  Created by Alexander Prent on 25.02.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "UIBezierPath+Arrowhead.h"

@implementation Arrowhead

- (void)addArrowheadToPoint:(CGPoint)endPoint tipLength:(CGFloat)tipLength tipAngle:(CGFloat)tipAngle {
    CGFloat angle = atan2(self.currentPoint.y - endPoint.y, self.currentPoint.x - endPoint.x);
    CGPoint tipPoint1 = CGPointMake(endPoint.x + tipLength * cos(angle + tipAngle), endPoint.y + tipLength * sin(angle + tipAngle));
    CGPoint tipPoint2 = CGPointMake(endPoint.x + tipLength * cos(angle - tipAngle), endPoint.y + tipLength * sin(angle - tipAngle));
    [self addLineToPoint:tipPoint1];
    [self addLineToPoint:endPoint];
    [self addLineToPoint:tipPoint2];
}

@end

