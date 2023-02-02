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
    JVDrawingTypeText,
    JVDrawingTypeDot,
    JVDrawingTypeClipper,
    JVDrawingTypeRazor,
};

typedef NS_ENUM(NSInteger, JVDrawingTouch) {
    JVDrawingTouchHead = 1,     //点击头部
    JVDrawingTouchMid,          //点击中部
    JVDrawingTouchEnd           //点击尾部
};

@interface JVDrawingLayer : CAShapeLayer{
    
    int JVDRAWINGBUFFERFORCURVE;
    int JVDRAWINGBUFFERFORLINE;
    CGFloat _zoomIndex;


}

@property (nonatomic, assign) CALayer *imageLayer;

-(void)setZoomIndex:(CGFloat)zoom;
@property (nonatomic, assign) NSMutableArray * arrayOfLayerPoints;
@property (nonatomic, assign) CGPoint startPointToConnect;
@property (nonatomic, assign) CGPoint endPointToConnect;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint endP;
@property (nonatomic, assign) CGPoint midP;
@property (nonatomic, assign) NSString *text;

@property (nonatomic, assign) CGPoint startPmoving;
@property (nonatomic, assign) CGPoint endPmoving;
@property (nonatomic, assign) CGPoint midPmoving;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint controlPointOfCurve;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) JVDrawingType type;
@property (nonatomic, assign) CGFloat lineWidth_;
@property (nonatomic, strong) UIColor * lineColor_;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


@property (nonatomic, assign) CGPoint dotCenter;




@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) NSMutableArray *arrayOfCircles;
@property  (nonatomic, assign )CGFloat zoomFactor;


@property (nonatomic, assign) CAShapeLayer *circle1;
@property (nonatomic, assign) CAShapeLayer *circle2;

-(void)addCircleToPoint:(CGPoint)point;

-(CGPoint)getStartPointOfLayer:(JVDrawingLayer *)layer;
-(CGPoint)getEndPointOfLayer:(JVDrawingLayer *)layer;

+ (JVDrawingLayer *)createLayerWithStartPoint:(CGPoint)startPoint type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color;

+ (JVDrawingLayer *)createTextLayerWithStartPoint:(CGPoint)startPoint frame:(CGRect)frame text:(NSString*)text  type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color fontSize:(CGFloat)fontSize  isSelected:(BOOL)isSelected ;

+ (JVDrawingLayer *)createAllLayersAtStart:(CGPoint)startPoint endPoint:(CGPoint)endPoint type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color controlPoint:(CGPoint)controlPoint grafittiPoints:(NSArray*)grafittiPoints;

+ (JVDrawingLayer *)createDotWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint height:(CGFloat)height  type:(JVDrawingType)type lineWidth:(CGFloat)line_Width lineColor:(UIColor*)line_Color scale:(CGFloat)scaleFactor imageName:(NSString*)imgName;

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

- (void)moveTextWithStartPoint:(CGPoint)startPoint ofRect:(CGRect)rect;
- (void)moveTextWithEndPoint:(CGPoint)startPoint;
- (void)moveGrafiitiPathPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;
- (void)addToTrack;
- (BOOL)revokeUntilHidden;
- (BOOL)isPoint:(CGPoint)p withinDistance:(CGFloat)distance ofPath:(CGPathRef)path;
- (BOOL)isPoint:(CGPoint)p  ofPath:(CGPathRef)path;
- (NSMutableDictionary*)addLayerInfoToDict;
- (void)moveCurvedLinePathWithStartPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint
                                midPoint:(CGPoint)midPt
                              isSelected:(BOOL)isSelected;
- (void)redrawCurvedLineStartPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint
                          midPoint:(CGPoint)midPt;



//- (void)moveDotPathWithStartPoint:(CGPoint)previousPoint
                        //  endPoint:(CGPoint)currentPoint
//isSelected:(BOOL)isSelected;

- (void)moveDotPathWithPreviousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint;

- (void)zoomDotPathWithStartPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint
isSelected:(BOOL)isSelected;

- (void)zoomDotPathWithEndPoint:(CGPoint)endPoint;
- (void)zoomDotPathWithEndPoint:(CGPoint)endPoint isSelected:(BOOL)isSelected;
- (void)zoomDotPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint type:(JVDrawingType)type isSelected:(BOOL)isSelected;
- (void)setNewColor:(UIColor*)color;
@end
