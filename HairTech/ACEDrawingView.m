

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"
#import "DrawViewControllerRight.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/objc.h>
#import <objc/message.h>
#import "HapticHelper.h"
#import "CHMagnifierView.h"
#import "Ruler.h"
#import <CoreGraphics/CoreGraphics.h>
#import "DrawViewController.h"

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

@property (nonatomic, assign) BOOL isFirstTouch;//区分点击与滑动手势
@property (nonatomic, assign) JVDrawingTouch isMoveLayer;//区分移动还是创建path 如果移动 移动哪里
@property (nonatomic, strong) JVDrawingLayer *drawingLayer;//当前创建的path
@property (nonatomic, strong) JVDrawingLayer *selectedLayer;//当前选中的path
@property (nonatomic, strong) NSMutableArray *layerArray;//当前创建的path集合





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



@synthesize dataSource = _dataSource;

@synthesize a,b,c,d,pa,pb,pc,pd, touchesCount,touchesForEditMode;
//@synthesize textView;
@synthesize touchForText;
@synthesize editModeforText;
@synthesize touchCoord;
@synthesize pointForRecognizer;
@synthesize pan;
@synthesize touchesForUpdate;



@synthesize tapRecognizer;
@synthesize panRecognizer;

CGFloat red;
CGFloat green;
CGFloat blue;
CGFloat alpha;
UIColor* tempColor;


//- (instancetype)init {
//    if (self = [super init]) {
//        self.userInteractionEnabled = YES;
//        self.frame = [UIScreen mainScreen].bounds;
//        self.layerArray = [[NSMutableArray alloc] init];
//        self.type = JVDrawingTypeGraffiti;
//    }
//    return self;
//}

