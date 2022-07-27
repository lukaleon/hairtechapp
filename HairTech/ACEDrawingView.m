

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"
#import "DrawViewController.h"
#import "DrawViewControllerRight.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/objc.h>
#import <objc/message.h>
#import "HapticHelper.h"
#import "CHMagnifierView.h"
#import "Ruler.h"
#import <CoreGraphics/CoreGraphics.h>



//#define kDefaultLineColor       [UIColor redColor]
#define kDefaultLineWidth       10.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0
#define kOFFSET_FOR_KEYBOARD 200.0

#define kOFFSET_FOR_KEYBOARD_RETINA 400.0

#define POINT_CHECK 720.0
#define POINT_CHECK_RETINA 1440.0

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@interface ACEDrawingView ()


@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, strong) NSMutableArray *paths;


@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

@property (nonatomic, strong) NSMutableArray *bufferOfPoints;


@property (nonatomic, strong) id<ACEDrawingTool> currentTool;

//@property (nonatomic,strong,readwrite) UIImage *image;

@property (strong, nonatomic) NSTimer *touchTimer;
@property (strong, nonatomic) CHMagnifierView *magnifierView;
@property (strong, nonatomic) Ruler *Ruler;



@end

#pragma mark -

@implementation ACEDrawingView

@synthesize a,b,c,d,pa,pb,pc,pd, touchesCount,touchesForEditMode;
//@synthesize textView;
@synthesize touchForText;
@synthesize editModeforText;
@synthesize touchCoord;
@synthesize pointForRecognizer;
@synthesize pan;
@synthesize touchesForUpdate;
CGFloat red;
CGFloat green;
CGFloat blue;
CGFloat alpha;
UIColor* tempColor;

@synthesize shapes = _shapes;



-(void)pixelBox:(UIImageView*)pixelBox
{
    UIColor *fillColor = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:0.5];
    UIColor *fillColor2 = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:0.2];
    
    pixelBox.backgroundColor = fillColor;
    pixelBox.layer.cornerRadius = 2.5;
    pixelBox.layer.masksToBounds = YES;
    [pixelBox.layer setShadowOffset:CGSizeMake(0, 0)];
    [pixelBox.layer setShadowColor:fillColor2.CGColor];
    [pixelBox.layer setShadowRadius:2.5f];
    [pixelBox.layer setShadowOpacity:0.2];
    
}

-(void)addAnchorPoints{
    
    self.pixelBox =[[UIImageView alloc] initWithFrame:CGRectMake(209,269,5,5)];
    self.pixelBox2 =[[UIImageView alloc] initWithFrame:CGRectMake(263,337,5,5)];
    self.pixelBox3 =[[UIImageView alloc] initWithFrame:CGRectMake(107,303,5,5)];
    self.pixelBox4 =[[UIImageView alloc] initWithFrame:CGRectMake(238,428,5,5)];
    self.pixelBox5 =[[UIImageView alloc] initWithFrame:CGRectMake(191,267,5,5)];
    self.pixelBox6 =[[UIImageView alloc] initWithFrame:CGRectMake(173,267,5,5)];
    self.pixelBox7 =[[UIImageView alloc] initWithFrame:CGRectMake(260,320,5,5)];
    self.pixelBox8 =[[UIImageView alloc] initWithFrame:CGRectMake(156,320,5,5)];
    self.pixelBox9 =[[UIImageView alloc] initWithFrame:CGRectMake(242,285,5,5)];
    self.pixelBox10 =[[UIImageView alloc] initWithFrame:CGRectMake(156,270,5,5)];
    self.pixelBox11 =[[UIImageView alloc] initWithFrame:CGRectMake(141,276,5,5)];
    self.pixelBox12 =[[UIImageView alloc] initWithFrame:CGRectMake(126,285,5,5)];
    self.pixelBox13 =[[UIImageView alloc] initWithFrame:CGRectMake(254,303,5,5)];
    self.pixelBox14 =[[UIImageView alloc] initWithFrame:CGRectMake(226,275,5,5)];
    self.pixelBox15 =[[UIImageView alloc] initWithFrame:CGRectMake(262,356,5,5)];
    self.pixelBox16 =[[UIImageView alloc] initWithFrame:CGRectMake(258,373,5,5)];
    self.pixelBox17 =[[UIImageView alloc] initWithFrame:CGRectMake(251,391,5,5)];
    self.pixelBox18 =[[UIImageView alloc] initWithFrame:CGRectMake(241,407,5,5)];
    self.pixelBox19 =[[UIImageView alloc] initWithFrame:CGRectMake(210,407,5,5)];
    self.pixelBox20 =[[UIImageView alloc] initWithFrame:CGRectMake(220,424,5,5)];
    self.pixelBox21 =[[UIImageView alloc] initWithFrame:CGRectMake(216,373,5,5)];
    self.pixelBox22 =[[UIImageView alloc] initWithFrame:CGRectMake(159,337,5,5)];
    self.pixelBox23 =[[UIImageView alloc] initWithFrame:CGRectMake(134,303,5,5)];
    self.pixelBox24 =[[UIImageView alloc] initWithFrame:CGRectMake(182,356,5,5)];
    self.pixelBox25 =[[UIImageView alloc] initWithFrame:CGRectMake(186,373,5,5)];
    self.pixelBox26 =[[UIImageView alloc] initWithFrame:CGRectMake(191,388,5,5)];
    
    
    //self.pixelBox27 =[[UIImageView alloc] initWithFrame:CGRectMake(,356,5,5)];

    
    


    [self pixelBox:self.pixelBox];
    [self pixelBox:self.pixelBox2];
    [self pixelBox:self.pixelBox3];
    [self pixelBox:self.pixelBox4];
    [self pixelBox:self.pixelBox5];
    [self pixelBox:self.pixelBox6];
    [self pixelBox:self.pixelBox7];
    [self pixelBox:self.pixelBox8];
    [self pixelBox:self.pixelBox9];
    [self pixelBox:self.pixelBox10];
    [self pixelBox:self.pixelBox11];
    [self pixelBox:self.pixelBox12];
    [self pixelBox:self.pixelBox13];
    [self pixelBox:self.pixelBox14];
    [self pixelBox:self.pixelBox15];
    [self pixelBox:self.pixelBox16];
    [self pixelBox:self.pixelBox17];
    [self pixelBox:self.pixelBox18];
    [self pixelBox:self.pixelBox19];
    [self pixelBox:self.pixelBox20];
    [self pixelBox:self.pixelBox21];
    [self pixelBox:self.pixelBox22];
    [self pixelBox:self.pixelBox23];
    [self pixelBox:self.pixelBox24];
    [self pixelBox:self.pixelBox25];
    [self pixelBox:self.pixelBox26];
   // [self pixelBox:self.pixelBox27];

    [self addSubview:self.pixelBox];
    [self addSubview:self.pixelBox2];
    [self addSubview:self.pixelBox3];
    [self addSubview:self.pixelBox4];
    [self addSubview:self.pixelBox5];
    [self addSubview:self.pixelBox6];
    [self addSubview:self.pixelBox7];
    [self addSubview:self.pixelBox8];
    [self addSubview:self.pixelBox9];
    [self addSubview:self.pixelBox10];
    [self addSubview:self.pixelBox11];
    [self addSubview:self.pixelBox12];
    [self addSubview:self.pixelBox13];
    [self addSubview:self.pixelBox14];
    [self addSubview:self.pixelBox15];
    [self addSubview:self.pixelBox16];
    [self addSubview:self.pixelBox17];
    [self addSubview:self.pixelBox18];
    [self addSubview:self.pixelBox19];
    [self addSubview:self.pixelBox20];
    [self addSubview:self.pixelBox21];
    [self addSubview:self.pixelBox22];
    [self addSubview:self.pixelBox23];
    [self addSubview:self.pixelBox24];
    [self addSubview:self.pixelBox25];
    [self addSubview:self.pixelBox26];
    

    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            
        
      //  [self configure];
    
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        pan=NO;
        touchesForUpdate = 0;
        
        [self configure];

        
       /* self.TouchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                           target:self
                                                         selector:@selector(ShowTextOfColor)
                                                         userInfo:nil
                                                          repeats:NO];
        */
        
  
        dot =[[UIImageView alloc] initWithFrame:CGRectMake(20,20,10,10)];
        dot.image=[UIImage imageNamed:@"dot2.png"];
        [self addSubview:dot];
        dot.alpha = 0;
        
        
        dot2 =[[UIImageView alloc] initWithFrame:CGRectMake(20,20,10,10)];
             dot2.image=[UIImage imageNamed:@"dot2.png"];
             [self addSubview:dot2];
             dot2.alpha = 0;
             
        
        
     
        
        drawingLayer = [CALayer layer];
        [self.layer addSublayer:drawingLayer];
        
        self.shapes = [NSMutableArray array];
        arrayOfLastPoints = [[NSArray alloc]init];
      arrayOfPoints = [[NSMutableArray alloc]init];

    }
    
    
    
    return self;
    
    
    
    
    
}




