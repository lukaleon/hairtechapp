//
//  JVDrawingLayer.m
//  JVDrawingBoard
//
//  Created by AVGD-Jarvi on 17/4/2.
//  Copyright © 2017年 Jarvi. All rights reserved.
//

#import "JVDrawingLayer.h"
#import <UIKit/UIKit.h>

#define JVDRAWINGPATHWIDTH 2
#define JVDRAWINGBUFFER 10
#define JVDRAWINGORIGINCOLOR [UIColor blackColor].CGColor
#define JVDRAWINGSELECTEDCOLOR [UIColor redColor].CGColor

@interface JVDrawingLayer ()
@property (nonatomic, assign) CGRect controlP1;
@property (nonatomic, assign) CGRect controlP2;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint controlPointOfCurve;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableArray *trackArray;

@end

@implementation JVDrawingLayer 

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        self.isSelected = NO;
        self.isVisible = NO;
        self.trackArray = [[NSMutableArray alloc] init];
        self.arrayOfCircles = [NSMutableArray array];
        
        
    }
    return self;
}

//-(void)addCircle:(CAShapeLayer*)circle toPoint:(CGPoint)point
//{
//    NSLog(@"ADD CIRCLE LAAYER");
//    circle = [CAShapeLayer layer];
//    UIBezierPath *circlePath=[UIBezierPath bezierPath];
//    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-4, point.y-4, 8, 8)];
//    circle.path=circlePath.CGPath;
//    circle.fillColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;
//    circle.opacity = 1.0;
//    circle.strokeColor = [UIColor whiteColor].CGColor;
//    circle.shadowRadius = 1.0;
//    circle.shadowOpacity = 0.6;
//    circle.shadowOffset = CGSizeMake(0,0);
//    circle.shadowColor = [UIColor darkGrayColor].CGColor;
//    circle.zPosition = 10;
//    [self addSublayer:circle];
//    [self.arrayOfCircles addObject:circle];
//
//}
//
//-(void)circlePosition:(CGPoint)point atIndex:(int)idx{
//    UIBezierPath *circlePath=[UIBezierPath bezierPath];
//    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-4, point.y-4, 8, 8)];
//    CAShapeLayer *layer =  [CAShapeLayer layer];
//    layer =  [self.arrayOfCircles objectAtIndex:idx];
//    layer.path=circlePath.CGPath;
//}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;

//    if (isSelected && JVDrawingTypeGraffiti != self.type)
//    {
//        if( self.isVisible == NO ){
//            
//            [self addCircle:self.circle1 toPoint:self.startPoint];
//            [self addCircle:self.circle2 toPoint:self.endPoint];
//       
//
//            self.isVisible = YES;
//            NSLog(@"Adding circles");
//
//        }
//        else
//        {
//            NSLog(@"Array of circles count %lu", self.arrayOfCircles.count);
//
//            NSLog(@"startPoint X Y %f %f",self.startPoint.x, self.startPoint.y );
//            [self circlePosition:self.startPoint atIndex:0];
//            [self circlePosition:self.endPoint atIndex:1];
//            NSLog(@"Moving lines & circles");
//
//        }
//    }
//    else
//    {
//        
//        if( self.isVisible == YES &&  JVDrawingTypeGraffiti != self.type ){
//                [self.arrayOfCircles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//                 [self.arrayOfCircles removeAllObjects];
//                self.isVisible = NO;
//                NSLog(@"Array of circles count %lu", self.arrayOfCircles.count);
//
//        }
//
//    }
}

- (BOOL)isPoint:(CGPoint)p withinDistance:(CGFloat)distance ofPath:(CGPathRef)path
{
    CGPathRef hitPath = CGPathCreateCopyByStrokingPath(path, NULL, distance*2, kCGLineCapRound, kCGLineJoinRound, 0);
    BOOL isWithinDistance = CGPathContainsPoint(hitPath, NULL, p, false);
    CGPathRelease(hitPath);
    NSLog(@"IS WITHIN DISTANCE %d", isWithinDistance);
    return isWithinDistance;
}

- (BOOL)isLocateDrawingLayerWithPoint:(CGPoint)point {
    CGFloat distanceStart = [self distanceBetweenStartPoint:point endPoint:self.startPoint];
    CGFloat distanceEnd = [self distanceBetweenStartPoint:point endPoint:self.endPoint];
    CGFloat distance = [self distanceBetweenStartPoint:self.startPoint endPoint:self.endPoint];
    CGFloat diffrence = distanceStart + distanceEnd - distance;
    return diffrence <= JVDRAWINGBUFFER  || distanceStart <= JVDRAWINGBUFFER || distanceEnd <= JVDRAWINGBUFFER;
}