- (BOOL)revoke {
    BOOL status = [self.selectedLayer revokeUntilHidden];
    if (status) {
        [self.selectedLayer removeFromSuperlayer];
        [self.layerArray removeObject:self.selectedLayer];
        self.selectedLayer = nil;
    }
    return status;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isFirstTouch = YES;
    self.isMoveLayer = NO;
    if (self.type == JVDrawingTypeText){
        gestureRecognizer.enabled = YES;
        gestureRecognizer2.enabled = YES;
    }
    else {
        gestureRecognizer.enabled = NO;
        gestureRecognizer2.enabled = NO;
    }
    if (self.selectedLayer.type != JVDrawingTypeCurvedLine ||self.selectedLayer.type != JVDrawingTypeCurvedDashLine ){
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                       target:self
                                                     selector:@selector(showLoupe2:)
                                                     userInfo:nil
                                                      repeats:NO];
    }
    if (UIMenuController.sharedMenuController.isMenuVisible) {
        [UIMenuController.sharedMenuController setMenuVisible:NO animated:YES];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.eraserSelected || self.type == JVDrawingTypeText ){
        return;
    }
    unsigned long count = [[event allTouches] count];
    if (count > 1) {
        return; // return amount of fingers touched right now
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    pointForLoupe = [touch locationInView:self.window]; //point where loupe will be shown
    self.type = self.bufferType;

    
    if (self.isFirstTouch) {

//        if (self.selectedLayer && [self.selectedLayer caculateLocationWithPoint:currentPoint]) {
//            self.isMoveLayer = [self.selectedLayer caculateLocationWithPoint:currentPoint];
      
            if (self.selectedLayer && [self.selectedLayer isPoint:currentPoint withinDistance:12 ofPath:self.selectedLayer.path]){
                self.isMoveLayer = [self.selectedLayer caculateLocationWithPoint:currentPoint];
                
            }
         else {
             if ( self.type != JVDrawingTypeText ){
            [self removeCircles];
            self.drawingLayer = [JVDrawingLayer createLayerWithStartPoint:previousPoint type:self.type lineWidth:self.lineWidth lineColor:self.lineColor];
            [self.layer addSublayer:self.drawingLayer];
             }
             }
    } else {
        if (self.isMoveLayer) {
            if (self.selectedLayer.type == JVDrawingTypeGraffiti) {
                [self.selectedLayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
                // Curved line creating and moving
            } else if (self.selectedLayer.type == JVDrawingTypeCurvedLine || self.selectedLayer.type == JVDrawingTypeCurvedDashLine) {
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                        [self.selectedLayer movePathWithStartPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer1 atIndex:0];
                        break;
                    case JVDrawingTouchMid:
                        [self.selectedLayer moveControlPointWithPreviousPoint:currentPoint];
                        [self controlCirclePosition:currentPoint  forLayer:self.circleLayer3 atIndex:0];
                        break;
                    case JVDrawingTouchEnd:
                        [self.selectedLayer movePathWithEndPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer2 atIndex:0];
                        break;
                    
                    default:
                        break;
                }
            }
            else if (self.selectedLayer.type == JVDrawingTypeText) {
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                        [self.selectedLayer moveTextWithStartPoint:currentPoint ofRect:self.textRect.frame];
                        [self circlePosition:currentPoint forLayer:self.circleLayer1 atIndex:0];
                        break;
                    case JVDrawingTouchMid:
                        [self.selectedLayer movePathWithPreviousPoint:previousPoint currentPoint:currentPoint];
                        //[self controlCirclePosition:currentPoint  forLayer:self.circleLayer3 atIndex:0];
                        break;
                    case JVDrawingTouchEnd:
                        [self.selectedLayer moveTextWithEndPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer2 atIndex:0];
                        break;
                        
                    default:
                        break;
                }
                
            }
            else {
                
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                        [self.selectedLayer movePathWithStartPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer1 atIndex:0];
                        if (self.magnifierView.hidden == NO && count ==1){
                            self.magnifierView.pointToMagnify = [[touches anyObject] locationInView:self.window];
                        }
                        break;
                    case JVDrawingTouchMid:
                        [self hideLoupe]; // hide loupe when middle touched
                        [self.selectedLayer movePathWithPreviousPoint:previousPoint currentPoint:currentPoint];
                        [self circlePosition:self.selectedLayer.startPmoving point2:self.selectedLayer.endPmoving forBothLayers:self.circleLayer1 circle2:self.circleLayer2];
                        break;
                    case JVDrawingTouchEnd:
                        [self.selectedLayer movePathWithEndPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer2 atIndex:0];
                        if (self.magnifierView.hidden == NO && count ==1){
                            self.magnifierView.pointToMagnify = [[touches anyObject] locationInView:self.window];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        } else {
            NSLog(@"end of creation of line");
            [self.drawingLayer movePathWithEndPoint:currentPoint];
            if (self.magnifierView.hidden == NO && count ==1){
                self.magnifierView.pointToMagnify = [[touches anyObject] locationInView:self.window];//show Loupe
            }
        }
    }
    
    self.isFirstTouch = NO;
}

- (void)setSelectedLayer:(JVDrawingLayer *)selectedLayer {
    _selectedLayer = selectedLayer;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideLoupe];
    if (![self.layerArray containsObject:self.drawingLayer] && !self.isFirstTouch) {
        [self.layerArray addObject:self.drawingLayer];
        [self.drawingLayer addToTrack];
    } else {
        if (self.isMoveLayer) {
            [self.selectedLayer addToTrack];
        }
        if (self.isFirstTouch) {
            
            BOOL layerHasBeenPicked = NO;
            
            UITouch *touch = [touches anyObject];
            CGPoint currentPoint = [touch locationInView:self];
            for (JVDrawingLayer *layer in self.layerArray) {
                //if ([layer caculateLocationWithPoint:currentPoint]) {
                if ([layer isPoint:currentPoint withinDistance:8 ofPath:layer.path]){
                    [layer caculateLocationWithPoint:currentPoint];
                    // tapped on a layer
                    layerHasBeenPicked = YES;
                    if (layer == self.selectedLayer && !menuVisible) {
                        // the layer is already selectedl; show the menu
                        [self showMenu];
                    } else {
                        // clear the selection
                        self.selectedLayer.isSelected = NO;
                        [self removeCircles];
                        [self hideMenu];
                        
                        // draw new selection
                        self.selectedLayer = layer;
                        self.selectedLayer.isSelected = YES;
                        [self.layer insertSublayer:layer above:[self.layerArray lastObject]];
                        [self.layerArray removeObject:self.selectedLayer];
                        [self.layerArray addObject:self.selectedLayer];
                        self.type = self.selectedLayer.type;
                        [self placeCirclesAtLine:layer];
                        
                    }
                    break;
                }
            } //-for
            
            // if no layer has been picked up by the tap, remove the selection
            if (!layerHasBeenPicked) {
                self.selectedLayer.isSelected = NO;
                self.selectedLayer = nil;
                [self removeCircles];
                [self hideMenu];
            }
            
            //       self.drawingLayerSelectedBlock(self.selectedLayer);
        }
    }
}

