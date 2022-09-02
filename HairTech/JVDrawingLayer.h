//
//  JVDrawingLayer.h
//  JVDrawingBoard
//
//  Created by AVGD-Jarvi on 17/4/2.
//  Copyright © 2017年 Jarvi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, JVDrawingType) {
    JVDrawingTypeArrow = 0,
    JVDrawingTypeLine,
    JVDrawingTypeCurvedLine,
    JVDrawingTypeCurvedDashLine,
    JVDrawingTypeDashedLine,
    JVDrawingTypeGraffiti,
    
};

typedef NS_ENUM(NSInteger, JVDrawingTouch) {
    JVDrawingTouchHead = 1,     //点击头部
    JVDrawingTouchMid,          //点击中部
    JVDrawingTouchEnd           //点击尾部
};

@interface JVDrawingLayer : CAShapeLayer{
    
   
}
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint endP;
@property (nonatomic, assign) CGPoint midP;




@property (nonatomic, assign) CGPoint startPmoving;
@property (nonatomic, assign) CGPoint endPmoving;
@property (nonatomic, assign) CGPoint midPmoving;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) JVDrawingType type;
@property (nonatomic, assign) CGFloat lineWidth_;
@property (nonatomic, assign) UIColor * lineColor_;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) NSMutableArray *arrayOfCircles;
@property  CGFloat zoomFactor;


@property (nonatomic, assign) CAShapeLayer *circle1;
@property (nonatomic, assign) CAShapeLayer *circle2;

-(void)addCircleToPoint:(CGPoint)point;
+ (JVDrawingLayer *)createLayerWithStartPoint:(CGPoint)startPoint type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color;

- (NSInteger)caculateLocationWithPoint:(CGPoint)point;

- (void)movePathWithStartPoint:(CGPoint)startPoint;
- (void)movePathWithEndPoint:(CGPoint)EndPoint;
- (void)movePathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;
- (void)moveControlPointWithPreviousPoint:(CGPoint)currentPoint;


- (void)movePathWithStartPoint:(CGPoint)startPoint isSelected:(BOOL)isSelected;
- (void)movePathWithEndPoint:(CGPoint)EndPoint isSelected:(BOOL)isSelected;
- (void)movePathWithPreviousPoint:(CGPoint)previousPoint
                     currentPoint:(CGPoint)currentPoint
                       isSelected:(BOOL)isSelected;

- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;

- (void)addToTrack;
- (BOOL)revokeUntilHidden;

- (BOOL)isPoint:(CGPoint)p withinDistance:(CGFloat)distance ofPath:(CGPathRef)path;

@end