- (NSInteger)caculateLocationWithPoint:(CGPoint)point {
    if (self.type == JVDrawingTypeGraffiti) {
        BOOL result = NO;
        for (NSValue *pointValue in self.pointArray) {
            CGPoint pathPoint = [pointValue CGPointValue];
            if ([self distanceBetweenStartPoint:pathPoint endPoint:point] < JVDRAWINGBUFFER) {
                result = YES;
            }
        }
        return result;
    } else {
        self.startP = self.startPoint;
        self.endP = self.endPoint;
        self.midP = midPoint(self.startPoint, self.endPoint);
        CGFloat distanceStart = [self distanceBetweenStartPoint:point endPoint:self.startPoint];
        CGFloat distanceEnd = [self distanceBetweenStartPoint:point endPoint:self.endPoint];
        CGFloat distance = [self distanceBetweenStartPoint:self.startPoint endPoint:self.endPoint];
        CGFloat diffrence = distanceStart + distanceEnd - distance;
        if (diffrence <= JVDRAWINGBUFFER || distanceStart <= JVDRAWINGBUFFER || distanceEnd <= JVDRAWINGBUFFER) {
            CGFloat min = MIN(distanceStart, distanceEnd);
            if (MIN(min, 2*JVDRAWINGBUFFER) == min) {
                if (min == distanceStart) return JVDrawingTouchHead;
                if (min == distanceEnd) return JVDrawingTouchEnd;
            } else {
                return JVDrawingTouchMid;
            }
        };
    }
    
    return NO;
}

+ (JVDrawingLayer *)createLayerWithStartPoint:(CGPoint)startPoint type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color{
    NSLog(@"Creating Layer");
    JVDrawingLayer *layer = [[[self class] alloc] init];
    layer.startPoint = startPoint;
    layer.type = type;
    layer.lineWidth = line_Width;
    layer.strokeColor = layer.fillColor = line_Color.CGColor;
    if (JVDrawingTypeGraffiti == type) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineJoinStyle = kCGLineJoinRound;
        path.flatness = 0.1;
        [path moveToPoint:startPoint];
        layer.path = path.CGPath;
        layer.pointArray = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:startPoint]];
    }
    if (JVDrawingTypeDashedLine == type) {
        [layer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:layer.lineWidth],
          [NSNumber numberWithInt:2+layer.lineWidth],nil]];
    }
    if (JVDrawingTypeCurvedLine == type) {
        layer.strokeColor = line_Color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        
    }
    return layer;

}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    [self movePathWithEndPoint:endPoint isSelected:self.isSelected];

    
}

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    [self movePathWithStartPoint:startPoint isSelected:self.isSelected];
    
}

- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint {
    CGPoint startPoint = CGPointMake(self.startPoint.x+currentPoint.x-previousPoint.x, self.startPoint.y+currentPoint.y-previousPoint.y);
    CGPoint endPoint = CGPointMake(self.endPoint.x+currentPoint.x-previousPoint.x, self.endPoint.y+currentPoint.y-previousPoint.y);
    [self movePathWithStartPoint:startPoint endPoint:endPoint type:self.type isSelected:self.isSelected];
}

- (void)movePathWithStartPoint:(CGPoint)startPoint isSelected:(BOOL)isSelected {
    [self movePathWithStartPoint:startPoint endPoint:self.endPoint type:self.type isSelected:isSelected];
   
}

- (void)movePathWithEndPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected{
    [self movePathWithStartPoint:self.startPoint endPoint:endPoint type:self.type isSelected:isSelected];
   
}

- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint isSelected:(BOOL)isSelected {
    CGPoint startPoint = CGPointMake(self.startPoint.x+currentPoint.x-previousPoint.x, self.startPoint.y+currentPoint.y-previousPoint.y);
    CGPoint endPoint = CGPointMake(self.endPoint.x+currentPoint.x-previousPoint.x, self.endPoint.y+currentPoint.y-previousPoint.y);
    [self movePathWithStartPoint:startPoint endPoint:endPoint type:self.type isSelected:isSelected];
}