-(void)placeCirclesAtLine:(JVDrawingLayer*)layer{
    if (JVDrawingTypeCurvedLine == self.type || JVDrawingTypeCurvedDashLine == self.type){
        self.circleLayer1 = [CircleLayer addCircleToPoint:layer.startP scaleFactor:self.zoomFactor];
        self.circleLayer2 = [CircleLayer addCircleToPoint:layer.endP scaleFactor:self.zoomFactor];
        self.circleLayer3 = [CircleLayer addCircleToPoint:layer.midP scaleFactor:self.zoomFactor];
        [layer addSublayer:self.circleLayer1];
        [layer addSublayer:self.circleLayer2];
        [layer addSublayer:self.circleLayer3];
        [self.arrayOfCircles addObject:self.circleLayer1];
        [self.arrayOfCircles addObject:self.circleLayer2];
        [self.arrayOfCircles addObject:self.circleLayer3];
    } else {
        self.circleLayer1 = [CircleLayer addCircleToPoint:layer.startP scaleFactor:self.zoomFactor];
        self.circleLayer2 = [CircleLayer addCircleToPoint:layer.endP scaleFactor:self.zoomFactor];
        [layer addSublayer:self.circleLayer1];
        [layer addSublayer:self.circleLayer2];
        [self.arrayOfCircles addObject:self.circleLayer1];
        [self.arrayOfCircles addObject:self.circleLayer2];
    }
}

-(void)controlCirclePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-4 / self.zoomFactor, point.y-4 / self.zoomFactor, 8 / self.zoomFactor, 8 / self.zoomFactor)];
    circle.path = circlePath.CGPath;
}

-(void)circlePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-4 / self.zoomFactor, point.y-4 / self.zoomFactor, 8 / self.zoomFactor, 8 / self.zoomFactor)];
    circle.path = circlePath.CGPath;
}

-(void)circlePosition:(CGPoint)point point2:(CGPoint)point2 forBothLayers:(CircleLayer*)circle circle2:(CircleLayer*)circle2{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-4 / self.zoomFactor, point.y-4 / self.zoomFactor,8 / self.zoomFactor, 8 / self.zoomFactor)];
    UIBezierPath *circlePath2 = [UIBezierPath bezierPath];
    circlePath2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point2.x-4 / self.zoomFactor, point2.y-4 / self.zoomFactor, 8/self.zoomFactor, 8/self.zoomFactor)];
    circle.path = circlePath.CGPath;
    circle2.path = circlePath2.CGPath;
}

-(void)removeCircles{
    [self.arrayOfCircles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.arrayOfCircles removeAllObjects];
    self.selectedLayer = nil;
    self.selectedLayer.isSelected = NO;
//    if (self.textViewNew.hidden == NO){
//    [self hideTextViewAndRect];
//    }
}
-(void)hideTextViewAndRect {
    
//    [self.textRect removeFromSuperlayer];
//    [self.textViewNew resignFirstResponder];
//    [self.textViewNew setHidden:YES];
}
-(void)updateZoomFactor:(CGFloat)zoomFactor{
    [self.touchTimer invalidate];
    [self.magnifierView setHidden:YES];
    
    self.zoomFactor = zoomFactor;
    self.drawingLayer.zoomFactor = zoomFactor;
    [self removeCirclesOnZoom];
}

-(void)removeCirclesOnZoom{
    self.selectedLayer.isSelected = NO;
    self.selectedLayer = nil;
    [self removeCircles];
    [self setNeedsDisplay];
}
-(void)removeCirclesOnZoomDelegate{
    self.selectedLayer.isSelected = NO;
    self.selectedLayer = nil;
    [self removeCircles];
    [self setNeedsDisplay];
}

#pragma mark ShowDeleteMenu
- (BOOL) canBecomeFirstResponder
{
    return YES;
}
- (void)showMenu {
        CGPoint middlePoint = CGPointZero;
        CGRect rectOfMenu;
        if (self.isMoveLayer){
            middlePoint = midsPoint(self.selectedLayer.startP, self.selectedLayer.endP);
        }else{
            middlePoint = midsPoint(self.selectedLayer.startPmoving, self.selectedLayer.endPmoving);
        }
    if (JVDrawingTypeCurvedLine == self.type || JVDrawingTypeCurvedDashLine == self.type){
        rectOfMenu = CGRectMake(self.selectedLayer.midPmoving.x,self.selectedLayer.midPmoving.y,0,0) ;
    } else {
        rectOfMenu = CGRectMake(middlePoint.x, middlePoint.y, 0, 0);

    }
        if (@available(iOS 13.0, *)) {
            NSLog(@"IOS ABOVE 13");
            [self becomeFirstResponder];
            menu = [UIMenuController sharedMenuController];
            menu.menuItems = @[
                [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)]];
            [menu showMenuFromView:self rect:rectOfMenu];
        } else {
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            menu.menuItems = @[
                [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)]];
            [menu setTargetRect:rectOfMenu inView:self];
            [menu setMenuVisible:YES animated:YES];
        }
    menuVisible = YES;
}
-(void)hideMenu {
    
    if (menu.isMenuVisible) {
            [menu setMenuVisible:NO animated:YES];
        }
    menuVisible = NO;
}


