
#import "ACEDrawingTools.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


 CGPoint midsPoint(CGPoint p1, CGPoint p2)
 {
 return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
 }


#pragma mark - ACEDrawingPenTool

@implementation ACEDrawingPenTool

@synthesize lineColor = _lineColor;
@synthesize textFromView = _textFromView;
@synthesize lineWidthNew = _lineWidthNew;

@synthesize a,b,c,d;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        self.lineJoinStyle =  kCGLineJoinRound;
    }
    return self;
}

-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    
    
    [self moveToPoint:firstPoint];
    self.firstPoint = firstPoint;

    
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    
    
   [self addQuadCurveToPoint:midsPoint(endPoint, startPoint) controlPoint:startPoint];
    
   
}

- (void)draw
{
    [self.lineColor setStroke];
    [self setLineWidth:self.lineWidthNew];

    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle =  kCGLineJoinRound;
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}
-(void)draw3
{
    [self.lineColor setStroke];
    [self setLineWidth:self.lineWidthNew];

    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle =  kCGLineJoinRound;
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];

}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end





 #pragma mark - ACEDrawingCurveTool
 
@implementation ACEDrawingCurveTool

@synthesize textFromView = _textFromView;

@synthesize lineWidthNew = _lineWidthNew;

@synthesize a,b,c,d;

double dist(CGPoint a, CGPoint b) {
	double dx = a.x - b.x;
	double dy = a.y - b.y;
	return sqrt(dx*dx + dy*dy);
}



static const double EPSILON = .005;

CGPoint addPoints(CGPoint a,CGPoint other) {
	return CGPointMake(a.x+other.x, a.y+other.y);
}

CGPoint scalarMult(CGPoint a, double sc) {
	return CGPointMake(a.x*sc, a.y*sc);
}

- (CGPoint)bezier:(double) t // Parameter 0 <= t <= 1
{
    
    
    double s = 1 - t;
	CGPoint AB = addPoints(scalarMult(a,s), scalarMult(b, t));
	CGPoint BC = addPoints(scalarMult(b,s), scalarMult(c, t));
	CGPoint CD = addPoints(scalarMult(c,s), scalarMult(d, t));
	CGPoint ABC = addPoints(scalarMult(AB,s), scalarMult(BC, t));
	CGPoint BCD = addPoints(scalarMult(BC,s), scalarMult(CD, t));
    return addPoints(scalarMult(ABC,s), scalarMult(BCD, t));

}

 @synthesize lineColor = _lineColor;


 - (id)init
 {
 self = [super init];
 if (self != nil) {
 self.lineCapStyle = kCGLineCapRound;
 
 }
 return self;
 }
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    d  = firstPoint;
    //[self moveToPoint:firstPoint]; //add yourStartPoint here
    ///[self addLineToPoint:endPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    c = endPoint;
    
    //  [self addLineToPoint:self.lastPoint];// add yourEndPoint here
    
    
}