- (void)moveControlPointWithPreviousPoint:(CGPoint)currentPoint{
   self.midPmoving = currentPoint;

    [self moveCurvedLinePathWithStartPoint:self.startPoint endPoint:self.endPoint midPoint:currentPoint isSelected:self.isSelected];
}

- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint {
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    [path applyTransform:CGAffineTransformMakeTranslation(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)];
    self.path = path.CGPath;
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (NSValue *pointValue in self.pointArray) {
        CGPoint pathPoint = [pointValue CGPointValue];
        pathPoint = CGPointMake(pathPoint.x + currentPoint.x - previousPoint.x, pathPoint.y + currentPoint.y - previousPoint.y);
        NSValue *newPointValue = [NSValue valueWithCGPoint:pathPoint];
        [newArray addObject:newPointValue];
    }
    self.startPoint = [[self.pointArray firstObject] CGPointValue];
    self.pointArray = newArray;
}

- (void)movePathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint type:(JVDrawingType)type isSelected:(BOOL)isSelected {
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.isSelected = isSelected;
    self.startPmoving = startPoint;
    self.endPmoving = endPoint;

    switch (type) {
        case JVDrawingTypeArrow:
            [self moveArrowPathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
            break;
            
        case JVDrawingTypeLine:
            [self moveLinePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
            break;
            
        case JVDrawingTypeDashedLine:
            [self moveDashedLinePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
            break;
            
        case JVDrawingTypeCurvedLine:
            [self moveCurvedLinePathWithStartPoint:startPoint endPoint:endPoint midPoint:self.midPmoving isSelected:isSelected];
            break;
            
        case JVDrawingTypeGraffiti:
            [self moveGraffitiPathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
            break;
        default:
            break;
    }
}

- (void)addToTrack {
    NSMutableDictionary *trackDic = [[NSMutableDictionary alloc] init];
    [trackDic setObject:NSStringFromCGPoint(self.startPoint) forKey:@"startPoint"];
    if (self.type == JVDrawingTypeGraffiti) {
        [trackDic setObject:NSStringFromCGPoint([self.pointArray[0] CGPointValue]) forKey:@"startPoint"];
    }
    [trackDic setObject:NSStringFromCGPoint(self.endPoint) forKey:@"endPoint"];
    [trackDic setObject:@(self.isSelected) forKey:@"isSelected"];
    [trackDic setObject:@(self.type) forKey:@"type"];
    [self.trackArray addObject:trackDic];    
}

- (BOOL)revokeUntilHidden {
    /*if (self.trackArray.count!=1) {
        NSMutableDictionary *trackDic = [self.trackArray objectAtIndex:self.trackArray.count-2];
        CGPoint startPoint = CGPointFromString(trackDic[@"startPoint"]);
        CGPoint endPoint = CGPointFromString(trackDic[@"endPoint"]);
        BOOL isSelected = [trackDic[@"isSelected"] boolValue];
        JVDrawingType type = [trackDic[@"type"] integerValue];
        switch (type) {
            case JVDrawingTypeArrow:
                [self moveArrowPathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
                break;
                
            case JVDrawingTypeLine:
                [self moveLinePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
                break;
                
            case JVDrawingTypeDashedLine:
                [self moveDashedLinePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
                break;
                
            case JVDrawingTypeCurvedLine:
                [self moveCurvedLinePathWithStartPoint:startPoint endPoint:endPoint midPoint:self.midPmoving isSelected:isSelected];
                break;
                
            case JVDrawingTypeGraffiti:
                [self moveGrafiitiPathPreviousPoint:self.startPoint currentPoint:startPoint];
                break;
                
            default:
                break;
        }
        
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.isSelected = isSelected;
        self.type = type;
        [self.trackArray removeLastObject];
        return NO;
    }*/
    return YES;
}

- (void)moveArrowPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path appendPath:[self createArrowWithStartPoint:startPoint endPoint:endPoint]];
    self.path = path.CGPath;
}
#pragma mark Select and Move Line Methods

- (void)moveLinePathWithStartPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint
                        isSelected:(BOOL)isSelected {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path stroke];
    self.path = path.CGPath;
}

#pragma mark Select and Move Arrow Methods

- (void)moveCurvedLinePathWithStartPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint
                                midPoint:(CGPoint)midPt
                              isSelected:(BOOL)isSelected {
    NSLog(@"isSelected %d", isSelected);

    if (isSelected) {

        self.path = [self editCurvedLineWithStartPoint:startPoint endPoint:endPoint midPoint:midPt length:0].CGPath;
    }
    else {
        self.path = [self createCurvedLineWithStartPoint:startPoint endPoint:endPoint midPoint:midPt length:0].CGPath;
    }
}

- (void)moveDashedLinePathWithStartPoint:(CGPoint)startPoint
                               endPoint:(CGPoint)endPoint
                             isSelected:(BOOL)isSelected {
    self.path = [self createDashedLinePathWithEndPoint:endPoint andStartPoint:startPoint length:0].CGPath;
}


- (void)moveGraffitiPathWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                            isSelected:(BOOL)isSelected {
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    [path addLineToPoint:endPoint];
    [path moveToPoint:endPoint];
    self.path = path.CGPath;
    [self.pointArray addObject:[NSValue valueWithCGPoint:endPoint]];
}

- (UIBezierPath *)createDashedLinePathWithEndPoint:(CGPoint)endPoint andStartPoint:(CGPoint)startPoint length:(CGFloat)length
{
    NSLog(@"Drawing dashed line");
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path  moveToPoint:startPoint]; //add yourStartPoint here
    [path addLineToPoint:endPoint];// add yourEndPoint here
    [path setLineCapStyle:kCGLineCapRound];
    return path;
}
CGPoint midPoint(CGPoint p1,CGPoint p2)
{
    return CGPointMake ((p1.x + p2.x) * 0.5,(p1.y + p2.y) * 0.5);
}