/*
 
 
-(void)ShowTextOfColor{
    CGPoint p;

    
    for(int x=1; x<=self.frame.size.width;x++)
    {
        for(int y=1; y<=self.frame.size.height;y++)
        {
            p = CGPointMake(x,y);
            
             if(![[self hexStringFromColorNEW:[self.delegate colorAtPixel:p]] isEqualToString:@"#000000"]){
            
            NSLog(@"HEX STRING = %@", [self hexStringFromColorNEW:[self.delegate colorAtPixel:p]]);
             }
        }
    }
    
    
}



*/

//Always return the iOS8 way - i.e. height is the real orientation dependent height
+ (CGRect)screenBoundsOrientationDependent {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsPortrait ([UIApplication sharedApplication].statusBarOrientation)) {
        screenRect = CGRectMake(screen.bounds.origin.x, screen.bounds.origin.y, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
    NSLog(@"ScreenBoundsOrientationMEthod");
}


- (void)configure
{
   
    self.pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 500, 40)];
   
  //[self addSubview:self.pointsLabel];
    
    self.pointsCoord = [NSMutableArray array];
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    self.bufferOfPoints = [NSMutableArray array];

      [self LoadColorsAtStart];
    self.lineColor = tempColor;
    
    self.backgroundColor = [UIColor clearColor];
    
    
   self.pointsCoord = [NSMutableArray array];
    
      AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"CUURENT VIEW IS %@",appDelegate.currentView);
    if([appDelegate.currentView isEqualToString:@"drawView"])
    {
  //      [self addAnchorPoints];
        
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox.center.x,self.pixelBox.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox2.center.x,self.pixelBox2.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox3.center.x,self.pixelBox3.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox4.center.x,self.pixelBox4.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox5.center.x,self.pixelBox5.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox6.center.x,self.pixelBox6.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox7.center.x,self.pixelBox7.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox8.center.x,self.pixelBox8.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox9.center.x,self.pixelBox9.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox10.center.x,self.pixelBox10.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox11.center.x,self.pixelBox11.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox12.center.x,self.pixelBox12.center.y)]];
     [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox13.center.x,self.pixelBox13.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox14.center.x,self.pixelBox14.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox15.center.x,self.pixelBox15.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox16.center.x,self.pixelBox16.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox17.center.x,self.pixelBox17.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox18.center.x,self.pixelBox18.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox19.center.x,self.pixelBox19.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox20.center.x,self.pixelBox20.center.y)]];
    
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox21.center.x,self.pixelBox21.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox22.center.x,self.pixelBox22.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox23.center.x,self.pixelBox23.center.y)]];
    [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox24.center.x,self.pixelBox24.center.y)]];
     [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox25.center.x,self.pixelBox25.center.y)]];
     [self.pointsCoord addObject:[NSValue valueWithCGPoint:CGPointMake(self.pixelBox26.center.x,self.pixelBox26.center.y)]];
    
        
        
        
    }

    
    
    
    
    
    
    


   
}
/*-(BOOL)longPressHappened:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"LONG PRESS HAPPENED");
    return true;
    
}*/