-(void)draw
{
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //if(appDelegate.dashedCurve==YES){
    NSLog(@" This is DRAW-1 method !!!!!");
  CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if ( IDIOM == IPAD ) {
         CGContextSetLineWidth(context,  self.lineWidthNew
);
    }
    else{
       CGContextSetLineWidth(context,self.lineWidthNew);
        
    }

    CGContextSetAlpha(context, 1.0);
    
    // draw the line
    CGContextMoveToPoint(context, d.x, d.y);
    CGContextAddLineToPoint(context, c.x, c.y);
    
    CGContextStrokePath(context);
    
  
               

    
}
-(void)draw2
{
    NSLog(@" This is draw2 method !!!!!");
   
 	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);

	CGContextMoveToPoint(ctx, a.x, a.y);
	CGContextAddLineToPoint(ctx, b.x, b.y);
	CGContextMoveToPoint(ctx, c.x, c.y);
	CGContextAddLineToPoint(ctx, d.x, d.y);
	CGContextStrokePath(ctx);
	CGContextMoveToPoint(ctx, a.x, a.y);
    
    
    
	for (double t = 0; t < 1; t += EPSILON) {
		CGPoint p = [self bezier:t];
		CGContextAddLineToPoint(ctx, p.x, p.y);
	}
    
	CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    
    if ( IDIOM == IPAD ) {
        //CGContextSetLineWidth(ctx, 2.8);
        CGContextSetLineWidth(ctx, self.lineWidthNew);
    }
    else{
        CGContextSetLineWidth(ctx, self.lineWidthNew);
       // CGContextSetLineWidth(ctx, 2.3);
    }
    
	CGContextSetLineCap(ctx, kCGLineCapRound);
	CGContextSetLineJoin(ctx, kCGLineJoinRound);
	CGContextStrokePath(ctx);
     
        
        //[self showLines:ctx];
  
        
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextSetAlpha(ctx, 0.3f);

        CGContextFillEllipseInRect(ctx, CGRectMake(a.x-5, a.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(b.x-5, b.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(c.x-5, c.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(d.x-5, d.y-5, 10, 10));
        

        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSelectFont(ctx, "Helvetica", 18.0, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
   
        
    
    
        NSString *label = [NSString stringWithFormat:@"(%.0f,%.0f)", a.x, a.y];
        
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", c.x, c.y];
        
        
        CGRect fixedBounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;
        
    
   
    
   /* CGContextSetTextDrawingMode(ctx, kCGTextFill);
    [[UIColor blackColor] setFill];
    [@"(%.0f,%.0f)" drawAtPoint:CGPointMake( c.x - 10, c.y + 10) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"  size:17]}];
    */
    
    /*
        
        
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, c.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, c.y + 10)), [label UTF8String], [label length]);
        
        //[NSString drawAtPoint:aPoint withAttributes:dictOfAttributes];
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", d.x, d.y];
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, d.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, d.y + 10)), [label UTF8String], [label length]);
        
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", b.x, b.y];
        
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, b.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, b.y + 10)), [label UTF8String], [label length]);
        
        
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, a.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, a.y + 10)), [label UTF8String], [label length]);
        */
}

-(void)draw3
{
    NSLog(@" This is draw3 method !!!!!");

CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	CGContextMoveToPoint(ctx, a.x, a.y);
	for (double t = 0; t < 1; t += EPSILON) {
		CGPoint p = [self bezier:t];
		CGContextAddLineToPoint(ctx, p.x, p.y);
	}
	CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    
    
    
    if ( IDIOM == IPAD ) {
        CGContextSetLineWidth(ctx, self.lineWidthNew);
    }
    else{
        CGContextSetLineWidth(ctx, self.lineWidthNew);
        
    }
    
	CGContextSetLineCap(ctx, kCGLineCapRound);
	CGContextSetLineJoin(ctx, kCGLineJoinRound);
	CGContextStrokePath(ctx);
    

	CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
	CGContextSelectFont(ctx, "Helvetica", 18.0, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    

}






 #if !ACE_HAS_ARC


 
 - (void)dealloc
 {
 self.lineColor = nil;
 [super dealloc];
 }
 
 #endif
 
 @end







#pragma mark - ACEDrawingDashCurveTool

@implementation ACEDrawingDashCurveTool

@synthesize textFromView = _textFromView;
@synthesize a,b,c,d;

double dist2(CGPoint a, CGPoint b) {
    double dx = a.x - b.x;
    double dy = a.y - b.y;
    return sqrt(dx*dx + dy*dy);
}



static const double EPSILON2 = .005;

CGPoint addPoints2(CGPoint a,CGPoint other) {
    return CGPointMake(a.x+other.x, a.y+other.y);
}

CGPoint scalarMult2(CGPoint a, double sc) {
    return CGPointMake(a.x*sc, a.y*sc);
}

- (CGPoint)bezier:(double) t // Parameter 0 <= t <= 1
{
    
    
    double s = 1 - t;
    CGPoint AB = addPoints2(scalarMult2(a,s), scalarMult2(b, t));
    CGPoint BC = addPoints2(scalarMult2(b,s), scalarMult2(c, t));
    CGPoint CD = addPoints2(scalarMult2(c,s), scalarMult2(d, t));
    CGPoint ABC = addPoints2(scalarMult2(AB,s), scalarMult2(BC, t));
    CGPoint BCD = addPoints2(scalarMult2(BC,s), scalarMult2(CD, t));
    return addPoints2(scalarMult2(ABC,s), scalarMult2(BCD, t));
    
}

@synthesize lineColor = _lineColor;
@synthesize lineWidthNew = _lineWidthNew;


- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        
    }
    return self;
}
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    d  = firstPoint;
    //[self moveToPoint:firstPoint]; //add yourStartPoint here
    ///[self addLineToPoint:endPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    c = endPoint;
    
    //  [self addLineToPoint:self.lastPoint];// add yourEndPoint here
    
    
}

-(void)draw
{
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path  moveToPoint:d]; //add yourStartPoint here
    [path addLineToPoint:c];// add yourEndPoint here
    [self.lineColor setStroke];
    
    [path setLineWidth:self.lineWidthNew];
    CGFloat dashes[] = { path.lineWidth, path.lineWidth * 2 };
    [path setLineDash:dashes count:2 phase:0];
    
   // CGFloat dashes[] = {4,4,4,4};
    //[path setLineDash:dashes count:4 phase:2];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    
    /*
        CGContextRef context = UIGraphicsGetCurrentContext();
         
         // set the line properties
         CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
         CGContextSetLineCap(context, kCGLineCapRound);
    
         if ( IDIOM == IPAD ) {
         CGContextSetLineWidth(context, 2.0);
         }
         else{
         CGContextSetLineWidth(context, 1.7);
         
         }
         
         
         
         CGFloat dashes[] = {8,8,8,8};
         
         CGContextSetLineDash(context, 3, dashes, 4);
         
         
         CGContextSetAlpha(context, 1.0);
         
         // draw the line
         CGContextMoveToPoint(context, d.x, d.y);
         CGContextAddLineToPoint(context, c.x, c.y);
         CGContextStrokePath(context);
    
*/


}
-(void)draw2
{
    
    NSLog(@" This is draw2 method !!!!!");
    
    
    
      CGContextRef ctx = UIGraphicsGetCurrentContext();
      CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetAlpha(ctx, 0.3f);

    
    
         CGContextMoveToPoint(ctx, a.x, a.y);
         CGContextAddLineToPoint(ctx, b.x, b.y);
         CGContextMoveToPoint(ctx, c.x, c.y);
         CGContextAddLineToPoint(ctx, d.x, d.y);
         CGContextStrokePath(ctx);
         CGContextMoveToPoint(ctx, a.x, a.y);
    
         for (double t = 0; t < 1; t += EPSILON2) {
         CGPoint p = [self bezier:t];
         CGContextAddLineToPoint(ctx, p.x, p.y);
         }
         
         CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
         
   // CGFloat dashes[] = {4,4,4,4};
    
  //  CGContextSetLineDash(ctx, 2, dashes, 4);
    
    
  /*  if ( IDIOM == IPAD ) {
        CGContextSetLineWidth(ctx, self.lineWidthNew);
    }
    else{
        CGContextSetLineWidth(ctx, self.lineWidthNew);
        
    }*/
        CGContextSetLineWidth(ctx, self.lineWidthNew);
        CGFloat dashes[] = { self.lineWidthNew, self.lineWidthNew * 2 };
        CGContextSetLineDash(ctx, 0,dashes,2);
        
    
         CGContextSetLineCap(ctx, kCGLineCapRound);
         CGContextSetLineJoin(ctx, kCGLineJoinRound);
         CGContextStrokePath(ctx);
    
        
        //[self showLines:ctx];
        
   // CGContextRef ctx = UIGraphicsGetCurrentContext();
    
       CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
       CGContextSetAlpha(ctx, 0.3f);
    
    
        CGContextFillEllipseInRect(ctx, CGRectMake(a.x-5, a.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(b.x-5, b.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(c.x-5, c.y-5, 10, 10));
        CGContextFillEllipseInRect(ctx, CGRectMake(d.x-5, d.y-5, 10, 10));
        
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSelectFont(ctx, "Helvetica", 18.0, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
        
        
        
        
        NSString *label = [NSString stringWithFormat:@"(%.0f,%.0f)", a.x, a.y];
        
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", c.x, c.y];
        
        
        CGRect fixedBounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;
        
        
    
    /*
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    [[UIColor blackColor] setFill];
    [@"yourstring" drawAtPoint:CGPointMake( c.x - 10, c.y + 10) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"  size:17]}];
    
    */
    
        /*
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, c.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, c.y + 10)), [label UTF8String], [label length]);
        */
        //[NSString drawAtPoint:aPoint withAttributes:dictOfAttributes];
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", d.x, d.y];
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, d.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, d.y + 10)), [label UTF8String], [label length]);
        
        
        label = [NSString stringWithFormat:@"(%.0f,%.0f)", b.x, b.y];
        
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, b.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, b.y + 10)), [label UTF8String], [label length]);
        
        
        CGContextShowTextAtPoint(ctx, fmax(30, fmin(fixedBounds.size.width - 80, a.x - 10)), fmax(30, fmin(self.bounds.size.height - 44, a.y + 10)), [label UTF8String], [label length]);
        
        
        
        
      //  UIGraphicsEndImageContext();
        
    
}