#pragma mark Add Text View

-(void)editTextView{
    [self.textViewNew becomeFirstResponder];
    [currentlyEditingView hideEditingHandles];
    [self showTextViewFrame];

}
-(void)showTextViewFrame{
    self.textViewNew.layer.borderColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor;
    self.textViewNew.layer.borderWidth = 1.0;
}
-(void)hideTextViewFrame{
    self.textViewNew.layer.borderColor = [UIColor colorWithRed:45.0/255.0 green:107.0/255.0 blue:173.0/255.0 alpha:0.0].CGColor;
    self.textViewNew.layer.borderWidth = 1.0;

}

-(void)adjustRectWhenTextChanged:(CGRect)rect {
    CGPoint origin = [self.textViewNew convertPoint:CGPointMake(self.textViewNew.bounds.origin.x, self.textViewNew.bounds.origin.y) toView:self];
    CGRect newRect = CGRectMake(origin.x,
                                origin.y,
                                self.userResizableView.frame.size.width,
                                self.textViewNew.frame.size.height);
    [self.userResizableView newFrame:newRect.size.height];
    [self.userResizableView sizeToFit];
  
}

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView;
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView.contentView] withEvent:nil]) {
       //[self.textViewNew becomeFirstResponder];
       [currentlyEditingView showEditingHandles];
        return NO;
    }
   // [self.textViewNew resignFirstResponder];
   // [currentlyEditingView hideEditingHandles];
    return YES;
    
}
- (void)setupTextView:(const CGRect *)gripFrame {
    self.textViewNew = [[UITextView alloc] initWithFrame:*gripFrame];
    [self.textViewNew setFont:[UIFont systemFontOfSize:15]];
    self.textViewNew.textColor = [UIColor blackColor];
    self.textViewNew.text = @"TEXT";
    self.textViewNew.backgroundColor = [UIColor clearColor];
    self.textViewNew.textAlignment = NSTextAlignmentCenter;
    self.textViewNew.editable = YES;
    self.textViewNew.selectable = YES;
}

-(void)addFrameForTextView{
    
    CGRect gripFrame = CGRectMake(0, 0, 70, 55);
    self.userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    [self setupTextView:&gripFrame];
    self.userResizableView.center = self.center;
    self.userResizableView.contentView = self.textViewNew;
    self.userResizableView.delegate = self;
    [self.userResizableView showEditingHandles];
    currentlyEditingView = self.userResizableView;
    lastEditedView = self.userResizableView;
    [self addSubview:self.userResizableView];
    [self.arrayOfTextViews addObject:self.userResizableView];
   
    
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuOnTextView:)];
    [self.userResizableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.numberOfTapsRequired = 1;
   //[gestureRecognizer setDelegate:self];
    
    gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuForTextView)];
    [self addGestureRecognizer:gestureRecognizer2];
    gestureRecognizer2.numberOfTapsRequired = 1;
   // [gestureRecognizer2 setDelegate:self];
    
   
}