-(void)LoadColorsAtStart
{
    NSUserDefaults *prefers = [NSUserDefaults standardUserDefaults];
   tempColor = [UIColor colorWithRed:[prefers floatForKey:@"cr5"] green:[prefers floatForKey:@"cg5"] blue:[prefers floatForKey:@"cb5"] alpha:[prefers floatForKey:@"ca5"]];
    
    UIColor* tColor2 = [UIColor colorWithRed:[prefers floatForKey:@"cr2"] green:[prefers floatForKey:@"cg2"] blue:[prefers floatForKey:@"cb2"] alpha:[prefers floatForKey:@"ca2"]];
    
    UIColor* tColor3 = [UIColor colorWithRed:[prefers floatForKey:@"cr3"] green:[prefers floatForKey:@"cg3"] blue:[prefers floatForKey:@"cb3"] alpha:[prefers floatForKey:@"ca3"]];
    
    UIColor* tColor4 = [UIColor colorWithRed:[prefers floatForKey:@"cr4"] green:[prefers floatForKey:@"cg4"] blue:[prefers floatForKey:@"cb4"] alpha:[prefers floatForKey:@"ca4"]];
    
    UIColor* tColor6 = [UIColor colorWithRed:[prefers floatForKey:@"cr6"] green:[prefers floatForKey:@"cg6"] blue:[prefers floatForKey:@"cb6"] alpha:[prefers floatForKey:@"ca6"]];
    

    UIColor *color = tempColor;
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    NSLog(@"THIS IS THE VALUE OF BLACK EXTRACT: %@", colorAsString);
    
    
    
    [prefers synchronize];
}




/*
-(void)drawGrid{
    self.numberOfRows = self.frame.size.height/12;
    self.numberOfColumns=self.frame.size.width/12;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.25);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    
    // calculate column width
    CGFloat columnWidth = self.frame.size.width / (self.numberOfColumns + 1.0);
    
    for(int i = 1; i <= self.numberOfColumns; i++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        //CGFloat dashes[] = {1.5,12};
        
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        
       // CGContextSetLineDash(context, 1, dashes, 2);
        
        CGContextStrokePath(context);
    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    
    // calclulate row height
    CGFloat rowHeight = self.frame.size.height / (self.numberOfRows + 1.0);
    
    for(int j = 1; j <= self.numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
        
    }
    
}
*/

-(void)drawRuler:(CGPoint)currrent_coord{
    
   
}



#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
   
   /*
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: self.firstTouch];
    [linePath addLineToPoint:self.lastTouch];
    
   // [line setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.firstTouch.x-5,self.firstTouch.y-5, 10, 10)] CGPath]];
    
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.lineWidth = 4.0;
    //line.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],[NSNumber numberWithInt:8], nil];
   
    line.opacity = 1.0;
    line.strokeColor = [UIColor redColor].CGColor;
    
    line.accessibilityPath = linePath;
    [drawingLayer addSublayer:line];
   // NSLog(@"SUBLAYER ADDED");
 //   NSLog(@"NUMBER OF SUBLAYERS %lu", drawingLayer.sublayers.count);

    */
    
    
    
        if(self.editMode == NO){
        //#if PARTIAL_REDRAW
        // TODO: draw only the updated part of the image
        //      [self drawPath];
        //#else
        CGRect fixedBounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;

        [self.image drawInRect:self.bounds];
        [self.currentTool draw];
        
        //#endif
    }
else    {
    
        [self.image drawInRect:self.bounds];
        [self.currentTool draw2];
        
    }
  
UIGraphicsEndImageContext();
}



- (void)updateCacheImage:(BOOL)redraw
{

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    if (redraw) {
        // erase the previous image
        self.image = nil;
        NSUInteger objIdx;
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            
            //objIdx = [self.pathArray indexOfObject:tool];

         //   if(objIdx != ACEDrawingToolTypeCurve) {
           // [tool draw];
        // }
        // else{
             
        [tool draw3];
         
       //  }
            
           
        }
        
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    

    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)updateCacheImage2:(BOOL)redraw
{
    // init a context

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            
            [tool draw2];
            
        }
        
    } else {
        // set the draw point
        
        
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw2];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)updateCacheImage3:(BOOL)redraw
{
    // init a context

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            
            [tool draw3];
            
        }
        
    } else {
        // set the draw point
        
        
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw3];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (id<ACEDrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool) {
            
        case ACEDrawingToolTypePen:
        {
            
            return ACE_AUTORELEASE([ACEDrawingPenTool new]);
            
          // self.currentTool.lineWidthNew = self.lineWidth;

        }

        case ACEDrawingToolTypeCurve:
        {
            
     
            return ACE_AUTORELEASE([ACEDrawingCurveTool new]);
        }
           
        case ACEDrawingToolTypeDashCurve:
        {
            
      
            return ACE_AUTORELEASE([ACEDrawingDashCurveTool new]);
        }
            
        case ACEDrawingToolTypeDashLine:
        {

            return ACE_AUTORELEASE([ACEDrawingDashLineTool new]);
        }
        
        case ACEDrawingToolTypeArrow:
        {

            return ACE_AUTORELEASE([ACEDrawingArrowTool new]);
        }
        case ACEDrawingToolTypeLine:
        {

            return ACE_AUTORELEASE([ACEDrawingLineTool new]);
        }

        case ACEDrawingToolTypeEraser:
    {

        return ACE_AUTORELEASE([ACEDrawingEraserTool new]);
    }
       
        case ACEDrawingToolTypeText:
        {
            
            return ACE_AUTORELEASE([ACEDrawingTextTool new]);
        }
    }
}





/*


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    // init the bezier path
    self.currentTool = [self toolWithCurrentSettings];
    self.currentTool.lineColor = self.lineColor;
    [self.pathArray addObject:self.currentTool];
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    [self.currentTool setInitialPoint:[touch locationInView:self]];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }



}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
 
#if PARTIAL_REDRAW
    // calculate the dirty rect
    CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
    CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
    CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
    CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
    [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
#else
  
    [self setNeedsDisplay];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    [self updateCacheImage:NO];
    
    // clear the current tool
    self.currentTool = nil;
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
        
        
        
        ////////////
                
        ////////
    }
}
*/