-(void)showLines:(CGColorRef*)ctx
{
    NSLog(@"Im  showing lines and dots");
   
    
}
-(void)draw3
{
    NSLog(@" This is draw3 method !!!!!");
    
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //if(appDelegate.dashedCurve==YES){
        
        
   
        
       /* CGContextRef ctx = UIGraphicsGetCurrentContext();
         
         CGContextMoveToPoint(ctx, a.x, a.y);
         for (double t = 0; t < 1; t += EPSILON2) {
         CGPoint p = [self bezier:t];
         CGContextAddLineToPoint(ctx, p.x, p.y);
         }
         CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
         
         
         CGFloat dashes[] = {4,4,4,4};
         
         CGContextSetLineDash(ctx, 2, dashes, 4);
         
    
         if ( IDIOM == IPAD ) {
         CGContextSetLineWidth(ctx, 2.0);
         }
         else{
         CGContextSetLineWidth(ctx, 1.7);
         
         }
         
         CGContextSetLineCap(ctx, kCGLineCapRound);
         CGContextSetLineJoin(ctx, kCGLineJoinRound);
         CGContextStrokePath(ctx);
         */
    
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    
    
    [path  moveToPoint:a]; //add yourStartPoint here
    for (double t = 0; t < 1; t += EPSILON2) {
        CGPoint p = [self bezier:t];
        [path addLineToPoint:p];// add yourEndPoint here
    }
    
    
    [self.lineColor setStroke];
    
        [path setLineWidth:self.lineWidthNew];
    
       
    /*CGFloat dashes[] = {4,4,4,4};
    [path setLineDash:dashes count:4 phase:2];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
     
     */
    CGFloat dashes[] = { path.lineWidth, path.lineWidth * 2 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    
    /*
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, a.x, a.y);
    for (double t = 0; t < 1; t += EPSILON2) {
        CGPoint p = [self bezier:t];
        CGContextAddLineToPoint(ctx, p.x, p.y);
    }
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    
    */
            CGContextRef ctx = UIGraphicsGetCurrentContext();
         CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
         CGContextSelectFont(ctx, "Helvetica", 18.0, kCGEncodingMacRoman);
         CGContextSetTextDrawingMode(ctx, kCGTextFill);
         CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    

}
#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end












#pragma mark - ACEDrawingDashTool

@interface ACEDrawingDashLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingDashLineTool

CAShapeLayer *shapelayer;
@synthesize textFromView = _textFromView;

@synthesize lineColor = _lineColor;
@synthesize lineWidthNew = _lineWidthNew;
@synthesize lineWidthInStock = _lineWidthInStock;

@synthesize a,b,c,d;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        
    }
    return self;
}
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}


