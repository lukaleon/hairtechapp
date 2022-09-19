//
//  JVDrawingLayer.m
//  JVDrawingBoard
//
//  Created by AVGD-Jarvi on 17/4/2.
//  Copyright © 2017年 Jarvi. All rights reserved.
//

#import "JVDrawingLayer.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


#define JVDRAWINGPATHWIDTH 2
#define JVDRAWINGBUFFER 16
#define JVDRAWINGORIGINCOLOR [UIColor blackColor].CGColor
#define JVDRAWINGSELECTEDCOLOR [UIColor redColor].CGColor
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface JVDrawingLayer ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint controlPointOfCurve;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableArray *trackArray;
@property (nonatomic, assign) BOOL editedLine;
//@property (nonatomic, assign) NSString * text;

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
        self.editedLine = NO;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
}

- (BOOL)isPoint:(CGPoint)p withinDistance:(CGFloat)distance ofPath:(CGPathRef)path
{
  
    CGPathRef hitPath = CGPathCreateCopyByStrokingPath(path, NULL, distance*2, kCGLineCapRound, kCGLineJoinRound, 0);
    BOOL isWithinDistance = CGPathContainsPoint(hitPath, NULL, p, false);
    CGPathRelease(hitPath);
  //  NSLog(@"IS WITHIN DISTANCE %d", isWithinDistance);
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
        //self.midP = midPoint(self.startPoint, self.endPoint);
        
        
        
        if (self.type == JVDrawingTypeCurvedLine || self.type == JVDrawingTypeCurvedDashLine) {
            if(self.editedLine){
            self.midP = self.controlPointOfCurve;
            } else {
                self.midP = midPoint(self.startPoint, self.endPoint);
            }
                CGFloat distanceStart = [self distanceBetweenStartPoint:point endPoint:self.startPoint];
                CGFloat distanceEnd = [self distanceBetweenStartPoint:point endPoint:self.endPoint];
                CGFloat distanceCtr = [self distanceBetweenStartPoint:point endPoint:self.controlPointOfCurve];
        
                CGFloat diffrence = distanceStart + distanceEnd - distanceCtr;
                if (diffrence <= JVDRAWINGBUFFER || distanceStart <= JVDRAWINGBUFFER || distanceEnd <= JVDRAWINGBUFFER) {
                    CGFloat min = MIN(distanceStart, distanceEnd);
                    if (MIN(min, 2*JVDRAWINGBUFFER) == min) {
                        if (min == distanceStart) return JVDrawingTouchHead;
                        if (min == distanceEnd) return JVDrawingTouchEnd;
                    
                    }
                };
        if ([self distanceBetweenStartPoint:self.controlPointOfCurve endPoint:point] < JVDRAWINGBUFFER)
        return JVDrawingTouchMid;
        
        }
        
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
        layer.startPoint = startPoint;
        layer.strokeColor = line_Color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        
    }
    if (JVDrawingTypeCurvedDashLine == type) {
        layer.startPoint = startPoint;
        layer.strokeColor = line_Color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        [layer setLineDashPattern:
        [NSArray arrayWithObjects:[NSNumber numberWithInt:layer.lineWidth],
        [NSNumber numberWithInt:2+layer.lineWidth],nil]];
    }
    return layer;

}

+ (JVDrawingLayer *)createTextLayerWithStartPoint:(CGPoint)startPoint frame:(CGRect)frame text:(NSString*)text type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color isSelected:(BOOL)isSelected{
    JVDrawingLayer *layer = [[[self class] alloc] init];
    layer.startPoint = startPoint;
    layer.isSelected = isSelected;
    layer.type = type;
    layer.text = text;
    CGRect rect;
    if (IDIOM == IPAD) {
       rect = CGRectMake(frame.origin.x - 0.5 , frame.origin.y + 1 , frame.size.width, frame.size.height); //iPad
    } else {
       rect = CGRectMake(frame.origin.x - 4.5, frame.origin.y + 1, frame.size.width, frame.size.height);
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrsDictionary =
    @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f],
     NSParagraphStyleAttributeName: paragraphStyle};
    CATextLayer *textLayer = [CATextLayer layer];
    layer.frame = rect;
   // NSLog(@"Layer origin %f, %f", layer.bounds.size.width, layer.bounds.size.height );
    textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
//    [textLayer setFontSize:15];
//    [textLayer setFont:@"Helvetica"];
    [textLayer setFrame:layer.bounds];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