-(void)updateTextView
{

   if(pan == YES)
    {
        //[self.currentTool setInitialPoint:pointForRecognizer];
        
        [self.currentTool setInitialPoint:self.textView.frame.origin];
        
    }
    
    else
    {
        [self.currentTool setInitialPoint:CGPointMake(self.frame.size.width/2.5,self.frame.size.height/3)];

    }
 
    // [self.currentTool setInitialPoint:CGPointMake(self.frame.size.width/2.5,self.frame.size.height/3)];
    
    [self.currentTool setInitialPoint:self.textView.frame.origin];
    
    [self.currentTool getTextFromView:self.textView.text];
    
    [self.currentTool boundsOfTextView:self.textView.frame.size];
   // [self.currentTool boundsOfTextView:self.textView.textContainer.size];
    
  [self.pathArray addObject:self.currentTool];

    [self.textView setHidden:YES];


    [self updateCacheImage:NO];
    
    // clear the current tool
    
    self.currentTool = nil;
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    [self.bufferOfPoints removeAllObjects];

    
    
    // call the delegate
   if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
      
       
       /*********************** EDITABLE UILABEL TEST ****************************************/
      /*
       UIFont * customFont = [UIFont fontWithName:@"AvenirNext-Regular" size: 20];  //custom font
        NSString * text = self.textView.text;
       
       CGSize maximumLabelSize = CGSizeMake(200, self.textView.contentSize.height);
      
       CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:@{NSFontAttributeName: customFont}
                                                context:nil];
       
       UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, textRect.size.width,textRect.size.height)];
        fromLabel.text = text;
        fromLabel.font = customFont;
        fromLabel.numberOfLines = 0;
        [self addSubview:fromLabel];
       
       NSLog(@"CONTENT SIZE is = %f and %f ",self.textView.contentSize.height, self.textView.contentSize.height/44);
       
       */
       /******************************************************************************/

       
   }
    [self setNeedsDisplay];
    self.textView.text = nil;
   // editModeforText = NO;
    touchForText = 0;
    pan=NO;
    [self.delegate setButtonVisibleTextPressed];
}
/*
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    
   CGPoint translation = [recognizer translationInView:self];
   recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                 recognizer.view.center.y + translation.y);
    
  
    [recognizer setTranslation:CGPointMake(0,0) inView:self];
    
    
    CGPoint p = [recognizer locationInView:self.textView];
    
        if (CGRectContainsPoint(self.dragger.frame,p))
    {
    
    NSLog(@"%f",[recognizer locationInView:self].x);

        //  recognizer.view.center = CGPointMake(recognizer.view.center.x + [recognizer locationInView:self].x,
             //                              recognizer.view.center.y + [recognizer locationInView:self].y);
        
recognizer.view.frame = CGRectMake(self.textView.bounds.origin.x,
                                      self.textView.bounds.origin.y, [recognizer locationInView:self].x, [recognizer locationInView:self].y);
        
   }
   else {
       self.textView.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:0.1] ;
   }
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        pan = YES;
        touchesForUpdate = 0;

        CGPoint finalPoint = [recognizer locationInView:self];
        
      pointForRecognizer = CGPointMake(self.textView.frame.origin.x,self.textView.frame.origin.y);

     //   pointForRecognizer = CGPointMake(self.textView.center.x,self.textView.center.y);
 
    }
}
*/


-(void)addTextViewToMiddle
{
    
    pan= NO;
    self.currentTool = [self toolWithCurrentSettings];
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineWidthNew = self.lineWidth;
    
    [self.textView setHidden:NO];
    

    
   // self.textView.zoomEnabled = YES;
    self.textView.frame = CGRectMake((self.frame.size.width/2)-100,self.frame.size.height/3, 200,60);
   /*
  self.dragger =[[UIImageView alloc] initWithFrame:CGRectMake(self.textView.bounds.origin.x+self.textView.bounds.size.width-10
                                 ,self.textView.bounds.origin.y+self.textView.bounds.size.height-40,20.0,20.0)];
    
    self.dragger.image=[UIImage imageNamed:@"dragger.png"];
    [self.textView addSubview:self.dragger];

    */
    
    
    [self.textView becomeFirstResponder];
    self.touchForText = self.touchForText + 1;
    touchesForUpdate = 0;
}


#pragma mark - custom method
- (void)showLoupe:(NSTimer *)timer
{
    
    if ((self.magnifierView == nil)&&(countGlobal == 1)) {
        self.magnifierView = [[CHMagnifierView alloc] init];
        self.magnifierView.viewToMagnify = self.window;
        
    
    }
    
    self.magnifierView.pointToMagnify = pointForLoupe;
    
    
     [self.magnifierView makeKeyAndVisible];
}

- (void)showLoupe2:(NSTimer *)timer
{
    
    if ((self.magnifierView == nil)&&(countGlobal == 1)) {
        self.magnifierView = [[CHMagnifierView alloc] init];
        self.magnifierView.viewToMagnify = self.window;
      /* TEMPORARY INACTIVE  */
       // self.Ruler = [[Ruler alloc] init];
        //self.Ruler.viewToShowRuler = self;
        
    }
    self.magnifierView.pointToMagnify = pointForLoupe;
    //self.Ruler.pointToShowRuler = pointForLoupe;
    //[self.Ruler makeKeyAndVisible];
    [self.magnifierView makeKeyAndVisible];
}




- (void)scaleTextView:(UIPinchGestureRecognizer *)pinchGestRecognizer{
    CGFloat scale = pinchGestRecognizer.scale;
    
    self.textView.font = [UIFont fontWithName:self.textView.font.fontName size:self.textView.font.pointSize*scale];
    
    [self textViewDidChange:self.textView];
    
    

}