-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint  =firstPoint;
   //[self moveToPoint:firstPoint]; //add yourStartPoint here
    ///[self addLineToPoint:endPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    
   self.lastPoint = endPoint;
    
   //  [self addLineToPoint:self.lastPoint];// add yourEndPoint here
    

}
-(void)draw3
{
    
/*
    UIBezierPath * path = [[UIBezierPath alloc] init];
    
    //[path moveToPoint:CGPointMake(10.0, 10.0)];
    //[path addLineToPoint:CGPointMake(290.0, 10.0)];
    
    [path  moveToPoint:self.firstPoint]; //add yourStartPoint here
    [path addLineToPoint:self.lastPoint];// add yourEndPoint here
    [self.lineColor setStroke];
    [path setLineWidth:self.lineWidthNew];
    
   // [path setLineWidth:self.lineWidthInStock];
    
    CGFloat dashes[] = {4,4,4,4};
    [path setLineDash:dashes count:4 phase:2];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    
    
    /*
    if(self.self.lineWidthInStock == 2.0){
        
        CGFloat dashes[] = {4,4,4,4};
        [path setLineDash:dashes count:4 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        
    }
    if(self.self.lineWidthInStock == 4.0 )
    {
        
        CGFloat dashes[] = {6,6};
        [path setLineDash:dashes count:6 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
    if(self.self.lineWidthInStock == 6.0)
    {
        
        CGFloat dashes[] = {8,8};
        [path setLineDash:dashes count:8 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
    if(self.self.lineWidthInStock == 8.0 )
    {
        
        CGFloat dashes[] = {10,10};
        [path setLineDash:dashes count:10 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
    if(self.self.lineWidthInStock == 12.0 )
    {
        
        CGFloat dashes[] = {12,12};
        [path setLineDash:dashes count:12 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
    
    */

    UIBezierPath * path = [[UIBezierPath alloc] init];
    
    [path  moveToPoint:self.firstPoint]; //add yourStartPoint here
    [path addLineToPoint:self.lastPoint];// add yourEndPoint here
    [self.lineColor setStroke];

    
    [path setLineWidth:self.lineWidthNew];
    CGFloat dashes[] = { path.lineWidth, path.lineWidth * 2 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    
    
}
- (void)draw
{
    UIBezierPath * path = [[UIBezierPath alloc] init];
    
    [path  moveToPoint:self.firstPoint]; //add yourStartPoint here
    [path addLineToPoint:self.lastPoint];// add yourEndPoint here
    [self.lineColor setStroke];

    
    [path setLineWidth:self.lineWidthNew];
    CGFloat dashes[] = { path.lineWidth, path.lineWidth * 2 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    
    
    
 /*
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path  moveToPoint:self.firstPoint]; //add yourStartPoint here
    [path addLineToPoint:self.lastPoint];// add yourEndPoint here
    [self.lineColor setStroke];

   
    [path setLineWidth:self.lineWidthNew];
          
    
   // [path setLineWidth:self.lineWidthInStock];
    
    CGFloat dashes[] = {4,4,4,4};
    [path setLineDash:dashes count:4 phase:2];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
    /*
    
    if(self.lineWidthNew == 2.0){
        
        CGFloat dashes[] = {4,4,4,4};
        [path setLineDash:dashes count:4 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        self.lineWidthInStock = self.lineWidthNew;
        
    }
    if(self.lineWidthNew == 4.0 )
    {
        
        CGFloat dashes[] = {6,6};
        [path setLineDash:dashes count:6 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        self.lineWidthInStock = self.lineWidthNew;
    }
    if(self.lineWidthNew == 6.0)
    {
        
        CGFloat dashes[] = {8,8};
        [path setLineDash:dashes count:8 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        self.lineWidthInStock = self.lineWidthNew;

    }
    if(self.lineWidthNew == 8.0 )
    {
        
        CGFloat dashes[] = {10,10};
        [path setLineDash:dashes count:10 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        self.lineWidthInStock = self.lineWidthNew;

    }
    if(self.lineWidthNew == 12.0 )
    {
        
        CGFloat dashes[] = {12,12};
        [path setLineDash:dashes count:12 phase:2];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
        self.lineWidthInStock = self.lineWidthNew;

    }

*/
   
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.dashlineColor = nil;
    [super dealloc];
}
#endif
@end

#pragma mark - ACEDrawingArrowTool

@interface ACEDrawingArrowTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat arrowLength;

@end

#pragma mark -

@implementation ACEDrawingArrowTool

//@synthesize arrowColor = _arrowColor;
//@synthesize arrowWidth = _arrowWidth;
@synthesize lineColor = _lineColor;
@synthesize lineWidthNew = _lineWidthNew;


@synthesize textFromView = _textFromView;

@synthesize a,b,c,d;
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}
-(void)draw3
{
    
    
    double slopy, cosy, siny;
    // Arrow size
    
    double length = 0.0;
    double width = 0.0;
  


    CGFloat xDist = (self.lastPoint.x - self.firstPoint.x); //[2]
    CGFloat yDist = (self.lastPoint.y - self.firstPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    NSLog(@"THE DISTANCE IS ====== %f",distance);
    
    
    if(distance<22)
    {
    width=self.lineWidthNew+(distance/5);
    length=self.lineWidthNew+(distance/5);
    }
    else
    {
        width=self.lineWidthNew+4.4;
        length=self.lineWidthNew+4.4;
    }
    
    NSLog(@"THE DISTANCE IS ====== %f",distance);
    
    slopy = atan2((self.firstPoint.y -self.lastPoint.y), (self.firstPoint.x - self.lastPoint.x));
    cosy = cos(slopy);
    siny = sin(slopy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
  
           CGContextSetLineWidth(context, self.lineWidthNew);
        

    
    
    CGContextSetAlpha(context, 1.0);
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    
    CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            self.lastPoint.x +  (length * cosy - ( width / 2.0 * siny )),
                            self.lastPoint.y +  (length * siny + ( width / 2.0 * cosy )) );
    
    CGContextClosePath(UIGraphicsGetCurrentContext());

    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            self.lastPoint.x +  (length * cosy + width / 2.0 * siny),
                            self.lastPoint.y -  (width / 2.0 * cosy - length * siny) );
    
    
    CGContextClosePath(UIGraphicsGetCurrentContext());
    CGContextStrokePath(context);

}
- (void)draw
{
    NSLog(@"This is arrow tool draw method");
    
    double slopy, cosy, siny;
    // Arrow size
    double length = 0.0;
    double width = 0.0;
  


    CGFloat xDist = (self.lastPoint.x - self.firstPoint.x); //[2]
    CGFloat yDist = (self.lastPoint.y - self.firstPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    NSLog(@"THE DISTANCE IS ====== %f",distance);
    
    
    if(distance<22)
    {
    width=self.lineWidthNew+(distance/5);
    length=self.lineWidthNew+(distance/5);
    }
    else
    {
        width=self.lineWidthNew+4.4;
        length=self.lineWidthNew+4.4;
    }
    
    
    
    slopy = atan2((self.firstPoint.y -self.lastPoint.y), (self.firstPoint.x - self.lastPoint.x));
    cosy = cos(slopy);
    siny = sin(slopy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);

   
    
        CGContextSetLineWidth(context, self.lineWidthNew);
    
    
    CGContextSetAlpha(context, 1.0);

    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
        
    CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            self.lastPoint.x +  (length * cosy - ( width / 2.0 * siny )),
                            self.lastPoint.y +  (length * siny + ( width / 2.0 * cosy )) );
    
    CGContextClosePath(UIGraphicsGetCurrentContext());

    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            self.lastPoint.x +  (length * cosy + width / 2.0 * siny),
                            self.lastPoint.y -  (width / 2.0 * cosy - length * siny) );

    CGContextClosePath(UIGraphicsGetCurrentContext());
     CGContextStrokePath(context);
    //----------------------------------------------------------------
    
   
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
     */
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.arrowColor = nil;
    [super dealloc];
}