- (void)showMenuOnTextView:(UIGestureRecognizer*)sender {
        NSLog(@"Show menu from textview");
        CGRect rectOfMenu = CGRectMake(self.userResizableView.frame.origin.x +
                                      (self.userResizableView.frame.size.width / 2),
                                       self.userResizableView.frame.origin.y ,
                                       0, 0);
    if (self.textViewNew.isFirstResponder != YES){
        if (@available(iOS 13.0, *)) {
            NSLog(@"IOS ABOVE 13");
            [self becomeFirstResponder];
            menuForTextView = [UIMenuController sharedMenuController];
            menuForTextView.menuItems = @[
                [[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(editTextView)]];
            [menuForTextView showMenuFromView:self rect:rectOfMenu];
        } else {
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            menu.menuItems = @[
                [[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(editTextView)]];
            [menu setTargetRect:rectOfMenu inView:self];
            [menu setMenuVisible:YES animated:YES];
        }
    }

}
-(void)hideMenuForTextView{
    
    if (menuForTextView.isMenuVisible) {
            [menuForTextView setMenuVisible:NO animated:YES];
        }
    
    else if (self.textViewNew.isFirstResponder == YES){
        [self.textViewNew resignFirstResponder];
        [self hideTextViewFrame];
        [currentlyEditingView showEditingHandles];

    }
    else {
        [self.textViewNew resignFirstResponder];
        [currentlyEditingView hideEditingHandles];
        [self.userResizableView removeFromSuperview];
        [self.textViewNew removeFromSuperview];
        
    }
    menuVisible = NO;

}

- (CGFloat)getTextViewHeight{
    
    return self.textViewNew.contentSize.height + 22;
}
- (void)hideHandlesAndMenu{
    if (menuForTextView.isMenuVisible) {
            [menuForTextView setMenuVisible:NO animated:YES];
        }
    menuVisible = NO;
    
}
#pragma mark Initializattion
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
        
        self.userInteractionEnabled = YES;
        //self.frame = [UIScreen mainScreen].bounds;
        self.layerArray = [[NSMutableArray alloc] init];
        self.type = JVDrawingTypeLine;
        
        pan=NO;
        touchesForUpdate = 0;
        
        [self configure];
        
        
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
        
        arrayOfLastPoints = [[NSArray alloc]init];
        self.zoomFactor = 1;

        
    }
    return self;
}
-(void)getViewControllerId:(NSString*)nameOfView nameOfTechnique:(NSString *)techniqueName{
    
    arrayOfPoints = [[NSMutableArray alloc]init];
    NSLog(@"NAME OF CURRENT TECHNIQUE %@", techniqueName);
    currentTechniqueName = techniqueName;
    viewName = nameOfView;
    arrayOfPoints = [NSMutableArray arrayWithArray:[self retrievePointsFromDefaults:viewName techniqueName:currentTechniqueName]];
    
    for (NSString * cgpointVal in arrayOfPoints)
    {
        CGPoint pointObj = CGPointFromString(cgpointVal);
        [self alocatePointAtView:self.layer pointFromArray:pointObj];
    }
}


+ (CGRect)screenBoundsOrientationDependent {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsPortrait ([UIApplication sharedApplication].statusBarOrientation)) {
        screenRect = CGRectMake(screen.bounds.origin.x, screen.bounds.origin.y, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
    /// NSLog(@"ScreenBoundsOrientationMEthod");
}
-(void)initializeGestureRecognizers{
  
//   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.userResizableView action:@selector(tapTextView:)];
//     [self.textViewNew addGestureRecognizer:tap];
    
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
//    [self addGestureRecognizer:panRecognizer];
//    panRecognizer.enabled = NO;
//    UILongPressGestureRecognizer * longPressLine = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
//    [self addGestureRecognizer:longPressLine];
    
}

- (void)configure
{
    
    self.arrayOfCircles = [NSMutableArray array];
    [self initializeGestureRecognizers];
    touchesMoved = NO;
    self.pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 500, 40)];
    self.pointsCoord = [NSMutableArray array];
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    self.bufferOfPoints = [NSMutableArray array];
    
    [self LoadColorsAtStart];
    self.lineColor = tempColor;
    self.backgroundColor = [UIColor clearColor];
    self.pointsCoord = [NSMutableArray array];
    self.arrayOfTextViews = [NSMutableArray array];
    
}


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




-(void)drawRuler:(CGPoint)currrent_coord{
    
    
}



#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
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

-(void)updateTextView
{
   /*
    if(pan == YES)
    {
        
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
    
        
      /*
    }
    [self setNeedsDisplay];
    self.textView.text = nil;
    // editModeforText = NO;
    touchForText = 0;
    pan=NO;
    [self.delegate setButtonVisibleTextPressed];*/
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    
    
    [recognizer setTranslation:CGPointMake(0,0) inView:self];
    
    
    CGPoint p = [recognizer locationInView:self.textViewNew];
    

    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        pan = YES;
        touchesForUpdate = 0;
        
        CGPoint finalPoint = [recognizer locationInView:self];
        
        pointForRecognizer = CGPointMake(self.textViewNew.frame.origin.x,self.textViewNew.frame.origin.y);
        
        //   pointForRecognizer = CGPointMake(self.textView.center.x,self.textView.center.y);
        
    }
}