//    [textLayer setString:text];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setWrapped:YES];
    [textLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    [textLayer setMasksToBounds:YES];
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.fillColor = [[UIColor clearColor]CGColor];
    //adding lines to path to detect tap
    int step = 0;
    for(int i=1;i<=rect.size.width/10;i++){
    CGPoint newP = CGPointMake(rect.origin.x + step, rect.origin.y);
    [path moveToPoint:newP];
    [path addLineToPoint:CGPointMake(rect.origin.x + step, rect.origin.y + rect.size.height)];
    step = step + 10;
    }
    layer.path = path.CGPath;
   // NSLog(@"text origin %f, %f", textLayer.bounds.size.width, textLayer.bounds.size.height );
    [layer addSublayer:textLayer];
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
    // self.controlPointOfCurve = currentPoint;
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
            [self moveCurvedLinePathWithStartPoint:startPoint endPoint:endPoint midPoint:self.controlPointOfCurve isSelected:isSelected];
            break;
        case JVDrawingTypeCurvedDashLine:
            [self moveCurvedLinePathWithStartPoint:startPoint endPoint:endPoint midPoint:self.controlPointOfCurve isSelected:isSelected];
            break;
        case JVDrawingTypeGraffiti:
            [self moveGraffitiPathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
            break;
        case JVDrawingTypeText:
            [self moveLinePathWithStartPoint:startPoint endPoint:endPoint isSelected:isSelected];
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
//    if (self.type == JVDrawingTypeCurvedLine) {
//        [trackDic setObject:NSStringFromCGPoint(self.controlPointOfCurve) forKey:@"controlPoint"];
//
//    }
    [trackDic setObject:NSStringFromCGPoint(self.endPoint) forKey:@"endPoint"];
    [trackDic setObject:@(self.isSelected) forKey:@"isSelected"];
    [trackDic setObject:@(self.type) forKey:@"type"];
    [self.trackArray addObject:trackDic];    
}

- (BOOL)revokeUntilHidden {
    if (self.trackArray.count!=1) {
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
    }
    return YES;
}

//-(void)moveTextWithStartPoint:(CGPoint)startPoint ofRect:(CGRect)rect{
//    NSLog(@"Move text");
//
//    CGRect txtRect = CGRectMake(startPoint.x, startPoint.y, rect.size.width, rect.size.height);
//    UIBezierPath *textRect=[UIBezierPath bezierPath];
//    textRect = [UIBezierPath bezierPathWithRect:txtRect];
//    self.path = textRect.CGPath;
//
//
//}

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

- (UIBezierPath *)createCurvedLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  midPoint:(CGPoint)midPt length:(CGFloat)length {
    NSLog(@"create curved line ");
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:midPoint(startPoint, endPoint)];
    self.controlPointOfCurve = midPoint(startPoint, endPoint);
    return path;
    
}

- (UIBezierPath *)editCurvedLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  midPoint:(CGPoint)midPt length:(CGFloat)length {
   
    NSLog(@"edit curved line ");
    CGPoint newPoint1;
    CGPoint newPoint2;
    newPoint1 = midPoint(startPoint, endPoint);
    newPoint2 = midPt;
    float distanceFromPx2toP3 = [self distanceBetweenStartPoint:newPoint1 endPoint:newPoint2];
    float mag = sqrt(pow((newPoint2.x - newPoint1.x),2) + pow((newPoint2.y - newPoint1.y),2));
    float P3x = newPoint2.x + distanceFromPx2toP3 * (newPoint2.x - newPoint1.x) / mag;
    float P3y = newPoint2.y + distanceFromPx2toP3 * (newPoint2.y - newPoint1.y) / mag;

    CGPoint  P3 = CGPointMake(P3x, P3y);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:P3];
    self.controlPointOfCurve = midPt;
//    CGPoint test = midPoint(newPoint1, P3);
//    if (self.controlPointOfCurve.x != test.x && self.controlPointOfCurve.y != test.y) {
//        self.controlPointOfCurve = test;
//    }
    self.midPmoving = self.controlPointOfCurve;
    self.midP = self.controlPointOfCurve;
    self.editedLine = YES;
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
        
        dist = self.lineWidth+(distance/6);
        NSLog(@"dist = %f", dist);
    }
    else{
        dist = self.lineWidth+3;
    }
   
        CGFloat distanceX = dist * (ABS(endPoint.x - startPoint.x) / distance);
        CGFloat distanceY = dist * (ABS(endPoint.y - startPoint.y) / distance);
        CGFloat distX = dist/2.4 * (ABS(endPoint.y - startPoint.y) / distance);
        CGFloat distY = dist/2.4 * (ABS(endPoint.x - startPoint.x) / distance);
    
    
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