#endif

@end




#pragma mark - ACEDrawingLineTool

@interface ACEDrawingLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingLineTool
@synthesize textFromView = _textFromView;

@synthesize lineColor = _lineColor;
@synthesize lineWidthNew = _lineWidthNew;
@synthesize a,b,c,d;
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
 
    if ( IDIOM == IPAD ) {
        CGContextSetLineWidth(context, self.lineWidthNew);
    }
    else{
        CGContextSetLineWidth(context, self.lineWidthNew);
        
    }
    
    CGContextSetAlpha(context, 1.0);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
}
-(void)draw3
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);

    if ( IDIOM == IPAD ) {
        CGContextSetLineWidth(context, self.lineWidthNew);
    }
    else{
        CGContextSetLineWidth(context,self.lineWidthNew);
        
    }
    
    CGContextSetAlpha(context, 1.0);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
   
}
#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end
#pragma mark - ACEDrawingEraserTool

@implementation ACEDrawingEraserTool

@synthesize lineColor = _lineColor;
@synthesize lineWidthNew = _lineWidthNew;

@synthesize textFromView = _textFromView;
@synthesize eraserWidth;

@synthesize a,b,c,d;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        self.lineCapStyle = kCGLineCapRound;
        self.lineJoinStyle =  kCGLineJoinRound;
    }
    return self;
}
-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;
    
}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midsPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    NSLog(@"ERASER IN PROGRESS - 1");
    [self.lineColor setStroke];
    [self setLineWidth:30.0];
    self.eraserWidth = 30.0;
    if ( IDIOM == IPAD ) {
          [self setLineWidth:30.0];
    }
    else{
        self.eraserWidth = 15.0;
          [self setLineWidth:15.0];
        
    }
    
    
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle =  kCGLineJoinRound;
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:1];
}
-(void)draw3
{
    
    NSLog(@"ERASER IN PROGRESS - 3");

    [self.lineColor setStroke];
    if ( IDIOM == IPAD ) {
        [self setLineWidth:30.0];
        self.eraserWidth = 30.0;
    }
    else{
        self.eraserWidth = 15.0;
        [self setLineWidth:15.0];
        
    }
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle =  kCGLineJoinRound;

    [self strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.eraserColor = nil;
    [super dealloc];
}

#endif

@end




#pragma mark - ACEDrawingTextTool

@interface ACEDrawingTextTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingTextTool

@synthesize lineColor = _lineColor;
@synthesize textFromView = _textFromView;
@synthesize lineWidthNew = _lineWidthNew;
@synthesize a,b,c,d,bounds1;

-(void)getTextFromView:(NSString*)text
{
    self.textFromView = text;

}
- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}
-(void)boundsOfTextView:(CGSize)bounds
{
    self.bounds1 = bounds;

}