/*
-(void)addTextViewToMiddle
{
    
    pan= NO;
    self.currentTool = [self toolWithCurrentSettings];
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineWidthNew = self.lineWidth;
    
    [self.textView setHidden:NO];
    
    
    
    // self.textView.zoomEnabled = YES;
    self.textView.frame = CGRectMake((self.frame.size.width/2)-100,self.frame.size.height/3, 200,60);
  
    
    
    [self.textView becomeFirstResponder];
    self.touchForText = self.touchForText + 1;
    touchesForUpdate = 0;
}
*/

#pragma mark - Show Loupe methods
- (void)showLoupe:(NSTimer *)timer
{
    
    if ((self.magnifierView == nil)&&(countGlobal == 1)) {
        self.magnifierView = [[CHMagnifierView alloc] init];
        self.magnifierView.viewToMagnify = self.window;
        
        
    }
    
    self.magnifierView.pointToMagnify = pointForLoupe;
    
    
    [self.magnifierView makeKeyAndVisible];
}


- (void)showLoupe2:(NSTimer*)timer
{
    NSLog(@"SHOW LOUPE");
    if (self.magnifierView == nil) {
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
-(void)hideLoupe {
    [self.touchTimer invalidate];
    [self.magnifierView setHidden:YES];
}

- (void)scaleTextView:(UIPinchGestureRecognizer *)pinchGestRecognizer{
//    CGFloat scale = pinchGestRecognizer.scale;
//    
//    self.textView.font = [UIFont fontWithName:self.textView.font.fontName size:self.textView.font.pointSize*scale];
//    
//    [self textViewDidChange:self.textView];
//    
//    
//    
}


#pragma mark - Touches methods



- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}





#pragma mark drawing Circles at Line


-(void)setEditMode
{
    
    self.editMode = YES;
    
    [self.delegate setButtonVisible];
    //[self.btn setEnabled:YES];
    //[self.btn setHidden:NO];
    
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
        
        
        [arrayOfPoints addObject: NSStringFromCGPoint(self.currentTool.a)];
        [arrayOfPoints addObject: NSStringFromCGPoint(self.currentTool.d)];
        
        // [self alocatePointAtView:self.layer pointFromArray:self.currentTool.a];
        // [self alocatePointAtView:self.layer pointFromArray:self.currentTool.d];
        
        [self savePointsToDefaults:viewName techniqueName:currentTechniqueName];
        
    }
    
    
    
    
    
    [self.pathArray addObject:self.currentTool];
    
    
    [self updateCacheImage3:NO];
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    [self.bufferOfPoints removeAllObjects];
    
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
        
        
        // clear the current tool
        self.currentTool = nil;
        
        
    }
    [self setNeedsDisplay];
    touchMove = 0;
    
    
}
#pragma mark - Clear Screen

- (void)clear
{

    [self.bufferArray removeAllObjects];
    [self.bufferOfPoints removeAllObjects];
    [self.pathArray removeAllObjects];
    [arrayOfPoints removeAllObjects];
    [self savePointsToDefaults:viewName techniqueName:currentTechniqueName];
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
        [self savePointsToDefaults:viewName techniqueName:currentTechniqueName];
        
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
        [self savePointsToDefaults:viewName techniqueName:currentTechniqueName];
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


#pragma mark - Sublayers Managment

/*
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
 */


-(void)savePointsToDefaults:(NSString*)name techniqueName:(NSString*)techName
{
    name = [name stringByAppendingString:techName];
    NSLog(@"NAME IN USER DEFAULTS %@", name);
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfPoints forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(NSMutableArray*)retrievePointsFromDefaults:(NSString*)name techniqueName:(NSString*)techName
{
    
    name = [name stringByAppendingString:techName];
    NSLog(@"NAME IN USER DEFAULTS %@", name);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:name];
    arrayOfPoints = [NSMutableArray arrayWithArray:array];
    NSLog(@"ARRAY COUNT %lu", arrayOfPoints.count);
    
    return arrayOfPoints;
}



-(void)alocatePointAtView:(CALayer *)layer pointFromArray:(CGPoint)pointFromArray
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.name = @"circle";
    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pointFromArray.x-2, pointFromArray.y-2, 4, 4)];
    circle.path=circlePath.CGPath;
    circle.fillColor = nil;
    circle.opacity = 1.0;
    circle.strokeColor = [UIColor blueColor].CGColor;
    [layer addSublayer:circle];
}




@end
