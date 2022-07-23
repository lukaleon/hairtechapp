
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


#if __has_feature(objc_arc)
#define ACE_HAS_ARC 1
#define ACE_RETAIN(exp) (exp)
#define ACE_RELEASE(exp)
#define ACE_AUTORELEASE(exp) (exp)
#else
#define ACE_HAS_ARC 0
#define ACE_RETAIN(exp) [(exp) retain]
#define ACE_RELEASE(exp) [(exp) release]
#define ACE_AUTORELEASE(exp) [(exp) autorelease]
#endif


@protocol ACEDrawingTool <NSObject>

CGPoint midsPoint(CGPoint p1, CGPoint p2);

@property (nonatomic, strong) UIColor *arrowColor;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *eraserColor;

@property (nonatomic, strong) UIColor *dashlineColor;
@property (nonatomic, strong) UIColor *penColor;
@property (nonatomic, assign) CGFloat penWidth;

@property (nonatomic, assign) CGFloat dashlineWidth;
@property (nonatomic, assign) CGFloat lineWidthNew;
@property (nonatomic, assign) CGFloat eraserWidth;
//@property (nonatomic, assign) CGFloat arrowWidth;



@property (nonatomic, assign) CGSize bounds1;

@property (nonatomic, strong) NSString *textFromView;
//@property (nonatomic, assign) CGFloat lineAlpha;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
-(void)getTextFromView:(NSString*)text;
-(void)boundsOfTextView:(CGSize)bounds;
- (void)draw;

-(void)hideLines:(CGContextRef*)ctx;
-(void)showLines:(CGContextRef*)ctx;


@property (nonatomic,assign) CGPoint a;
@property (nonatomic,assign) CGPoint b;
@property (nonatomic,assign) CGPoint c;
@property (nonatomic,assign) CGPoint d;


@property (nonatomic,assign) CGPoint a1;
@property (nonatomic,assign) CGPoint b1;
@property (nonatomic,assign) CGPoint c1;
@property (nonatomic,assign) CGPoint d1;


@property (nonatomic, assign) CGFloat lineWidthInStock;



- (void)draw2;
-(void)draw3;

@end



#pragma mark -

@interface ACEDrawingPenTool : UIBezierPath<ACEDrawingTool>

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint stPoint;
@property (nonatomic, assign) CGPoint ndPoint;


@end
#pragma mark -
@interface ACEDrawingCurveTool : UIBezierPath<ACEDrawingTool>
//@interface ACEDrawingCurveTool : NSObject<ACEDrawingTool>



@end

#pragma mark -

@interface ACEDrawingDashCurveTool : UIBezierPath<ACEDrawingTool>



@end

#pragma mark -

@interface ACEDrawingDashLineTool : UIBezierPath<ACEDrawingTool>
@end
#pragma mark -

@interface ACEDrawingArrowTool : NSObject<ACEDrawingTool>

@end
#pragma mark -

@interface ACEDrawingLineTool : NSObject<ACEDrawingTool>

@end
#pragma mark -

@interface ACEDrawingEraserTool : UIBezierPath<ACEDrawingTool>

@end

#pragma mark -

@interface ACEDrawingTextTool : NSObject<ACEDrawingTool>


@end