#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    

    
   // CGRect dotRect = [self convertRect:self.lastDot.bounds fromView:self.lastDot];
   
    UITouch *touch = [touches anyObject];
    CGPoint firstTouche = [touch locationInView:self];
    touchToCalculateDistance = [touch locationInView:self];
    

    
    
    ///----------------------------------xxxxxxxx cxv xdmvbdsmnbbdsmndsbvmdnvbs
 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.theFirstPointForRuler = firstTouche;
    

    if(self.drawTool == ACEDrawingToolTypeEraser)
    {
        self.currentTool.lineWidthNew = 30.0;;

        UITouch *touch = [touches anyObject];
        CGPoint t = [touch locationInView:self];
        
        self.eraserPointer =[[UIImageView alloc] initWithFrame:CGRectMake(t.x,t.y,15,15)];
        self.eraserPointer.image=[UIImage imageNamed:@"eraser_pointer.png"];
       
        [self addSubview:self.eraserPointer];
    }
    
    
    if(self.editMode == NO && self.drawTool == ACEDrawingToolTypeText)
    {
        
        UITouch *touch = [touches anyObject];
        CGPoint t = [touch locationInView:self];
        
        self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineWidthNew = self.lineWidth;

        

        if (touchForText != 0){
    
        
            UITouch *touch = [[event allTouches] anyObject];
            if ([self.textView isFirstResponder] && [touch view] != self.textView) {
                [self.textView resignFirstResponder];
                
                pointForRecognizer = CGPointMake(self.textView.frame.origin.x,self.textView.frame.origin.y);
                
               
            }

            
            
//[self updateTextView];
            
            
            touchesForUpdate = touchesForUpdate+1;
            [super touchesBegan:touches withEvent:event];
            
            if(touchesForUpdate==2)
            {
                
                
              [self updateTextView];
                touchesForUpdate = 0;
                
            }

        }
    }
   

    
    unsigned long count2 = [[event allTouches] count];
    countGlobal = count2;
 
     if ( count2 > 1 )  {
        
         [self.touchTimer invalidate];
         [self.magnifierView setHidden:YES];
         [self.Ruler setHidden:YES];

         
      self.currentTool = [self toolWithCurrentSettings];
         NSLog(@"TWO FINGERS TOUCHING RIGHT NOW");
      //self.currentTool = nil;
        [self setNeedsDisplay];
        return;
    }
    
    else {

        
      
        
        
   	if(self.editMode == NO&&self.drawTool != ACEDrawingToolTypeText){
       // if( self.drawTool != ACEDrawingToolTypeText){

      if(self.drawTool == ACEDrawingToolTypeEraser){
        self.TouchTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(showLoupe:)
                                                         userInfo:nil
                                                          repeats:NO];
        }else{
            
          
            
         
            self.TouchTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                                  target:self
                                                                selector:@selector(showLoupe2:)
                                                                userInfo:nil
                                                                 repeats:NO];
            
        }
    
    
        

        
        self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineWidthNew = self.lineWidth;
        
        UITouch *touch = [touches anyObject];
      
        [self.currentTool setInitialPoint:[touch locationInView:self]];

        
           CGPoint touchedPoint = [[touches anyObject]locationInView:self];
          
        CGPoint discoveryPoint;
           CGFloat tolerance = 7;
           // Had to Create these two arrays because there's no such thing as [NSDictionary objectAtIndex:]
           NSArray *pointsArray;

           CGFloat keyOfPointWithMinDistance = -1;
           CGPoint nearestPointToTouchedPoint = CGPointZero;
           int index = 0;
           int keyIndex = NSNotFound;

           for (NSValue * cgpointVal in arrayOfPoints){

               discoveryPoint = cgpointVal.CGPointValue;

               if (fabs(touchedPoint.x - discoveryPoint.x)<tolerance && fabs(touchedPoint.y - discoveryPoint.y)<tolerance) {
                   //Calculating the distance between points with touchedPoint in their range(Square) and adding them to an array.
                   CGFloat distance = hypotf(touchedPoint.x - discoveryPoint.x, touchedPoint.y - discoveryPoint.y);
        
                  // if (keyOfPointWithMinDistance == -1 || keyOfPointWithMinDistance < distance) {
                       if ( keyOfPointWithMinDistance < distance) {
                       keyOfPointWithMinDistance = distance;
                       nearestPointToTouchedPoint = discoveryPoint;
                       keyIndex = index;
                                              
                       [self.currentTool setInitialPoint:[cgpointVal CGPointValue]];
                       replacedPoint = YES;
                       pointToReplaceInArray = [cgpointVal CGPointValue];
                   }
              
                   index++;
               
               }
              
            
           }
           //Update self.pointsArray using keyIndex

           if (keyIndex != NSNotFound) {

           }


        
        
        
        
        
        
        
        self.firstTouch = [touch locationInView:self];
        pointOfStart = [touch locationInView:self];
   // }
        
        
        
        
         self.pointsLabel.text = NSStringFromCGPoint(self.firstTouch);
        
        
        CGPoint pointTempCoord;
        int dist;
        NSMutableArray * arrayOfDist = [[NSMutableArray alloc]init];
        for(int i=0;i<self.pointsCoord.count;i++){
        
            pointTempCoord = [[self.pointsCoord objectAtIndex:i] CGPointValue];
            
            dist = hypot((self.firstTouch.x-pointTempCoord.x), (self.firstTouch.y-pointTempCoord.y));
    
            
            [arrayOfDist addObject:[NSNumber numberWithInt:dist]];
            
           
            
            if(dist<=10){
                self.firstTouch = pointTempCoord;
                [self.currentTool setInitialPoint:pointTempCoord];
            }
            
     
        
        }
        
        

        
      /*  if (self.drawTool == ACEDrawingToolTypeArrow){
         
            
            if((self.firstTouch.x - arrowEndPoint.x <= 5)&&(self.firstTouch.x - arrowEndPoint.x >= -5)){
                
               self.firstTouch = CGPointMake(arrowEndPoint.x, self.firstTouch.y);
              
                
                [self.currentTool setInitialPoint:self.firstTouch];

                
                if(!performedX){
                    [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                    performedX = true;
                }
                
            }else{ performedX = false;}
            
            
            if((self.firstTouch.y - arrowEndPoint.y <= 5)&&(self.firstTouch.y - arrowEndPoint.y >= -5)){
                
                self.firstTouch = CGPointMake(self.firstTouch.x,arrowEndPoint.y);
               
                [self.currentTool setInitialPoint:self.firstTouch];

                if(!performedY){
                    [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                    performedY = true;
                }
                
            }
            else
            {
                performedY = false;
            }

            
            
            
        }
        */
        // call the delegate
        if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
           [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
    }
    else if (self.editMode == YES && self.drawTool!=ACEDrawingToolTypeText){
     
        
        
        UITouch *touch = [touches anyObject];
       CGPoint t = [touch locationInView:self];
        
        
        
        
        
       self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineColor = self.lineColor;
      self.currentTool.lineWidthNew = self.lineWidth;

    
        
        //	CGPoint t = [(UITouch *)[touches anyObject] locationInView:self];
        
        
        
        // [self.currentTool setInitialPoint:[touch locationInView:self]];
        
        //BezierView *bv = (BezierView *)self;
        
        // Yes, this is ugly.  It's prototype, so I don't care
        
        
        //[self.currentTool moveFromPoint:firstPoint toPoint:lastPoint];
        NSLog(@"I set coordinates");
       
        ACEDrawingView *bv = (ACEDrawingView *)self;
      
       if(self.drawTool == ACEDrawingToolTypeCurve||self.drawTool == ACEDrawingToolTypeDashCurve){
           
           dot.alpha = 0;
           dot2.alpha = 0;
           
           
           
        double adist = dist(t,bv.a);
        double bdist = dist(t,bv.b);
        double cdist = dist(t,bv.c);
        double ddist = dist(t,bv.d);
        
            
        double mindist = fmin(fmin(adist, bdist),fmin(cdist,ddist));
         
           
           
       if (mindist == bdist) {
            changer = @selector(setB:);
        } else if (mindist == adist) {
            changer = @selector(setA:);
        } else if (mindist == cdist) {
            changer = @selector(setC:);
        } else if ( mindist == ddist){
            changer = @selector(setD:);
        }
      
       }
           
           
    }
        
    }
    
   


       
        
    
}


- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    
     UITouch *touch = [touches anyObject];
    pointForLoupe = [touch locationInView:self.window];
    
    
    unsigned long count = [[event allTouches] count];

    
   if (count > 1) {
       // UITouch *touch = [touches anyObject];
        //CGPoint previousLocation = [touch previousLocationInView:self];
        //[self.currentTool moveFromPoint:previousLocation toPoint:previousLocation];
        self.currentTool = nil;
        [self setNeedsDisplay];
        return;
        
    }
    
    else {
        
    if(self.editMode == NO){
        
        if (self.magnifierView.hidden == NO && count ==1){
            
            self.magnifierView.pointToMagnify = [[touches anyObject] locationInView:self.window];
            
            

         //   self.Ruler.pointToShowRuler = [[touches anyObject] locationInView:self.window];
            
            
            
            
            
       }
        

        self.currentTool.lineColor = self.lineColor;
        
    self.currentTool.lineWidthNew = self.lineWidth;

        touchMove  = [touches count];
        

        UITouch *touch = [touches anyObject];
       touch = [touches anyObject];
        
        
        
        
        // add the current point to the path
        CGPoint currentLocation = [touch locationInView:self];
        CGPoint previousLocation = [touch previousLocationInView:self];
        
        
        if(self.drawTool == ACEDrawingToolTypeEraser)
        {
            self.eraserPointer.center = CGPointMake(currentLocation.x, currentLocation.y);

           
        }
        
        
        
     // if(self.drawTool != ACEDrawingToolTypeEraser && self.drawTool != ACEDrawingToolTypeCurve&& self.drawTool != ACEDrawingToolTypePen && self.drawTool !=ACEDrawingToolTypeDashCurve){
   if(self.drawTool != ACEDrawingToolTypeEraser && self.drawTool != ACEDrawingToolTypePen && self.editMode!=YES){
         
       
       if(replacedPoint == YES){
           
           firstOrReplacedPoint = pointToReplaceInArray;
           
       }
       else{
           
           firstOrReplacedPoint = self.firstTouch;
       }
       
          self.lastTouch = currentLocation;
       
          double dist = hypot((firstOrReplacedPoint.x-self.lastTouch.x), (firstOrReplacedPoint.y-self.lastTouch.y));
          
          distGlobal =hypot((firstOrReplacedPoint.x-self.lastTouch.x), (firstOrReplacedPoint.y-self.lastTouch.y));
          
         // NSLog(@"Current distance %f",dist);
          

          CGFloat f = [self pointPairToBearingDegrees:firstOrReplacedPoint secondPoint:self.lastTouch];
          
        //  NSLog(@"DEGREE IS %f",f);
          /////////////////////////// 45  degree ////////////
          if ((f<=48)&&(f>=42)&&dist>15){
            
              double angle =   0.785398163;
              double endX = cos(angle) * dist + firstOrReplacedPoint.x;
              double endY = sin(angle) * dist + firstOrReplacedPoint.y;
              
              self.lastTouch = CGPointMake(endX, endY);
              
            
              
              
            if(!performed45){
                  [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performed45 = true;
              }
              
          }else{ performed45 = false;}
          
          ////////////////// 135 DEGREE //////////////////
          if ((f<=138)&&(f>=132)&&dist>15){
              
              double angle =   2.35619449;
              double endX = cos(angle) * dist + firstOrReplacedPoint.x;
              double endY = sin(angle) * dist + firstOrReplacedPoint.y;
              
              self.lastTouch = CGPointMake(endX, endY);
              
              if(!performed135){
                  [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performed135 = true;
              }
              
          }else{ performed135 = false;}
          ////////////////// 225 DEGREE //////////////////
          if ((f<=228)&&(f>=222)&&dist>15){
              
              double angle =   3.92699082;
              double endX = cos(angle) * dist +firstOrReplacedPoint.x;
              double endY = sin(angle) * dist + firstOrReplacedPoint.y;
              
              self.lastTouch = CGPointMake(endX, endY);
              
              if(!performed225){
                  [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performed225 = true;
              }
              
          }else{ performed225 = false;}
          
          
          ////////////////// 315 DEGREE //////////////////
          if ((f<=318)&&(f>=312)&&dist>15){
              
              double angle =   5.49778714;
              double endX = cos(angle) * dist + firstOrReplacedPoint.x;
              double endY = sin(angle) * dist + firstOrReplacedPoint.y;
              
              self.lastTouch = CGPointMake(endX, endY);
              
              if(!performed315){
                  [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performed315 = true;
              }
              
          }else{ performed315 = false;}
          
          
          
          
          if((self.lastTouch.x - firstOrReplacedPoint.x <= 6)&&(self.lastTouch.x - firstOrReplacedPoint.x >= -6)&&dist>15){
             
              self.lastTouch = CGPointMake(firstOrReplacedPoint.x, self.lastTouch.y);
              
              
              if(!performedX){
              [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performedX = true;
              }
             
          }else{ performedX = false;}
          
          
          if((self.lastTouch.y - firstOrReplacedPoint.y <= 6)&&(self.lastTouch.y - firstOrReplacedPoint.y >= -6)&&dist>15){
              
              self.lastTouch = CGPointMake(self.lastTouch.x, firstOrReplacedPoint.y);
              if(!performedY){
                  [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
                  performedY = true;
              }
          
          }
          else
          {
              performedY = false;
          }
          self.currentTool.lineColor = self.lineColor;
          self.currentTool.lineWidthNew = self.lineWidth;
          [self.currentTool moveFromPoint:self.firstTouch toPoint:self.lastTouch];
       }
        
      else {
        
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineWidthNew = self.lineWidth;
        [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
          self.lastTouch = currentLocation;
          
      }
       
#if PARTIAL_REDRAW
     
        // calculate the dirty rect
        CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
        CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
        CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
        CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
        [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
        
#else
      
        [self setNeedsDisplay];
       

#endif
        
    }
    
    
   else if (self.editMode == YES){
       
      self.currentTool.lineColor = self.lineColor;
     self.currentTool.lineWidthNew = self.lineWidth;

        NSLog(@"This is touches moved method" );
        UITouch *touch = [touches anyObject];
    
        CGPoint previousLocation = [touch previousLocationInView:self];
        CGPoint currentLocation = [touch locationInView:self];
       NSLog(@"Current X = %f Current Y = %f", currentLocation.x, currentLocation.y);
       touchesForEditMode = [touches count];
       
        //            [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
       
       ACEDrawingView *bv = (ACEDrawingView *)self;
     
        self.currentTool.d = bv.d;
        self.currentTool.b = bv.b;            
        self.currentTool.c = bv.c;
        self.currentTool.a = bv.a;
      
       CGPoint curX;
       
       curX.x = currentLocation.y;
       curX.y = currentLocation.x;

    screenRect = [[UIScreen mainScreen] bounds];
      
    screenHeight = screenRect.size.height;
       
     //  if (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) &&
       //if ((screenHeight == 736)||(screenHeight==667 )||(screenHeight == 812)||(screenHeight==568 )){
       
       
 
       
       
       
       NSString *ver = [[UIDevice currentDevice] systemVersion];
       float ver_float = [ver floatValue];
       
       
       //float screen_scale = [[UIScreen mainScreen]scale];
       
       float screen_scale = [[UIScreen mainScreen]scale];
       
       
       NSLog(@"IOS VERSION = %f", ver_float);
       
       NSLog(@"SCREEN SCALE = %f", screen_scale);
    
       
       
    
     
     if(([[UIScreen mainScreen]scale] >= 2.0)&& (ver_float <= 14.0)){
    
           ((void(*)(id, SEL, CGPoint))objc_msgSend)(self, changer,curX);
      
       }
        
        if  ([[UIScreen mainScreen]scale] < 2.0){
        
              
           ((void(*)(id, SEL, CGPoint))objc_msgSend)(self, changer, currentLocation);
           
           
       }
    
     if (([[UIScreen mainScreen]scale] >= 2.0)&&(ver_float >= 13.0)){
           
           ((void(*)(id, SEL, CGPoint))objc_msgSend)(self, changer, currentLocation);
           
       }
     

   
       
       [self setNeedsDisplay];
    
    }

    }
    
}
    
    
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   

    [self.eraserPointer removeFromSuperview];
    [self.touchTimer invalidate];
    [self.magnifierView setHidden:YES];
    [self.Ruler setHidden:YES];

    
    NSLog(@"Touches Ended UPPPPP");
    
    
    if(touchMove ==0) {
        
        touchMove = 0;
        return;
        
    }
    unsigned long count = [[event allTouches] count];
    if (count > 1) {
        
        
    //self.currentTool = nil;
    [self setNeedsDisplay];
        
        return;
        
    }
    else {
    if(self.editMode == NO && self.drawTool != ACEDrawingToolTypeText ){
       
        
        if((self.drawTool != ACEDrawingToolTypeCurve)&&(self.drawTool !=ACEDrawingToolTypeDashCurve)){
            
         
        [self touchesMoved:touches withEvent:event];
            if(self.currentTool!=nil){
        [self.pathArray addObject:self.currentTool];
            }
            else{return;}
        }
       // UITouch *touch = [touches anyObject];
       // CGPoint currentLocation = [touch locationInView:self];
        
       // lastPoint = [touch  locationInView:self];
        
        pa = self.currentTool.d;
        pb = self.currentTool.d;
        pc = self.currentTool.c;
        pd = self.currentTool.c;
        
        ACEDrawingView *bv = (ACEDrawingView *)self;
        
        
        if(self.drawTool != ACEDrawingToolTypeCurve && self.drawTool !=ACEDrawingToolTypeDashCurve){
            
        if (self.drawTool != ACEDrawingToolTypePen && self.drawTool != ACEDrawingToolTypeEraser){
      
    
            self.currentTool.lineColor = self.lineColor;
           self.currentTool.lineWidthNew = self.lineWidth;

            
            
            if(replacedPoint == YES){
                
                firstOrReplacedPoint = pointToReplaceInArray;
                
            }
            else{
                
                firstOrReplacedPoint = self.firstTouch;
            }
            
            
            
            double dist = hypot((firstOrReplacedPoint.x-self.lastTouch.x), (firstOrReplacedPoint.y-self.lastTouch.y));
            
           if((self.lastTouch.x - firstOrReplacedPoint.x <= 6)&&(self.lastTouch.x - firstOrReplacedPoint.x >= -6)&&dist>15){
               
                
                self.lastTouch = CGPointMake(firstOrReplacedPoint.x, self.lastTouch.y);
                
            }
            if((self.lastTouch.y - firstOrReplacedPoint.y <= 6)&&(self.lastTouch.y - firstOrReplacedPoint.y >= -6)&&dist>15){
                
                  self.lastTouch = CGPointMake(self.lastTouch.x, firstOrReplacedPoint.y);
    
            }
            
           /* if (self.drawTool == ACEDrawingToolTypeArrow){
                
                arrowEndPoint = self.lastTouch;
            }
          */
            
             [self.currentTool moveFromPoint:self.firstTouch toPoint:self.lastTouch];
        }
            
            [self updateCacheImage:NO];
            
        }
        
        self.currentTool = nil;
        
        // clear the redo queue
        [self.bufferArray removeAllObjects];
        [self.bufferOfPoints removeAllObjects];
        
        
        // call the delegate
        if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
            [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
            
        }
       /* if(distGlobal==0){
            
            [self undoLatestStep];
        }*/
    

        //BezierView *bv = (BezierView*)self;
        bv.d = pd;
        bv.a = pa;
        bv.b = pb;
        bv.c = pc;
        
        //pmid.x = (pd.x + pc.x)/2;
        //pmid.y = (pd.y + pc.y)/2;
    }
    else
    {
    
        
        NSLog(@"This is  touches endeddddd");
}

        if(self.drawTool == ACEDrawingToolTypeCurve||self.drawTool == ACEDrawingToolTypeDashCurve){
            
            
   //   [self.currentTool moveFromPoint:self.firstTouch toPoint:self.lastTouch];
if(self.editMode == NO){
            dot.alpha = 1;
            dot2.alpha = 1;

            dot.frame = CGRectMake(self.firstTouch.x-5, self.firstTouch.y-5, 10, 10);
            dot2.frame = CGRectMake(self.lastTouch.x-5, self.lastTouch.y-5, 10, 10);
}
            [self setEditMode];
            [self.currentTool draw2];
            NSLog(@"EDIT MODE ACTIVATED");

    }
    }
    
    
    if (replacedPoint == YES&&self.editMode == NO){
        
        [arrayOfPoints addObject:  [NSValue valueWithCGPoint:pointToReplaceInArray]];
        [arrayOfPoints addObject:  [NSValue valueWithCGPoint:self.lastTouch]];
        replacedPoint = NO;
    }
    else if (replacedPoint == NO&&self.editMode == NO)
    {
    [arrayOfPoints addObject:  [NSValue valueWithCGPoint:self.firstTouch]];
    [arrayOfPoints addObject:  [NSValue valueWithCGPoint:self.lastTouch]];
    }

    
    NSLog(@"POINTS COUNT %lu",arrayOfPoints.count);

 
    
  
}






-(void)setEditMode
{
    
    
    

    [self.delegate setButtonVisible];
    //[self.btn setEnabled:YES];
    //[self.btn setHidden:NO];
    self.editMode = YES;
    
    ACEDrawingView *bv = (ACEDrawingView *)self;
    
    self.currentTool.d = pd;
    self.currentTool.b = pc;
    self.currentTool.c = pd;
    self.currentTool.a = pc;
    
}
/*
 - (void)addMyButton
 {    // Method for creating button, with background image and other properties
 
 UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 btn.frame = CGRectMake(100, 100, 100, 50);
 [btn setTitle:@"Hello, world!" forState:UIControlStateNormal];
 [btn addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
 [self addSubview:btn];
 }
 */



///////////////////////////////////////////////////////////////////////////////////

 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
  // [self touchesEnded:touches withEvent:event];
    [self.eraserPointer removeFromSuperview];

        [self.touchTimer invalidate];
        [self.magnifierView setHidden:YES];
        [self.Ruler setHidden:YES];
}

-(void)updateImage
{
  
     if(self.drawTool == ACEDrawingToolTypeCurve ||self.drawTool == ACEDrawingToolTypeDashCurve ){
    ACEDrawingView *bv = (ACEDrawingView *)self;
    
    self.currentTool.d = bv.d;
    self.currentTool.b = bv.b;
    self.currentTool.c = bv.c;
    self.currentTool.a = bv.a;
 	
    pa = self.currentTool.d;
    pb = self.currentTool.d;
    pc = self.currentTool.c;
    pd = self.currentTool.c;
         
         
    
     }
    

    [arrayOfPoints addObject:  [NSValue valueWithCGPoint:self.currentTool.a]];
    [arrayOfPoints addObject:  [NSValue valueWithCGPoint:self.currentTool.d]];
    
    NSLog(@"POINTS Coordinates %@ %@", NSStringFromCGPoint(self.currentTool.a),NSStringFromCGPoint(self.currentTool.d));

    
    
    
    [self.pathArray addObject:self.currentTool];
    
    
    [self updateCacheImage3:NO];
    // clear the current tool
    self.currentTool = nil;
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    [self.bufferOfPoints removeAllObjects];

    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
        
    }
   [self setNeedsDisplay];
    touchMove = 0;
       
    
}
#pragma mark - Actions

- (void)clear
{
    [self.bufferArray removeAllObjects];
    [self.bufferOfPoints removeAllObjects];

    [self.pathArray removeAllObjects];
    [arrayOfPoints removeAllObjects];

    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
    return self.bufferOfPoints.count;

}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
    return arrayOfPoints.count > 0;

}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        id<ACEDrawingTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        
        [self.bufferOfPoints addObject:[arrayOfPoints lastObject]];
        [arrayOfPoints removeLastObject];
        [self.bufferOfPoints addObject:[arrayOfPoints lastObject]];
        [arrayOfPoints removeLastObject];


        [self updateCacheImage:YES];
        [self setNeedsDisplay];
        
        NSLog(@"POINTS COUNT %lu",arrayOfPoints.count);

    }
    
    
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
    return self.bufferOfPoints.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        id<ACEDrawingTool>tool = [self.bufferArray lastObject];
        
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];

        
        [arrayOfPoints addObject:[self.bufferOfPoints lastObject]];
        [self.bufferOfPoints removeLastObject];
        [arrayOfPoints addObject:[self.bufferOfPoints lastObject]];
        [self.bufferOfPoints removeLastObject];

        [self updateCacheImage:YES];
        [self setNeedsDisplay];
        NSLog(@"POINTS COUNT %lu",arrayOfPoints.count);

    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.TextView = nil;
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    [super dealloc];
}




#endif


#pragma mark - Pixel Color
/*- (UIColor *)colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height), point)) {
        return nil;
    }
    
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = [self.delegate imageFromDrawView].CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, -pointY);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
*/

- (NSString *)hexStringFromColorNEW:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}


#pragma mark - Shape management


- (void)addShapeWhenDrawing
{
  //  CGRect maxBounds = CGRectInset(self.bounds, 10.0f, 10.0f);
    //Shape *newShape = [Shape randomShapeInBounds:maxBounds];
    
     CAShapeLayer *line = [CAShapeLayer layer];
     linePath=[UIBezierPath bezierPath];
     [linePath moveToPoint: self.firstTouch];
     [linePath addLineToPoint:self.lastTouch];

    // [line setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.firstTouch.x-5,self.firstTouch.y-5, 10, 10)] CGPath]];
     
     line.path=linePath.CGPath;
     line.fillColor = nil;
     line.lineWidth = 4.0;
     //line.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],[NSNumber numberWithInt:8], nil];
    
     line.opacity = 1.0;
     line.strokeColor = [UIColor redColor].CGColor;
     line.accessibilityPath = linePath;
     [drawingLayer addSublayer:line];
    
}



@end
