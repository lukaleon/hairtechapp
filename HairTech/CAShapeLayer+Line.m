//
//  CAShapeLayer+Line.m
//  hairtech
//
//  Created by Alexander Prent on 02.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "CAShapeLayer+Line.h"

@implementation Line
@dynamic  startPoint;
@dynamic  endPoint;




- (id)init {
    if ((self = [super init])) {
        self.fillColor = [UIColor blueColor].CGColor;
        arrayOfCircles = [NSMutableArray array];
    
    }
    return self;
}

-(void)drawCirclesX:(CGFloat)x circleY:(CGFloat)y currentLayer:(CAShapeLayer*)topLayer {
    
    CAShapeLayer * circlePoints = [CAShapeLayer layer];
    circlePoints.name = @"circle";
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x,y,6, 6)];

    circlePoints.path=circlePath.CGPath;
    circlePoints.fillColor =[UIColor colorWithRed:4.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f].CGColor;
    circlePoints.opacity = 1.0;
    circlePoints.lineWidth=1;
    circlePoints.strokeColor = [UIColor whiteColor].CGColor;
    
    circlePoints.shadowColor = [UIColor grayColor].CGColor;
    circlePoints.shadowOffset = CGSizeMake(0.1f, 0.1f);
    circlePoints.shadowRadius = 0.4f;
   circlePoints.shadowOpacity = 0.6f;
    [self addSublayer:circlePoints];
    [arrayOfCircles addObject:circlePoints];
    [self.superlayer insertSublayer:circlePoints above:[self.superlayer.sublayers lastObject]];

    
}
-(void)removeCircles{
    
    [arrayOfCircles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [arrayOfCircles removeAllObjects];
}

-(BOOL) pointInside:(CGPoint)point path:(CGPathRef)newPath
{
   
    
    CGRect tmpFrame = CGPathGetBoundingBox(newPath);
    CGRect biggerFrame = CGRectMake(tmpFrame.origin.x-2,
                                    tmpFrame.origin.y-2,
                                    tmpFrame.size.width+5,
                                    tmpFrame.size.height+5);
                                    
    CGPathRef newCG =  CGPathCreateWithRect(biggerFrame, NULL);
    return CGPathContainsPoint(newCG, 0, point, YES);
    
    
    
    /*
    
    
    
    // CGRect newArea = CGRectMake(self.bounds.origin.x - 5, self.bounds.origin.y - 5, self.bounds.size.width + 10, self.bounds.size.height + 10);
    
    CGRect newArea = CGRectMake(newArea.origin.x-5 , newArea.origin.y- 5, newArea.size.width + 10, newArea.size.height + 10);
    
    Ui
    
  // linePath = CGPathCreateWithRect(newArea, NULL);
    return CGRectContainsPoint(newArea, point);
    
    return CGPathContainsPoint(path, 0, point, YES);
*/
}



@end