- (void)draw
{
    NSLog(@"FIRST POINT width ,height %f %f",self.bounds1.width, self.bounds1.height);
    
    
    UIColor *mycolor2 = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context,mycolor2.CGColor );
    CGRect textRect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.bounds1.width, self.bounds1.height);
    //[[UIColor blackColor] setFill];
    [self.textFromView drawInRect: textRect withFont: [UIFont fontWithName:@"AvenirNext-Regular" size: 20] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentLeft];
   
   
   
    
    NSLog(@"Draw method for TEXT ");
     

}
-(void)draw3
{
    UIColor *mycolor2 = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    CGContextRef context = UIGraphicsGetCurrentContext();
CGContextSetFillColorWithColor(context,mycolor2.CGColor);
    
 //   UIFont * font = [UIFont fontWithName:@"Helvetica" size:20];
   // [self.textFromView drawAtPoint:CGPointMake(self.firstPoint.x,self.firstPoint.y) withFont:[UIFont fontWithName:@"Helvetica" size:20]];
    

    
    CGRect textRect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.bounds1.width, self.bounds1.height);
   // [[UIColor blackColor] setFill];
    [self.textFromView drawInRect: textRect withFont: [UIFont fontWithName: @"AvenirNext-Regular" size: 20] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentLeft];
    
   
    
    
}
#if !ACE_HAS_ARC

- (void)dealloc
{
    //self.textFromView = nil;
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end