CGPoint P01Point(CGPoint startPoint,CGPoint midPoint)
{
    return CGPointMake ((startPoint.x + midPoint.x) * 0.5,(startPoint.y + midPoint.y) * 0.5);
}
CGPoint P12Point(CGPoint startPoint,CGPoint midPoint)
{
    return CGPointMake ((startPoint.x + midPoint.x) * 0.5,(startPoint.y + midPoint.y) * 0.5);
}

CGPoint P012Point(CGPoint p01,CGPoint p12)
{
    return CGPointMake ((p01.x + p12.x) * 0.5,(p01.y + p12.y) * 0.5);
}

- (UIBezierPath *)createCurvedLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  midPoint:(CGPoint)midPt length:(CGFloat)length {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:midPoint(startPoint, endPoint)];
    return path;
    
}

- (UIBezierPath *)editCurvedLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  midPoint:(CGPoint)midPt length:(CGFloat)length {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:P012Point(P01Point(startPoint, midPt), P12Point(endPoint, midPt)) controlPoint2:P012Point(P01Point(startPoint, midPt), P12Point(endPoint, midPt))];
    
    
//    [path addQuadCurveToPoint:endPoint controlPoint:P012Point(P01Point(startPoint, midPt), P12Point(endPoint, midPt))];
    self.controlPoint = P012Point(P01Point(startPoint, midPt), P12Point(endPoint, midPt));
    return path;
}

- (UIBezierPath *)createArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    NSLog(@"Drawing arrow");
    
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat dist = 0;
    CGFloat distance = [self distanceBetweenStartPoint:startPoint endPoint:endPoint];
    if (distance < 22) {
        
        dist = self.lineWidth+(distance/5);
        NSLog(@"dist = %f", dist);
    }
    else{
        dist = self.lineWidth+4.4;
    }
   
        CGFloat distanceX = dist * (ABS(endPoint.x - startPoint.x) / distance);
        CGFloat distanceY = dist * (ABS(endPoint.y - startPoint.y) / distance);
        CGFloat distX = dist/2 * (ABS(endPoint.y - startPoint.y) / distance);
        CGFloat distY = dist/2 * (ABS(endPoint.x - startPoint.x) / distance);
    
    
    if (endPoint.x >= startPoint.x)
    {
        if (endPoint.y >= startPoint.y)
        {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
    }
    else
    {
        if (endPoint.y >= startPoint.y)
        {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
    }
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:endPoint];
    [arrowPath addLineToPoint:pointDown];
    [arrowPath addLineToPoint:pointUp];
    [arrowPath addLineToPoint:endPoint];
    return arrowPath;
}

- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGFloat xDist = (endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(dy, dx);
    return angle;
}

- (CGFloat)angleEndWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(fabs(dy), fabs(dx));
    if (dx*dy>0) {
        return M_PI-angle;
    }
    return angle;
}

@end
