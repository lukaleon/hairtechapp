#define DTDefaultLoupeMagnification    1.20f       // Match Apple's Magnification


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
#import "DotLayer.h"
#import "DiagramFile.h"
#import "ACLoupe.h"
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
static CGFloat const kACMagnifyingViewDefaultShowDelay = 0.5;

@interface ACEDrawingView ()

@property (nonatomic, assign) BOOL isFirstTouch;
@property (nonatomic, assign) JVDrawingTouch isMoveLayer;
@property (nonatomic, strong) JVDrawingLayer *drawingLayer;
@property (nonatomic, strong) JVDrawingLayer *selectedLayer;
@property (nonatomic, strong) JVDrawingLayer *temporaryLayer;
@property (nonatomic, strong) JVDrawingLayer *temporaryLayerForFliping;
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic, strong) JVDrawingLayer *lastLayerInStack;








@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

@property (nonatomic, strong) NSMutableArray *bufferOfPoints;
@property (nonatomic, strong) id<ACEDrawingTool> currentTool;

//@property (nonatomic,strong,readwrite) UIImage *image;

//@property (strong, nonatomic) NSTimer *touchTimer;
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
@synthesize viewForDot;
//@synthesize tapRecognizer;
//@synthesize panRecognizer;
//@synthesize magnifyingGlass;
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

#pragma mark Initializattion
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.magnifyingGlassShowDelay = kACMagnifyingViewDefaultShowDelay;


        
    }
    return self;
}
-(void)setMagnetActivated:(BOOL)activated{
    _magnetActivated = activated;
}
-(void)setJsonData:(NSData*)jsonData{
    _jsonData = jsonData;
}
-(void)setJsonKey:(NSString*)jsonKey{
    _jsonKey = jsonKey;
}

- (void)loadDataFromJsonOnStart:(NSData*)jsonData{
    [self fetchData:jsonData]; //fetching data from json file
    
    for(LayersData * layerData in self.arrayOfLayersForJSON){
        NSLog(@"COLOR LOADED FROM ARRAY %@", layerData.color);
        
        if (JVDrawingTypeText != [layerData.type integerValue] || JVDrawingTypeDot != [layerData.type integerValue] ){
            self.drawingLayer = [JVDrawingLayer createAllLayersAtStart:layerData.startPoint endPoint:layerData.endPoint type:[layerData.type integerValue] lineWidth:layerData.lineWidth lineColor:layerData.color controlPoint:layerData.controlPoint grafittiPoints:layerData.grafittiPoints];
            if(JVDrawingTypeGraffiti == [layerData.type integerValue] ){
                for(int i = 0; i < layerData.grafittiPoints.count;i++){
                    [self.drawingLayer movePathWithEndPoint:CGPointFromString([layerData.grafittiPoints objectAtIndex:i])];
                }
                
            } if (JVDrawingTypeCurvedLine == [layerData.type integerValue] ||JVDrawingTypeCurvedDashLine == [layerData.type integerValue] ){
                BOOL selected;
                if (CGPointEqualToPoint(layerData.controlPoint,midsPoint(layerData.startPoint, layerData.endPoint))){
                    selected = NO;
                } else {
                    selected = YES;
                }
                [self.drawingLayer movePathWithEndPoint:layerData.endPoint];
                [self.drawingLayer moveCurvedLinePathWithStartPoint:layerData.startPoint endPoint:layerData.endPoint midPoint:layerData.controlPoint isSelected:selected];
            }
            else {
                [self.drawingLayer movePathWithEndPoint:layerData.endPoint];
            }
        }
        
        if (JVDrawingTypeText == [layerData.type integerValue]) {
            
            CGRect rect = CGRectMake(layerData.startPoint.x, layerData.startPoint.y, layerData.width, layerData.height);
            self.drawingLayer = [JVDrawingLayer createTextLayerWithStartPoint:layerData.startPoint
                                                                        frame:rect
                                                                         text:layerData.text
                                                                         type:[layerData.type integerValue]
                                                                    lineWidth:layerData.lineWidth
                                                                    lineColor:layerData.color
                                                                     fontSize:layerData.fontSize
                                                                   isSelected:NO];
        }
        NSLog(@"image direction %@", layerData.imageDirection);
        if(JVDrawingTypeDot == [layerData.type integerValue]){
                    
            self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:layerData.startPoint endPoint:layerData.endPoint height:layerData.height type:[layerData.type integerValue] lineWidth:layerData.lineWidth lineColor:layerData.color scale:self.zoomFactor imageName:@"dotlayer" orientation:layerData.imageDirection];
        }
        if(JVDrawingTypeClipper == [layerData.type integerValue]){
                    
            self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:layerData.startPoint endPoint:layerData.endPoint height:layerData.height type:[layerData.type integerValue] lineWidth:layerData.lineWidth lineColor:layerData.color scale:self.zoomFactor imageName:@"clippermain" orientation:layerData.imageDirection];
        }
        if(JVDrawingTypeRazor == [layerData.type integerValue]){
            
            self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:layerData.startPoint endPoint:layerData.endPoint height:layerData.height type:[layerData.type integerValue] lineWidth:layerData.lineWidth lineColor:layerData.color scale:self.zoomFactor imageName:@"razor" orientation:layerData.imageDirection];
        }
        
        if(layerData.endPoint.x != 0 && layerData.endPoint.y !=0){
            [self.layer addSublayer:self.drawingLayer];
            [self.layerArray addObject:self.drawingLayer];
            //            NSLog(@"layerArray   %lu", self.layerArray.count );
        }
    }
}
-(CGFloat)findAngleOfLine:(CGPoint)start end:(CGPoint)end{
    CGFloat f = [self pointPairToBearingDegrees:start secondPoint:end];
    return f;
}
- (void)duplicatingLayerType:(JVDrawingLayer *)selectedL imageName:(NSString*)imgName {
    if(self.selectedLayer != nil){
        [self removeCircles];
    }
    //self.type = selectedL.type;
    CGPoint newStartPoint = CGPointMake(selectedL.startPoint.x + selectedL.height, selectedL.startPoint.y);
    self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:newStartPoint endPoint:newStartPoint  height:selectedL.height type:selectedL.type lineWidth:3 lineColor:selectedL.lineColor_ scale:self.zoomFactor imageName:imgName orientation:selectedL.imageDirection];
    
    [self.layer addSublayer:self.drawingLayer];
    [self.layerArray addObject:self.drawingLayer];
    [self.drawingLayer addToTrack];
    [self selectLayer:self.drawingLayer];
    [self.selectedLayer setZoomIndex:self.zoomFactor];
}

- (void)createCopyOfLayer:(JVDrawingLayer*)selectedL{
    
    CGPoint startPointOffset;
    CGPoint endPointOffset;
    CGPoint controlPointOffset;
    CGFloat  dist;

    NSLog(@"control point x, y = %F, %f", selectedL.controlPointOfCurve.x , selectedL.controlPointOfCurve.y);

    CGFloat f = [self findAngleOfLine:selectedL.startPoint end:selectedL.endPoint];
        
        if (((f<=60)&&(f>=30) )|| ((f<=240)&&(f>=210)) ){
            startPointOffset = CGPointMake(selectedL.startPoint.x + 20, selectedL.startPoint.y);
            endPointOffset = CGPointMake(selectedL.endPoint.x + 20, selectedL.endPoint.y);
            controlPointOffset = CGPointMake(selectedL.controlPointOfCurve.x + 20, selectedL.controlPointOfCurve.y );
            
        }
        else {
            startPointOffset = CGPointMake(selectedL.startPoint.x + 12, selectedL.startPoint.y + 12);
            endPointOffset = CGPointMake(selectedL.endPoint.x + 12, selectedL.endPoint.y + 12);
            controlPointOffset = CGPointMake(selectedL.controlPointOfCurve.x + 12, selectedL.controlPointOfCurve.y + 12);
        }
    
    if (selectedL.type == JVDrawingTypeText){
        startPointOffset = CGPointMake(selectedL.startPoint.x + 25, selectedL.startPoint.y + 25);
        endPointOffset = CGPointMake(selectedL.endPoint.x + 25, selectedL.endPoint.y + 25);
    }
    // Calculate duplication by axis for Arrow Tool
    if (selectedL.type == JVDrawingTypeArrow){
        if((selectedL.startPoint.x < selectedL.endPoint.x) && (selectedL.startPoint.y == selectedL.endPoint.y)){
             dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y);
            endPointOffset = CGPointMake(selectedL.endPoint.x + dist, selectedL.endPoint.y );
        }
        if((selectedL.startPoint.x > selectedL.endPoint.x) && (selectedL.startPoint.y == selectedL.endPoint.y)){
             dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y);
            endPointOffset = CGPointMake(selectedL.endPoint.x - dist, selectedL.endPoint.y );
        }
        if((selectedL.startPoint.y < selectedL.endPoint.y) && (selectedL.startPoint.x == selectedL.endPoint.x)){
             dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y);
            endPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y + dist);
        }
        if((selectedL.startPoint.y > selectedL.endPoint.y) && (selectedL.startPoint.x == selectedL.endPoint.x)){
             dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y);
            endPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.endPoint.y - dist);
        }
    }
    
    if (JVDrawingTypeText != selectedL.type && JVDrawingTypeDot != selectedL.type && JVDrawingTypeRazor != selectedL.type && JVDrawingTypeClipper != selectedL.type)
    {
        self.drawingLayer = [JVDrawingLayer createAllLayersAtStart:startPointOffset endPoint:endPointOffset type:selectedL.type  lineWidth:selectedL.lineWidth lineColor:selectedL.lineColor_ controlPoint:selectedL.controlPoint grafittiPoints:selectedL.pointArray];
        
        if(JVDrawingTypeGraffiti == selectedL.type ){
            for(int i = 0; i < selectedL.pointArray.count;i++){
                [self.drawingLayer movePathWithEndPoint:CGPointFromString([selectedL.pointArray objectAtIndex:i])];
            }
                
               
                
//            if(JVDrawingTypeDot == selectedL.type){
//                [self duplicatingLayerType:selectedL imageName:@"dotlayer"];
//                }
//                if(JVDrawingTypeDot == selectedL.type){
//                    [self duplicatingLayerType:selectedL imageName:@"dotlayer"];
//                    }
            }
            
           
            if (JVDrawingTypeCurvedLine == selectedL.type || JVDrawingTypeCurvedDashLine == selectedL.type ){
                NSLog(@"duplicate curve");
                
                BOOL selected;
                if (CGPointEqualToPoint(controlPointOffset,midsPoint(startPointOffset, endPointOffset))){
                    selected = NO;
                } else {
                    selected = YES;
                }
                [self.drawingLayer movePathWithEndPoint:endPointOffset];
                [self.drawingLayer moveCurvedLinePathWithStartPoint:startPointOffset endPoint:endPointOffset midPoint:controlPointOffset isSelected:selected];
                //   [self.drawingLayer redrawCurvedLineStartPoint:layerData.startPoint endPoint:layerData.endPoint midPoint:layerData.controlPoint];
                
            }
            else {
                [self.drawingLayer movePathWithEndPoint:endPointOffset];
            }
        }
    if (JVDrawingTypeText == selectedL.type ) {
        
        CGRect rect = CGRectMake(startPointOffset.x, startPointOffset.y, selectedL.width, selectedL.height);
        self.drawingLayer = [JVDrawingLayer createTextLayerWithStartPoint:startPointOffset
                                                                    frame:rect
                                                                     text:selectedL.text
                                                                     type:selectedL.type
                                                                lineWidth:selectedL.lineWidth
                                                                lineColor:selectedL.lineColor_
                                                                 fontSize:selectedL.fontSize
                                                               isSelected:NO];
    }
    
    switch (selectedL.type) {
        case JVDrawingTypeDot:
            [self duplicatingLayerType:selectedL imageName:@"dotlayer"];
            break;
        case JVDrawingTypeRazor:
            [self duplicatingLayerType:selectedL imageName:@"razor"];
            break;
        case JVDrawingTypeClipper:
            [self duplicatingLayerType:selectedL imageName:@"clippermain"];
            break;
        default:
            break;
    }
    
    
    if(endPointOffset.x != 0 && endPointOffset.y !=0){
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
        [self addLayerToUndoManager:self.drawingLayer];
    }
}

-(void)flipImage{
    [self.selectedLayer flipImage:self.zoomFactor];
}

- (void)reflectLayer:(JVDrawingLayer*)selectedL{
    
    CGPoint startPointOffset;
    CGPoint endPointOffset;
    CGPoint controlPointOffset;
    CGPoint alphaPoint;
    CGFloat  dist;
    
 
    
    if(JVDrawingTypeArrow == selectedL.type){
            
            startPointOffset = selectedL.endPoint;
            endPointOffset = selectedL.startPoint;
    }
    
    else {
        
        if(selectedL.startPoint.x == selectedL.endPoint.x &&  selectedL.startPoint.y < selectedL.endPoint.y){
            
            CGPoint middle = midsPoint(selectedL.startPoint, selectedL.endPoint);
            dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(middle.x + (dist/2), middle.y);
            endPointOffset = CGPointMake(middle.x - (dist/2), middle.y);

        }
        else if (selectedL.startPoint.y == selectedL.endPoint.y ){
            
            CGPoint middle = midsPoint(selectedL.startPoint, selectedL.endPoint);
            dist = hypot((selectedL.startPoint.x - selectedL.endPoint.x), (selectedL.startPoint.y - selectedL.endPoint.y));
            startPointOffset = CGPointMake(middle.x , middle.y+ (dist/2));
            endPointOffset = CGPointMake(middle.x , middle.y- (dist/2));
        }
        else {
            startPointOffset = CGPointMake(selectedL.endPoint.x, selectedL.startPoint.y);
            endPointOffset = CGPointMake(selectedL.startPoint.x, selectedL.endPoint.y);
        }
        
    }
        if (JVDrawingTypeText != selectedL.type ){
            self.drawingLayer = [JVDrawingLayer createAllLayersAtStart:startPointOffset endPoint:endPointOffset type:selectedL.type  lineWidth:selectedL.lineWidth lineColor:selectedL.lineColor_ controlPoint:selectedL.controlPoint grafittiPoints:selectedL.pointArray];
            if(JVDrawingTypeGraffiti == selectedL.type ){
                for(int i = 0; i < selectedL.pointArray.count;i++){
                    [self.drawingLayer movePathWithEndPoint:CGPointFromString([selectedL.pointArray objectAtIndex:i])];
                }
                
            } if (JVDrawingTypeCurvedLine == selectedL.type || JVDrawingTypeCurvedDashLine == selectedL.type ){
                BOOL selected;
                if (CGPointEqualToPoint(controlPointOffset,midsPoint(startPointOffset, endPointOffset))){
                    selected = NO;
                } else {
                    selected = YES;
                }
                [self.drawingLayer movePathWithEndPoint:endPointOffset];
                [self.drawingLayer moveCurvedLinePathWithStartPoint:startPointOffset endPoint:endPointOffset midPoint:controlPointOffset isSelected:selected];
                //   [self.drawingLayer redrawCurvedLineStartPoint:layerData.startPoint endPoint:layerData.endPoint midPoint:layerData.controlPoint];
                
            }
            else {
                [self.drawingLayer movePathWithEndPoint:endPointOffset];
            }
        } else {
            
            CGRect rect = CGRectMake(startPointOffset.x, startPointOffset.y, selectedL.width, selectedL.height);
            self.drawingLayer = [JVDrawingLayer createTextLayerWithStartPoint:startPointOffset
                                                                        frame:rect
                                                                         text:selectedL.text
                                                                         type:selectedL.type
                                                                    lineWidth:selectedL.lineWidth
                                                                    lineColor:selectedL.lineColor_
                                                                     fontSize:selectedL.fontSize
                                                                   isSelected:NO];
        }
        if(endPointOffset.x != 0 && endPointOffset.y !=0){
            [self.layer addSublayer:self.drawingLayer];
            [self.layerArray addObject:self.drawingLayer];
            [self addLayerToUndoManager:self.drawingLayer];
            //            NSLog(@"layerArray   %lu", self.layerArray.count );
        }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSLog(@"Drawingview frame width %f frame height %f",self.frame.size.width, self.frame.size.height);
        self.userInteractionEnabled = YES;
        self.layerArray = [[NSMutableArray alloc] init];
        self.type = JVDrawingTypeLine;
        pan=NO;
        touchesForUpdate = 0;
        [self configure];
        drawingLayer = [CALayer layer];
        [self.layer addSublayer:drawingLayer];
        
        arrayOfLastPoints = [[NSArray alloc]init];
        self.zoomFactor = 1;
        self.layersDict = [[NSMutableDictionary alloc]init];
        self.arrayOfLayersForJSON = [NSMutableArray array];
        arrayOfPoints = [NSMutableArray array];
        self.bufferOfLayers = [NSMutableArray array];
        //NSLog(@"BOOL in setter %s", self.newAppVersion ? "true" : "false");
        
        // [self loadDataFromJsonOnStart]; //LOAADING DATA FROM JSON
        //        [self updateAllPoints]; //UPDATE START AND END POINT TO MAGNIFY
        
        
    }
    return self;
}

//-(void)loadJSONData:(NSMutableString*)fileName{
//    self.backgroundColor = [UIColor whiteColor];
//    self.fileNameInside = fileName;
//    [self loadDataFromJsonOnStart:fileName]; //LOAADING DATA FROM JSON
//    [self updateAllPoints]; //UPDATE START AND END POINT TO MAGNIFY
//}

-(void)loadJSONData:(NSData*)jsonData {
    self.backgroundColor = [UIColor whiteColor];
    //self.fileNameInside = fileName;
    [self loadDataFromJsonOnStart:jsonData]; //LOAADING DATA FROM JSON
    [self updateAllPoints]; //UPDATE START AND END POINT TO MAGNIFY
}
- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGFloat xDist = (endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (void)revokeWhenZooming:(JVDrawingLayer*)layer {
    [self.delegate hideAdditionalColorPicker];
    [self hideMenu];
    [self.layerArray removeObject:layer];
    [layer removeFromSuperlayer];
    layer = nil;
    self.drawingLayer = nil;
    [self updateAllPoints];
    [self storeDataInJson];
    [self fetchData:[self.delegate getDataFromVC]];
    
}



- (void)revoke {
    //if(self.selectedLayer.type == JVDrawingTypeDot || self.selectedLayer.type == JVDrawingTypeClipper || self.selectedLayer.type == JVDrawingTypeRazor){
        [self.delegate hideAdditionalColorPicker];
    //}
    [self hideMenu];
    [self.bufferOfLayers addObject:self.selectedLayer]; //Add layer to buffer array for redo
    [self.layerArray removeObject:self.selectedLayer];
   // [self.selectedLayer removeFromSuperlayer];
    [self.arrayOfCircles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.arrayOfCircles removeAllObjects];
    
    [self addLayerToUndoStack:self.selectedLayer];

    self.selectedLayer.isSelected = NO;
    self.selectedLayer = nil;
    self.drawingLayer = nil;
    [self updateAllPoints];
    [self storeDataInJson];
    [self fetchData:[self.delegate getDataFromVC]];
    NSLog(@"layers count redo %lu", self.bufferOfLayers.count );
    
}
- (void)revokeTextView {
    [self hideMenu];
    [[self.layerArray lastObject] removeFromSuperlayer];
    [self.layerArray removeObject:[self.layerArray lastObject]];
    self.selectedLayer.isSelected = NO;
    self.selectedLayer = nil;
    self.drawingLayer = nil;
    [self updateAllPoints];
    [self storeDataInJson];
    [self fetchData:[self.delegate getDataFromVC]];
    NSLog(@"layers count redo %lu", self.bufferOfLayers.count );
    // NSLog(@"layerArray  after revoke %lu", self.layerArray.count );
    
}
#pragma mark Touches Methods

- (void)setIsFirstTouch:(BOOL)isFirstTouch {
    _isFirstTouch = isFirstTouch;
}

- (CGFloat)getDistanceBetweenStartCurrentPoints:(const CGPoint *)currentPoint {
    CGFloat dx = pointBegin.x - currentPoint->x;
    CGFloat dy= pointBegin.y - currentPoint->y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    return distance;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    unsigned long count = [[event allTouches] count];
    if (count > 1) {
        return; // return amount of fingers touched right now
    }
    NSLog(@"touches began");
    self.isFirstTouch = YES;
    self.isMoveLayer = NO;
    if (self.eraserSelected || self.type == JVDrawingTypeText ){
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    pointBegin = currentPoint;
    startOfLine = currentPoint;
  
    if (self.selectedLayer.type != JVDrawingTypeCurvedLine || self.selectedLayer.type != JVDrawingTypeCurvedDashLine ){
        
    pointForLoupe = [touch locationInView:self]; //point where loupe will be shown

   
        
                self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                   target:self
                                                                 selector:@selector(showLoupe2:)
                                                                 userInfo:nil
                                                                  repeats:NO];

    }
    if (UIMenuController.sharedMenuController.isMenuVisible) {
        [UIMenuController.sharedMenuController setMenuVisible:NO animated:YES];
    }
    cycle = 0;
    touchCanceled = NO;
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touches moved drawing");
    
    if (self.eraserSelected || self.type == JVDrawingTypeText ){
        return;
    }
    
    unsigned long count = [[event allTouches] count];
  
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGFloat distance = [self getDistanceBetweenStartCurrentPoints:&currentPoint];

    
    if(distance == 0){
        
           return;
       }
    
    if (count > 1 ) {
        return;
    }
    
   
    NSLog(@"zoom factor %f", self.zoomFactor);

    [self.drawingLayer setZoomIndex:self.zoomFactor];
    [self.selectedLayer setZoomIndex:self.zoomFactor];


    
    pointForLoupe = [touch locationInView:self]; //point where loupe will be shown
    
    self.type = self.bufferType;

    if (self.isFirstTouch) {
        
        CGFloat touchDistance;
        touchDistance = 12;
        self.drawingLayer.touchDistance = 12;
        self.selectedLayer.touchDistance = 12;

        
        if (touch.type == UITouchTypeStylus) {
            touchDistance = 24;
            self.drawingLayer.touchDistance = 24;
            self.selectedLayer.touchDistance = 24;

            if(distance < 3){
                touchCanceled = YES;
                return;
               }
            
        }
   
        if (self.selectedLayer && [self.selectedLayer isPoint:currentPoint withinDistance:touchDistance / self.zoomFactor ofPath:self.selectedLayer.path]){
            
            self.isMoveLayer = [self.selectedLayer caculateLocationWithPoint:currentPoint];
            
        } else {
            NSLog(@"Creating layer");
           // [self.delegate disableZoomWhenTouchesMoved];
            self.selectedLayer.isSelected = NO;
            [self removeCircles];
            
            
            if(touchCanceled){
                [self detectNearestPoint:&startOfLine]; // Detect nearest point to connnect to

                self.firstTouch = startOfLine;

                self.drawingLayer = [JVDrawingLayer createLayerWithStartPoint:startOfLine
                                                                         type:self.type
                                                                    lineWidth:self.lineWidth
                                                                    lineColor:self.lineColor];
            }
            else {
                [self detectNearestPoint:&previousPoint]; // Detect nearest point to connnect to

                self.firstTouch = previousPoint;
                self.drawingLayer = [JVDrawingLayer createLayerWithStartPoint:previousPoint
                                                                         type:self.type
                                                                    lineWidth:self.lineWidth
                                                                    lineColor:self.lineColor];

            }
            [self.layer addSublayer:self.drawingLayer];
        }
    } else {
        if (self.isMoveLayer) {
            
            if (cycle < 1){
                CGPoint start =  [self.selectedLayer getStartPointOfLayer:self.selectedLayer];
                CGPoint end = [self.selectedLayer getEndPointOfLayer:self.selectedLayer];
                bufferEndPoint = end;
                bufferStartPoint = start;
                [arrayOfPoints removeObject:NSStringFromCGPoint(start)];
                [arrayOfPoints removeObject:NSStringFromCGPoint(end)];
                cycle++;
            }
            if (self.selectedLayer.type == JVDrawingTypeGraffiti) {
                [self.selectedLayer moveGrafiitiPathPreviousPoint:previousPoint currentPoint:currentPoint];
//                self.magnifierView.hidden = YES;
                  
                // Curved line creating and moving
            }
            else if (self.selectedLayer.type == JVDrawingTypeCurvedLine || self.selectedLayer.type == JVDrawingTypeCurvedDashLine) {
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                        
                        NSLog(@"CURVED HEAD TOUCHED");
                        [self detectNearestPoint:&currentPoint]; // Detect nearest point to connnect to
                        [self.selectedLayer movePathWithStartPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer1 atIndex:0];
                      
                        // Show magnifier glass and apply scale to it
                        [_magnifingGlass magnifyAt:[touch locationInView:self]];
                        [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];


                        break;
                    case JVDrawingTouchMid:
                        NSLog(@"CURVED MID TOUCHED");
                        [self hideLoupe]; // hide loupe when middle touched
                        [self.selectedLayer moveControlPointWithPreviousPoint:currentPoint];
                        [self controlCirclePosition:currentPoint  forLayer:self.circleLayer3 atIndex:0];
                        break;
                    case JVDrawingTouchEnd:
                        NSLog(@"CURVED END TOUCHED");
                        [self detectNearestPoint:&currentPoint]; // Detect nearest point to connnect to
                        [self.selectedLayer movePathWithEndPoint:currentPoint];
                        [self circlePosition:self.selectedLayer.endPoint forLayer:self.circleLayer2 atIndex:0];
                      
                        // Show magnifier glass and apply scale to it
                        [_magnifingGlass magnifyAt:[touch locationInView:self]];
                        [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];


                        break;
                        
                    case JVDrawingTouchNone:
                        
                        break;
                    default:
                        break;
                }
            }
            else if (self.selectedLayer.type == JVDrawingTypeDot || self.selectedLayer.type == JVDrawingTypeClipper || self.selectedLayer.type == JVDrawingTypeRazor )
            { // DOT LAYER MOVING
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                    
                        break;
                    case JVDrawingTouchMid:
                    NSLog(@"MOVING MIDDLE POINT");
                        
                        [self hideLoupe]; // hide loupe when middle touched
                        [self.selectedLayer moveDotPathWithPreviousPoint:previousPoint currentPoint:currentPoint];
                        [self framePosition:self.selectedLayer.dotCenter forLayer:self.frameForDot selectedLayer:self.selectedLayer];
                        [self circleFramePosition:self.selectedLayer.endPoint forLayer:self.circleLayer1 atIndex:0];

                        
                        break;
                    case JVDrawingTouchEnd:
                        NSLog(@"MOVING END POINT");
                        
                        [self hideLoupe]; // hide loupe when middle touched
                        self.selectedLayer.zoomFactor = self.zoomFactor;
                        [self.selectedLayer zoomDotPathWithEndPoint:currentPoint];
                        [self framePosition:self.selectedLayer.dotCenter forLayer:self.frameForDot selectedLayer:self.selectedLayer];
                        [self circleFramePosition:self.selectedLayer.endPoint forLayer:self.circleLayer1 atIndex:0];
                     
                        break;
                        
                    default:
                        break;
                }
            }
            
            else {
                switch (self.isMoveLayer) {
                    case JVDrawingTouchHead:
                        if(_magnetActivated){
                            [self autoPosition:&currentPoint basePoint:bufferEndPoint];
                        }
                        [self detectNearestPoint:&currentPoint]; // Detect nearest point to connnect to
                        [self.selectedLayer movePathWithStartPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer1 atIndex:0];
                       
                        // Show magnifier glass and apply scale to it
                        [_magnifingGlass magnifyAt:[touch locationInView:self]];
                        [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];


//                        }
                        break;
                    case JVDrawingTouchMid:
                        NSLog(@"MOVING MIDDLE POINT");
                        
                        [self hideLoupe]; // hide loupe when middle touched
                        [self.selectedLayer movePathWithPreviousPoint:previousPoint currentPoint:currentPoint];
                        [self circlePosition:self.selectedLayer.startPmoving point2:self.selectedLayer.endPmoving forBothLayers:self.circleLayer1 circle2:self.circleLayer2];
                        break;
                    case JVDrawingTouchEnd:
                        NSLog(@"MOVING END POINT");
                        if(_magnetActivated){
                            [self autoPosition:&currentPoint basePoint:bufferStartPoint];
                        }
                        [self detectNearestPoint:&currentPoint]; // Detect nearest point to connnect to
                        [self.selectedLayer movePathWithEndPoint:currentPoint];
                        [self circlePosition:currentPoint forLayer:self.circleLayer2 atIndex:0];
                     
                        // Show magnifier glass and apply scale to it
                        [_magnifingGlass magnifyAt:[touch locationInView:self]];
                        [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];


                        break;
                    default:
                        break;
                }
            }
        } else {
            NSLog(@"end of creation of line");
            if(self.drawingLayer.type != JVDrawingTypeGraffiti){
                if(_magnetActivated){
                    [self autoPosition:&currentPoint basePoint:self.firstTouch];
                }
                [self detectNearestPoint:&currentPoint]; // Detect nearest point to connnect to
            }
            if(self.drawingLayer.type == JVDrawingTypeCurvedLine || self.drawingLayer .type == JVDrawingTypeCurvedDashLine){
                self.drawingLayer.midPmoving = midsPoint(currentPoint, startOfLine);
            }
            [self.drawingLayer movePathWithEndPoint:currentPoint];
            self.lastTouch = currentPoint;
       
            // Show magnifier glass and apply scale to it
            [_magnifingGlass magnifyAt:[touch locationInView:self]];
            [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];
           
        }
    }
    
    self.isFirstTouch = NO;
    
    NSLog(@"Layer count = %lu", (unsigned long)self.layer.sublayers.count);
    
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches ended");
    NSLog(@"Layer count = %lu", (unsigned long)self.layer.sublayers.count);
    unsigned long count = [[event allTouches] count];
   
    
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    _magnifingGlass.magnifiedView = nil;
    
    if (count > 1) {
        [self removeExcessLayer];
        return;
    }
    
    cycle = 0;
    [self hideLoupe];
    if (![self.layerArray containsObject:self.drawingLayer] && !self.isFirstTouch && self.drawingLayer != nil) {
        //add endPoint to Array when line first drawn
        [self.layerArray addObject:self.drawingLayer];
      //  [self.undoRedoArray addObject:self.drawingLayer];
        
     
        
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getStartPointOfLayer:self.drawingLayer])];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getEndPointOfLayer:self.drawingLayer])];
        [self.delegate updateButtonStatus];
        
        if (JVDrawingTypeCurvedLine == self.drawingLayer.type || JVDrawingTypeCurvedDashLine == self.drawingLayer.type ){
            [self selectLayer:[self.layerArray lastObject]];
        }
        [self.drawingLayer addToTrack];
        [self addToTrackInDrawingView:self.drawingLayer];
        
//        [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
//        if (![self.undoManager isUndoing]) {
//            [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
//        }
        
    } else {
        if (self.isMoveLayer) {
            
            
//            JVDrawingLayer *copiedLayer = [NSKeyedUnarchiver unarchivedObjectOfClass:[JVDrawingLayer class]
//                                                                 fromData:[NSKeyedArchiver archivedDataWithRootObject:self.selectedLayer requiringSecureCoding:NO error:nil] error:nil];
//            [self.tempLayersForUndo addObject:copiedLayer]; // store new position in temp Layer
//
//
//            [[self.undoManager prepareWithInvocationTarget:self]moveDrawing:copiedLayer];
//            if (![self.undoManager isUndoing]) {
//                [self.undoManager setActionName:NSLocalizedString(@"actions.move", @"Move Shape")];
//                
//            }
//        
            [self updateAllPoints];
            [self storeDataInJson];
            [self.selectedLayer addToTrack];
            [self addToTrackInDrawingView:self.selectedLayer];

          //  NSLog(@"temp layer count = %lu", self.tempLayersForUndo.count);
        }
        if (self.isFirstTouch) {
            if(self.eraserSelected == NO){
                BOOL layerHasBeenPicked = NO;
                UITouch *touch = [touches anyObject];
                CGPoint currentPoint = [touch locationInView:self];
                for (JVDrawingLayer *layer in self.layerArray) {
                    if ([layer isPoint:currentPoint withinDistance:10 / self.zoomFactor ofPath:layer.path]){
                        [layer caculateLocationWithPoint:currentPoint];                    // tapped on a layer
                        layerHasBeenPicked = YES;
                        if (layer == self.selectedLayer && !menuVisible) {
                            // the layer is already selected; show the menu
                            [self showMenu];
                        } else {
                            // clear the selection
                            self.selectedLayer.isSelected = NO;
                            [self removeCircles];
                            [self hideMenu];
                            // draw new selection
                            [self selectLayer:layer];
                            NSLog(@"Layer type %ld", (long)layer.type);
                            [layer setZoomIndex:self.zoomFactor];
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
                    [self.delegate hideAdditionalColorPicker];
                }
                //       self.drawingLayerSelectedBlock(self.selectedLayer);
                
            }else if(self.eraserSelected == YES) {
                NSLog(@"trying to delete line");
                
                UITouch *touch = [touches anyObject];
                CGPoint currentPoint = [touch locationInView:self];
                for (JVDrawingLayer *layer in self.layerArray) {
                    if ([layer isPoint:currentPoint withinDistance:10 / self.zoomFactor ofPath:layer.path]){
                        [layer caculateLocationWithPoint:currentPoint];
                        self.selectedLayer = layer;
                        self.selectedLayer.isSelected = YES;
                        [self revoke];
                        break;
                    }
                }
                
            }
        }
    }
  //  [self.delegate enableZoomWhenTouchesMoved];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _magnifingGlass.magnifiedView = nil;

    [self touchesEnded:touches withEvent:event];

}

#pragma mark - Remove Excess Layer


-(void)removeExcessLayer{
    NSMutableArray * tempArray = [NSMutableArray array];
    for(JVDrawingLayer * layerTemp in self.layer.sublayers){
     //   NSLog(@"layertemp %@", layerTemp.description);
        if([layerTemp isKindOfClass:[JVDrawingLayer class]]){
           if(![self.layerArray containsObject:layerTemp]){
              //  [layerTemp removeFromSuperlayer];
               [tempArray addObject:layerTemp];
         }else {
             NSLog(@"Layer exist in layer");
       }

        }
    }
    if (tempArray.count > 0 ){
        [[tempArray objectAtIndex:0] removeFromSuperlayer];
        [self layoutIfNeeded];
    }
}

- (void)setEraserSelected:(BOOL)eraserSelected
{
    _eraserSelected = eraserSelected;
    NSLog(@"BOOL in eraser %s", _eraserSelected ? "true" : "false");
}

#pragma mark Points Detection
- (void)detectNearestPoint:(CGPoint *)previousPoint {
    CGPoint discoveryPoint;
    CGFloat tolerance = 5;
    // Had to Create these two arrays because there's no such thing as [NSDictionary objectAtIndex:]
    NSArray *pointsArray;
    CGFloat keyOfPointWithMinDistance = -1;
    CGPoint nearestPointToTouchedPoint = CGPointZero;
    int index = 0;
    for (NSString * cgpointVal in arrayOfPoints){
        discoveryPoint = CGPointFromString(cgpointVal);
        if (fabs(previousPoint->x - discoveryPoint.x)<tolerance && fabs(previousPoint->y - discoveryPoint.y)<tolerance) {
            //Calculating the distance between points with touchedPoint in their range(Square) and adding them to an array.
            CGFloat distance = hypotf(previousPoint->x - discoveryPoint.x, previousPoint->y - discoveryPoint.y);
            
            // if (keyOfPointWithMinDistance == -1 || keyOfPointWithMinDistance < distance) {
            if ( keyOfPointWithMinDistance < distance) {
                keyOfPointWithMinDistance = distance;
                nearestPointToTouchedPoint = discoveryPoint;
                *previousPoint = nearestPointToTouchedPoint;
            }
            index++;
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
- (void)updateAllPoints {
    [arrayOfPoints removeAllObjects];
    for (JVDrawingLayer *layer in self.layerArray) {
        
        CGPoint start = [layer getStartPointOfLayer:layer];
        CGPoint end = [layer getEndPointOfLayer:layer];
        
        if(layer.type != JVDrawingTypeText && layer.type != JVDrawingTypeDot && layer.type != JVDrawingTypeClipper && layer.type != JVDrawingTypeRazor){
            [arrayOfPoints addObject:NSStringFromCGPoint(start)];
            [arrayOfPoints addObject:NSStringFromCGPoint(end)];
        }
        NSLog(@"Array of points %lu", (unsigned long)arrayOfPoints.count );
    }
}
- (void)setSelectedLayer:(JVDrawingLayer *)selectedLayer {
    _selectedLayer = selectedLayer;
}

- (void)selectLayer:(JVDrawingLayer *)layer {
    
    [self.delegate hideAdditionalColorPicker];

    [layer caculateLocationWithPoint:layer.frame.origin];                    // tapped on a layer
    self.selectedLayer = layer;
    self.selectedLayer.isSelected = YES;
    [self.layer insertSublayer:layer above:[self.layerArray lastObject]];
   // if ([self.undoManager canUndo]) {
    
       // [self.undoManager removeAllActionsWithTarget:self.selectedLayer];
        
//        [[self.undoManager prepareWithInvocationTarget:self]remvoeFromArray:layer];
//        if (![self.undoManager isUndoing]) {
//            [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
//        }
//    }
    [self.layerArray removeObject:self.selectedLayer];
    [self.layerArray addObject:self.selectedLayer];

    self.type = self.selectedLayer.type;
   // [self.delegate selectCurentToolWhenLineSelected:self.selectedLayer.type];
    [self placeCirclesAtLine:layer];
   

}
#pragma mark Placing Circles On Line

-(void)placeCirclesAtLine:(JVDrawingLayer*)layer{
    if (JVDrawingTypeCurvedLine == self.type || JVDrawingTypeCurvedDashLine == self.type){
        self.circleLayer1 = [CircleLayer addCircleToPoint:layer.startPoint scaleFactor:self.zoomFactor];
        self.circleLayer2 = [CircleLayer addCircleToPoint:layer.endPoint scaleFactor:self.zoomFactor];
        self.circleLayer3 = [CircleLayer addCircleToPoint:layer.midP scaleFactor:self.zoomFactor];
        [layer addSublayer:self.circleLayer1];
        [layer addSublayer:self.circleLayer2];
        [layer addSublayer:self.circleLayer3];
        [self.arrayOfCircles addObject:self.circleLayer1];
        [self.arrayOfCircles addObject:self.circleLayer2];
        [self.arrayOfCircles addObject:self.circleLayer3];
    }
    else if (JVDrawingTypeText == self.type){
       
        
        [self.userResizableView setTextViewSelected:YES];
        self.temporaryLayer = self.selectedLayer;
        textViewSelected = YES;
        CGRect rect = [self convertRect:layer.frame toView:self];
        rect = CGRectInset(rect, -9.0f, -9.0f);
        [self addFrameForTextView:rect
                      centerPoint:layer.position
                             text:layer.text
                            color:layer.lineColor_
                             font:layer.fontSize];
        [self.delegate selectTextTool:self.textTypesSender textColor:layer.lineColor_ fontSize:layer.fontSize isSelected:textViewSelected];
        [self.undoManager removeAllActionsWithTarget:self.selectedLayer];
        [self revoke];
        
    } else if (JVDrawingTypeArrow == self.type || JVDrawingTypeLine == self.type || JVDrawingTypeDashedLine == self.type) {
        self.circleLayer1 = [CircleLayer addCircleToPoint:layer.startPoint scaleFactor:self.zoomFactor];
        self.circleLayer2 = [CircleLayer addCircleToPoint:layer.endPoint scaleFactor:self.zoomFactor];
        [layer addSublayer:self.circleLayer1];
        [layer addSublayer:self.circleLayer2];
        [self.arrayOfCircles addObject:self.circleLayer1];
        [self.arrayOfCircles addObject:self.circleLayer2];
    }
    else if (JVDrawingTypeDot == self.type || JVDrawingTypeClipper == self.type || JVDrawingTypeRazor == self.type ){
        self.frameForDot = [FrameLayer addFrameToPoint:layer.startPoint endPoint:layer.endPoint scaleFactor:self.zoomFactor];
        self.circleLayer1 = [CircleLayer addZoomToFrame:layer.endPoint scaleFactor:self.zoomFactor];
        [layer addSublayer:self.frameForDot];
        [layer addSublayer:self.circleLayer1];
        [self.arrayOfCircles addObject:self.frameForDot];
        [self.arrayOfCircles addObject:self.circleLayer1];
        
        [self.delegate additionalToolsColorPopover:layer.lineColor_];
    }
}

-(void)controlCirclePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-5 / self.zoomFactor, point.y-5 / self.zoomFactor, 10 / self.zoomFactor, 10 / self.zoomFactor)];
    circle.path = circlePath.CGPath;
}

-(void)circlePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-5 / self.zoomFactor, point.y-5 / self.zoomFactor, 10 / self.zoomFactor, 10 / self.zoomFactor)];

    circle.path = circlePath.CGPath;
}

-(void)circleFramePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-7 / self.zoomFactor, point.y-7 / self.zoomFactor , 14 / self.zoomFactor, 14 / self.zoomFactor)];

    
    CGPoint upperPoint = CGPointMake(point.x - 4 / self.zoomFactor, point.y - 4 / self.zoomFactor);
    CGPoint lowerPoint = CGPointMake(point.x + 4 / self.zoomFactor, point.y + 4 / self.zoomFactor);

    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:CGPointMake(upperPoint.x, upperPoint.y + 4 / self.zoomFactor)];
    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:CGPointMake(upperPoint.x + 4 / self.zoomFactor, upperPoint.y)];
    [circlePath moveToPoint:upperPoint];
    [circlePath addLineToPoint:lowerPoint];
    [circlePath addLineToPoint:CGPointMake(lowerPoint.x - 4 / self.zoomFactor, lowerPoint.y)];
    [circlePath moveToPoint:lowerPoint];
    [circlePath addLineToPoint:CGPointMake(lowerPoint.x, lowerPoint.y - 4 / self.zoomFactor)];
    [circlePath stroke];
    circlePath.lineWidth = 1 ;
    
    
    
    circle.path = circlePath.CGPath;
}

-(void)frameTextPosition:(CGPoint)point forLayer:(FrameLayer*)frame selectedLayer:(JVDrawingLayer*)layer{
 
    UIBezierPath *framePath = [UIBezierPath bezierPath];
    framePath = [UIBezierPath bezierPathWithRect:CGRectMake(layer.bounds.origin.x , layer.bounds.origin.y, layer.bounds.size.width, layer.bounds.size.height)];
    frame.path = framePath.CGPath;
}
-(void)textCirclePosition:(CGPoint)point forLayer:(CircleLayer*)circle atIndex:(int)idx{
    
    

    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-5 / self.zoomFactor, point.y-5 / self.zoomFactor, 10 / self.zoomFactor, 10 / self.zoomFactor)];
    circle.path = circlePath.CGPath;
}



-(void)framePosition:(CGPoint)point forLayer:(FrameLayer*)frame selectedLayer:(JVDrawingLayer*)layer{
    
    CGFloat hypot = [self distanceBetweenStartPoint:layer.startPoint endPoint:layer.endPoint];
    hypot = hypot * 2;
    hypot = hypot * hypot;
    hypot = hypot / 2;
    hypot = sqrt(hypot);
    
    UIBezierPath *framePath = [UIBezierPath bezierPath];
    framePath = [UIBezierPath bezierPathWithRect:CGRectMake(point.x - (hypot/2), point.y - (hypot/2), hypot, hypot)];
    frame.path = framePath.CGPath;
}


-(void)circlePosition:(CGPoint)point point2:(CGPoint)point2 forBothLayers:(CircleLayer*)circle circle2:(CircleLayer*)circle2{
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-5 / self.zoomFactor, point.y-5 / self.zoomFactor,10 / self.zoomFactor, 10 / self.zoomFactor)];
    UIBezierPath *circlePath2 = [UIBezierPath bezierPath];
    circlePath2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point2.x-5 / self.zoomFactor, point2.y-5 / self.zoomFactor, 10/self.zoomFactor, 10/self.zoomFactor)];
    circle.path = circlePath.CGPath;
    circle2.path = circlePath2.CGPath;
}

-(void)removeCircles{
  
    [self.arrayOfCircles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.arrayOfCircles removeAllObjects];
    self.selectedLayer = nil;
    self.selectedLayer.isSelected = NO;
    
    [self storeDataInJson];
    [self fetchData:[self.delegate getDataFromVC] ];
}

#pragma mark ZOOM IN / OUT METHODS
-(void)updateZoomFactor:(CGFloat)zoomFactor{
    
    [self.touchTimer invalidate];
   // [self.magnifierView setHidden:YES];
    
    self.zoomFactor = zoomFactor;
    self.drawingLayer.zoomFactor = zoomFactor;
    if(self.selectedLayer != nil){
        self.selectedLayer.zoomFactor = zoomFactor;
    }
    [self removeCirclesOnZoom];
    zoomIdx = zoomFactor * [UIScreen mainScreen].scale;
    // Walk the layer and view hierarchies separately. We need to reach all tiled layers.
    [self applyScale:(zoomFactor * [UIScreen mainScreen].scale) toView:self.userResizableView];
    [self applyScale:(zoomFactor * [UIScreen mainScreen].scale) toLayer:self.textViewNew.layer];
    
    
    UIImage * img;
    
    for (JVDrawingLayer * layer in self.layerArray){
        
        if (layer.type == JVDrawingTypeDot || layer.type == JVDrawingTypeClipper || layer.type == JVDrawingTypeRazor){
            DotLayer * dotLayer = [layer.sublayers objectAtIndex:0];
           
            img = [UIImage imageNamed:dotLayer.imageName];
            UIImage * newImg = [dotLayer imageWithImage:img scaledToSize:dotLayer.bounds.size scale:self.zoomFactor];
            
            if ([layer.imageDirection isEqualToString:@"mirrored"]){
            newImg = [UIImage imageWithCGImage:newImg.CGImage
                                      scale:self.zoomFactor                                orientation:UIImageOrientationUpMirrored];
            }
            dotLayer.mask.contents = (__bridge id _Nullable) ([dotLayer imageWithImage:newImg scaledToSize:dotLayer.bounds.size scale:zoomIdx]).CGImage;
            dotLayer.mask.contentsGravity = kCAGravityResize;
            
        }
    }

}



- (void)applyScale:(CGFloat)scale toLayer:(CALayer *)layer {
    layer.contentsScale = scale;
    for (CALayer *sublayer in layer.sublayers) {
        [self applyScale:scale toLayer:sublayer];
    }
}
- (void)applyScale:(CGFloat)scale toView:(UIView *)view {
    view.contentScaleFactor = scale;
    for (UIView *subview in view.subviews) {
        [self applyScale:scale toView:subview];
    }
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
    
    if (self.selectedLayer.type == JVDrawingTypeCurvedLine || self.selectedLayer.type == JVDrawingTypeCurvedDashLine){
        
        //rectOfMenu = CGRectMake(self.selectedLayer.midPmoving.x,self.selectedLayer.midPmoving.y,0,0) ;
        
        rectOfMenu = CGRectMake(self.selectedLayer.midP.x,self.selectedLayer.midP.y,0,0) ;
        
    } else if(self.selectedLayer.type == JVDrawingTypeGraffiti ) {
        rectOfMenu = CGRectMake(self.selectedLayer.startPoint.x, self.selectedLayer.startPoint.y, 0, 0);
    }
    else {
        rectOfMenu = CGRectMake(middlePoint.x, middlePoint.y, 0, 0);
        
    }
    [self becomeFirstResponder];
    menu = [UIMenuController sharedMenuController];
    
    if(self.selectedLayer.type == JVDrawingTypeCurvedLine || self.selectedLayer.type == JVDrawingTypeCurvedDashLine)
    {
        menu.menuItems = @[
            [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)],  [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)]];
        [menu setArrowDirection:UIMenuControllerArrowDown];
        
        [menu showMenuFromView:self rect:rectOfMenu];
    }
//
//    if(self.selectedLayer.type == JVDrawingTypeText){
//             rectOfMenu = CGRectMake(self.selectedLayer.startPoint.x +( self.selectedLayer.width / 2), self.selectedLayer.startPoint.y, 0, 0);
//                menu.menuItems = @[
//                    [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)],  [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)]];
//                [menu setArrowDirection:UIMenuControllerArrowDown];
//
//                [menu showMenuFromView:self rect:rectOfMenu];
        
//        menuForTextView = [UIMenuController sharedMenuController];
//        menuForTextView.menuItems = @[
//            [[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(duplicateLine)], [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(duplicateLine)],[[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)]];
//    [menuForTextView setArrowDirection:UIMenuControllerArrowDown];
//        [menuForTextView showMenuFromView:self rect:rectOfMenu];
//
//
//    }
    
    if (self.selectedLayer.type == JVDrawingTypeDashedLine || self.selectedLayer.type == JVDrawingTypeLine || self.selectedLayer.type == JVDrawingTypeArrow){
        menu.menuItems = @[
            [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)],  [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)],[[UIMenuItem alloc] initWithTitle:@"Flip" action:@selector(reflectLine)]];
        [menu setArrowDirection:UIMenuControllerArrowDown];
    [menu showMenuFromView:self rect:rectOfMenu];
    }
    
    if (self.selectedLayer.type == JVDrawingTypeDot ){
        rectOfMenu = CGRectMake(self.selectedLayer.dotCenter.x, self.selectedLayer.dotCenter.y, 0, 0);
        menu.menuItems = @[
            [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)],  [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)]];
        [menu setArrowDirection:UIMenuControllerArrowDown];
        [menu showMenuFromView:self rect:rectOfMenu];
    }
   if(self.selectedLayer.type == JVDrawingTypeClipper || self.selectedLayer.type == JVDrawingTypeRazor ) {
        rectOfMenu = CGRectMake(self.selectedLayer.dotCenter.x, self.selectedLayer.dotCenter.y, 0, 0);
        menu.menuItems = @[
            [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)],  [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)],  [[UIMenuItem alloc] initWithTitle:@"Flip" action:@selector(flipImage)]];
        [menu setArrowDirection:UIMenuControllerArrowDown];
        [menu showMenuFromView:self rect:rectOfMenu];
    }
    if(self.selectedLayer.type == JVDrawingTypeGraffiti ) {
        rectOfMenu = CGRectMake(self.selectedLayer.startPoint.x, self.selectedLayer.startPoint.y, 0, 0);
        menu.menuItems = @[
                  [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)]];
              [menu setArrowDirection:UIMenuControllerArrowDown];
              [menu showMenuFromView:self rect:rectOfMenu];
    }
//    else {
//        menu.menuItems = @[
//            [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(revoke)]];
//        [menu setArrowDirection:UIMenuControllerArrowDown];
//        [menu showMenuFromView:self rect:rectOfMenu];
//    }
    menuVisible = YES;

}

-(void)hideMenu {
    
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    menuVisible = NO;
}
#pragma mark Duplicate

-(void)duplicateLine{
    if(textViewSelected){
        [self removeTextViewFrame]; //create text layer when closing window
        [self createCopyOfLayer:[self.layerArray lastObject]];
        

    }else{
        [self createCopyOfLayer:self.selectedLayer];
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getStartPointOfLayer:self.drawingLayer])];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getEndPointOfLayer:self.drawingLayer])];
        [self.delegate updateButtonStatus];
        [self removeCircles];

        if (JVDrawingTypeCurvedLine == self.drawingLayer.type || JVDrawingTypeCurvedDashLine == self.drawingLayer.type ){
            [self selectLayer:[self.layerArray lastObject]];
        }
        [self.drawingLayer addToTrack];
    }
    
}

-(void)reflectLine{
   
    if (self.selectedLayer.type == JVDrawingTypeDashedLine || self.selectedLayer.type == JVDrawingTypeLine || self.selectedLayer.type == JVDrawingTypeArrow ){
        self.temporaryLayerForFliping = self.selectedLayer;
        [self revoke];
        [self reflectLayer:self.temporaryLayerForFliping    ];
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getStartPointOfLayer:self.drawingLayer])];
        [arrayOfPoints addObject:NSStringFromCGPoint([self.drawingLayer getEndPointOfLayer:self.drawingLayer])];
        [self.delegate updateButtonStatus];
        [self removeCircles];
        [self.drawingLayer addToTrack];
    }

}

#pragma mark Add Dot


-(void)addDotToView:(CGPoint)centerPoint{
    NSLog(@"drawing layer = %@", self.drawingLayer);
    if(self.selectedLayer != nil){
        [self removeCircles];
    }
    if ([self textViewSelected]){
        [self hideAndCreateTextLayer];
        textViewSelected = NO;
        [self.delegate selectPreviousTool:self.previousType];
    }
    
    self.type = JVDrawingTypeDot;
    self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:centerPoint endPoint:centerPoint  height:40 type:self.type lineWidth:3 lineColor:[self colorFromHex:DeepPink]  scale:self.zoomFactor imageName:@"dotlayer" orientation:@"default"];
    
    [self.layer addSublayer:self.drawingLayer];
    [self.layerArray addObject:self.drawingLayer];
    
    [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
    if (![self.undoManager isUndoing]) {
        [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
        [self.delegate updateButtonStatus];

    }
    
    [self storeDataInJson];
    [self.drawingLayer addToTrack];
    [self selectLayer:self.drawingLayer];
    [self.selectedLayer setZoomIndex:self.zoomFactor];
}



-(void)addClipperToView:(CGPoint)centerPoint{
   
    if(self.selectedLayer != nil){
        [self removeCircles];
    }
    if ([self textViewSelected]){
        [self hideAndCreateTextLayer];
        textViewSelected = NO;
        [self.delegate selectPreviousTool:self.previousType];
    }
   
    self.type = JVDrawingTypeClipper;
    self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:centerPoint endPoint:centerPoint  height:70 type:self.type lineWidth:3 lineColor:[self colorFromHex:DeepPink] scale:self.zoomFactor imageName:@"clippermain" orientation:@"default"];
    
    [self.layer addSublayer:self.drawingLayer];
    [self.layerArray addObject:self.drawingLayer];
    
    [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
    if (![self.undoManager isUndoing]) {
        [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
        [self.delegate updateButtonStatus];

    }
    [self.drawingLayer addToTrack];
    [self selectLayer:self.drawingLayer];
    [self.selectedLayer setZoomIndex:self.zoomFactor];

}

-(void)addRazorToView:(CGPoint)centerPoint{
    if(self.selectedLayer != nil){
        [self removeCircles];
    }
    if ([self textViewSelected]){
        [self hideAndCreateTextLayer];
        textViewSelected = NO;
        [self.delegate selectPreviousTool:self.previousType];
    }
    self.type = JVDrawingTypeRazor;
    self.drawingLayer = [JVDrawingLayer createDotWithStartPoint:centerPoint endPoint:centerPoint  height:70 type:self.type lineWidth:3 lineColor:[self colorFromHex:DeepPink] scale:self.zoomFactor imageName:@"razor" orientation:@"default"];
    
    [self.layer addSublayer:self.drawingLayer];
    [self.layerArray addObject:self.drawingLayer];
    
    [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
    if (![self.undoManager isUndoing]) {
        [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
        [self.delegate updateButtonStatus];

    }
    
    [self.drawingLayer addToTrack];
    [self selectLayer:self.drawingLayer];
    [self.selectedLayer setZoomIndex:self.zoomFactor];

}

- (UIColor *)colorFromHex:(NSString *)hex {
    
    
    unsigned rgbValue = 0;
       NSScanner *scanner = [NSScanner scannerWithString:hex];
       [scanner setScanLocation:1]; // bypass '#' character
       [scanner scanHexInt:&rgbValue];
       return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



-(void)setNewColorForTools:(UIColor*)color{
    [self.selectedLayer setNewColor:color];
    [self storeDataInJson];
    
}
-(BOOL)textViewSelected{
    if ([self.userResizableView.subviews containsObject:self.textViewNew]){
        return YES;
    }
    return NO;
}
#pragma mark Add Text View

                /* THIS IS BLOCK OF METHODS TO ADD TEXT TEXT TEXT TEXT  LAYER */


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
    NSLog(@"Adjuxting textview frame");
    CGPoint origin = [self.textViewNew convertPoint:CGPointMake(self.textViewNew.bounds.origin.x, self.textViewNew.bounds.origin.y) toView:self.superview];
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

    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil] ) {
        //[self.textViewNew becomeFirstResponder];
        [currentlyEditingView showEditingHandles];
        //        [self enableGestures];
        return NO;
    }
    // [self.textViewNew resignFirstResponder];
    // [currentlyEditingView hideEditingHandles];
    return YES;
    
}

-(void)addFrameForTextView:(CGRect)rect centerPoint:(CGPoint)center text:(NSString*)text color:(UIColor*)color font:(CGFloat)fontSize{
    //self.textViewFontSize = fontSize;
    self.selectedLayer.isSelected = NO;
    if ([self.userResizableView.subviews containsObject:self.textViewNew]){
        [self hideAndSaveTextViewWhenNewAdded];
    }
    self.userResizableView = [[SPUserResizableView alloc] initWithFrame:rect];
    [self.userResizableView setTextViewSelected:YES];

    self.textViewNew  = [[TextViewCustom alloc] initWithFrame:rect font:fontSize text:text color:color];
    //[self.textViewNew passText:text color:color];
    self.userResizableView.center = center;
    self.userResizableView.contentView = self.textViewNew;
    self.userResizableView.delegate = self;
    [self.userResizableView showEditingHandles];
    currentlyEditingView = self.userResizableView;
    lastEditedView = self.userResizableView;
    [self addSubview:self.userResizableView];
    [self applyScale:zoomIdx toView:self.userResizableView];
    [self applyScale:zoomIdx toView:self.textViewNew];
    
    [self.arrayOfTextViews addObject:self.userResizableView];



    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuOnTextView:)];
    [self.userResizableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.numberOfTapsRequired = 1;
//    gestureRecognizer.cancelsTouchesInView = NO;
    //[gestureRecognizer setDelegate:self];
    
    gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuForTextView)];
    [self addGestureRecognizer:gestureRecognizer2];
    gestureRecognizer2.cancelsTouchesInView = NO;
    gestureRecognizer2.numberOfTapsRequired = 1;
    // [gestureRecognizer2 setDelegate:self];
    NSLog(@"USER FRAME width %f and Height %f", self.userResizableView.frame.size.width, self.userResizableView.frame.size.height);
    NSLog(@"TEXT VIEW width %f and Height %f", self.textViewNew.frame.size.width, self.textViewNew.frame.size.height);
    
}

-(void)disableGestures{
    gestureRecognizer.enabled = NO;
    gestureRecognizer2.enabled = NO;
}
-(void)enableGestures{
    
    gestureRecognizer.enabled = YES;
    gestureRecognizer2.enabled = YES;
}
- (void)showMenuOnTextView:(UITapGestureRecognizer*)sender {
    NSLog(@"Show menu from textview");
    CGRect rectOfMenu = CGRectMake(self.userResizableView.frame.origin.x +
                                   (self.userResizableView.frame.size.width / 2),
                                   self.userResizableView.frame.origin.y ,
                                   0, 0);
    if (self.textViewNew.isFirstResponder != YES){
        
            [self becomeFirstResponder];
            menuForTextView = [UIMenuController sharedMenuController];
            menuForTextView.menuItems = @[
                [[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(editTextView)], [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(removeTextView)],[[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicateLine)]];
        [menuForTextView setArrowDirection:UIMenuControllerArrowDown];
            [menuForTextView showMenuFromView:self rect:rectOfMenu];
        
    }
    
}
-(void)removeTextView{
    
    if(textViewSelected){
        //[self revoke];
        [self hideAndCreateTextLayer];
        [self.bufferOfLayers addObject:[self.layerArray lastObject]];
        [self revokeTextView];
        [self.textViewNew resignFirstResponder];
        self.textViewNew.userInteractionEnabled = NO;
        [currentlyEditingView hideEditingHandles];
        [self.textViewNew removeFromSuperview];
        [self.userResizableView removeFromSuperview];
        [self.delegate selectPreviousTool:self.previousType];
        [self.delegate removeTextSettings];
        textViewSelected = NO;
        
    } else {
        [self.textViewNew resignFirstResponder];
        self.textViewNew.userInteractionEnabled = NO;
        [currentlyEditingView hideEditingHandles];
        [self.textViewNew removeFromSuperview];
        [self.userResizableView removeFromSuperview];
        [self.delegate selectPreviousTool:self.previousType];
        [self.delegate removeTextSettings];
    }
}
- (void)hideAndCreateTextLayer {
    [self.textViewNew resignFirstResponder];
    self.textViewNew.userInteractionEnabled = NO;
    [currentlyEditingView hideEditingHandles];
    [self.userResizableView removeFromSuperview];
    
    CGPoint origin = [self.textViewNew convertPoint:CGPointMake(self.textViewNew.frame.origin.x, self.textViewNew.frame.origin.y)  toView:self.window];
    
    CGRect rect = CGRectMake(origin.x,
                             origin.y,
                             self.textViewNew.bounds.size.width,
                             self.textViewNew.bounds.size.height);
    if([[self.textViewNew.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        
        self.drawingLayer = [JVDrawingLayer createTextLayerWithStartPoint:origin
                                                                    frame:rect
                                                                     text:self.textViewNew.text
                                                                     type:self.type
                                                                lineWidth:self.lineWidth
                                                                lineColor:self.textViewNew.textColor
                                                                 fontSize:self.textViewFontSize
                                                               isSelected:NO ];
        NSLog(@"Creting new layer from textView");
        
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
        
        [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
        if (![self.undoManager isUndoing]) {
            [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
        }
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
        [self.drawingLayer addToTrack];
        [self.textViewNew removeFromSuperview];
        [self.delegate removeTextSettings];
        [self.delegate updateButtonStatus];
        
    }
}

-(void)hideMenuForTextView{

    if (self.textViewNew.isFirstResponder == YES || menuForTextView.isMenuVisible){
        [menuForTextView setMenuVisible:NO animated:YES];
        
        [self.textViewNew resignFirstResponder];
        [self hideTextViewFrame];
        [currentlyEditingView showEditingHandles];    }
    
    if ([self.userResizableView.subviews containsObject:self.textViewNew]){
        [self hideAndCreateTextLayer];
        textViewSelected = NO;
        [self.delegate selectPreviousTool:self.previousType];
    }
    menuVisible = NO;
}

-(void)hideAndSaveTextViewWhenNewAdded{
    NSLog(@"HIDE AND SAVE text when new addded");
    
    [self.textViewNew resignFirstResponder];
    self.textViewNew.userInteractionEnabled = NO;
    [currentlyEditingView hideEditingHandles];
    [self.userResizableView removeFromSuperview];
    CGPoint origin = [self.textViewNew convertPoint:CGPointMake(self.textViewNew.frame.origin.x, self.textViewNew.frame.origin.y)  toView:self.window];
    CGRect rect = CGRectMake(origin.x,
                             origin.y,
                             self.textViewNew.bounds.size.width,
                             self.textViewNew.bounds.size.height);
    
    if([[self.textViewNew.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        self.drawingLayer = [JVDrawingLayer createTextLayerWithStartPoint:origin
                                                                    frame:rect
                                                                     text:self.textViewNew.text
                                                                     type:self.type
                                                                lineWidth:self.lineWidth
                                                                lineColor:self.lineColor
                                                                 fontSize:self.textViewFontSize
                                                               isSelected:NO];
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
        
        [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:self.drawingLayer];
        if (![self.undoManager isUndoing]) {
            [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
        }
        
        
        [self.drawingLayer addToTrack];
        [self.textViewNew removeFromSuperview];
        [self.delegate updateButtonStatus];
        self.drawingLayer = nil;
        
    }
    textViewSelected = NO;
    
}
-(void)removeTextViewFrame{
    if ([self.userResizableView.subviews containsObject:self.textViewNew]){
        [self hideAndCreateTextLayer];
        
    }
    
}

- (CGFloat)getTextViewHeight{
    return self.textViewNew.contentSize.height + 20;
}
- (void)hideHandlesAndMenu{
    if (menuForTextView.isMenuVisible) {
        [menuForTextView setMenuVisible:NO animated:YES];
    }
    menuVisible = NO;
    
}

-(void)getViewControllerId:(NSString*)nameOfView nameOfTechnique:(NSString *)techniqueName{

    currentTechniqueName = techniqueName;
    viewName = nameOfView;
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
}


- (void)configure
{
    undoManager = [[NSUndoManager alloc] init];

    self.arrayOfCircles = [NSMutableArray array];
    touchesMoved = NO;
    self.pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 500, 40)];
    self.pointsCoord = [NSMutableArray array];
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    self.undoRedoArray = [NSMutableArray array];

    self.bufferOfPoints = [NSMutableArray array];
    
    self.lineColor = tempColor;
    self.pointsCoord = [NSMutableArray array];
    self.arrayOfTextViews = [NSMutableArray array];
    self.tempLayersForUndo = [NSMutableArray array];


    
}


#pragma mark - magnifier functions

- (void)showLoupe:(NSTimer *)timer
{
    
//    if ((self.magnifierView == nil)&&(countGlobal == 1)) {
//        self.magnifierView = [[CHMagnifierView alloc] init];
//
//        self.magnifierView.viewToMagnify = self.window;
//
//
//    }
//
//    self.magnifierView.pointToMagnify = pointForLoupe;

    
}


- (void)showLoupe2:(NSTimer*)timer
{
    if(self.selectedLayer.type != JVDrawingTypeGraffiti){
        if (self.magnifierView == nil) {
            
            CGFloat radius = 60 / self.zoomFactor;
            
            CGPoint offset = CGPointMake(0, -radius );
            _magnifingGlass = [[MagnifyingGlassView alloc] initWithOffset:offset radius:radius scale:1.2 borderColor:[UIColor lightGrayColor] borderWidth:1 showsCrosshair:false crosshairColor:[UIColor lightGrayColor] crosshairWidth:0.5];
            
            _magnifingGlass.magnifiedView = self;
            [_magnifingGlass magnifyAt:pointForLoupe]; // location: CGPoint
            [self applyScale:((self.zoomFactor * [UIScreen mainScreen].scale) * [UIScreen mainScreen].scale) toView:_magnifingGlass];

        }
    }
}


#pragma mark - private functions

//- (void)addMagnifyingGlassTimer:(NSTimer*)timer {
//    NSValue *v = timer.userInfo;
//    CGPoint point = [v CGPointValue];
//    [self addMagnifyingGlassAtPoint:point];
//}

#pragma mark - magnifier functions
/*
- (void)addMagnifyingGlassAtPoint:(CGPoint)point {
    
    if (!magnifyingGlass) {
       // magnifyingGlass = [[ACMagnifyingGlass alloc] init];
        ACMagnifyingGlass *mag = [[ACMagnifyingGlass alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        mag.scale = 1.2;
        magnifyingGlass = mag;
    }
    
    if (!magnifyingGlass.viewToMagnify) {
        magnifyingGlass.viewToMagnify = self;
        
    }
    
    magnifyingGlass.touchPoint = point;
    [self addSubview:magnifyingGlass];
    [magnifyingGlass setNeedsDisplay];
}

- (void)removeMagnifyingGlass {
    [magnifyingGlass removeFromSuperview];
}

- (void)updateMagnifyingGlassAtPoint:(CGPoint)point {
    magnifyingGlass.touchPoint = point;
    [magnifyingGlass setNeedsDisplay];
}

*/
-(void)hideLoupe {
    [self.touchTimer invalidate];
    [self.magnifierView setHidden:YES];
    [self.magnifierView removeFromSuperview];
}

#pragma mark - Clear Screen

- (void)undoDrawLine:(JVDrawingLayer *)layer {
    NSLog(@"UNDO MAGAGER");
   
    //if ([self canUndo]) {
        if(self.selectedLayer.isSelected){
            [self removeCircles];
      //  }
        
        [self.layerArray removeObject:layer];
        // Redraw the view without the removed line
        
        [self updateAllPoints];
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
        
        // Register the redo action
        [self.undoManager registerUndoWithTarget:self selector:@selector(redoDrawLine:) object:layer];
    }
}
    
- (void)redoDrawLine:(JVDrawingLayer *)layer {
    NSLog(@"REDO MAGAGER");
   // if ([self canRedo]) {
        [self.layerArray addObject:layer];
        // Redraw the view with the added line

        [self updateAllPoints];
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
  //  }
        
        // Register the undo action
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoDrawLine:) object:layer];
    }



-(void)removeAllDrawings{
    [self hideMenu];
    for (CAShapeLayer * layer in self.layerArray) {
        [layer performSelector:@selector(removeFromSuperlayer)];
    }
    [self.layerArray removeAllObjects];
    self.selectedLayer.isSelected = NO;
    self.selectedLayer = nil;
    self.drawingLayer = nil;
    [self updateAllPoints];
    [self storeDataInJson];
    [self fetchData:[self.delegate getDataFromVC]];
    [self.delegate hideAdditionalColorPicker];
    [self.undoManager removeAllActions];
}
-(void)removeDrawingsForClosing{
    [self hideMenu];
    for (CAShapeLayer * layer in self.layerArray) {
        [layer performSelector:@selector(removeFromSuperlayer)];
    }
}

#pragma mark - Undo / Redo
- (BOOL)deleteLayerAction {
    BOOL status = [self.selectedLayer revokeUntilHidden];
    if (status) {
        [self.selectedLayer removeFromSuperlayer];
        [self.layerArray removeObject:self.selectedLayer];
        self.selectedLayer = nil;
        self.drawingLayer = nil;
        NSLog(@" Drawing views count %lu", [self.layer.sublayers count]);
    }
    return status;
}

- (void)addToTrackInDrawingView:(JVDrawingLayer*)layer {
    NSMutableDictionary *trackDic = [[NSMutableDictionary alloc] init];
    [trackDic setObject:NSStringFromCGPoint(layer.startPoint) forKey:@"startPoint"];
    if (layer.type == JVDrawingTypeGraffiti) {
        [trackDic setObject:NSStringFromCGPoint([layer.pointArray[0] CGPointValue]) forKey:@"startPoint"];
    }
    [trackDic setObject:NSStringFromCGPoint(layer.endPoint) forKey:@"endPoint"];
    [trackDic setObject:@(layer.isSelected) forKey:@"isSelected"];
    [trackDic setObject:@(layer.type) forKey:@"type"];
    [trackDic setObject:@(layer.lineWidth) forKey:@"width"];
    [trackDic setObject:layer.lineColor_ forKey:@"color"];


    
    [trackDic setObject:layer forKey:@"layer"];

    [self.tempLayersForUndo addObject:trackDic];
    
    NSLog(@"NUMBER OF OBJECTS in LAYERS DICT %lu", (unsigned long)self.tempLayersForUndo.count);

}

-(void)undo{
    
    NSMutableDictionary *trackDic = [self.tempLayersForUndo objectAtIndex:self.tempLayersForUndo.count-1];
    
    for (NSString *key in trackDic) {
        NSLog(@"Key: %@, Value: %@", key, [trackDic objectForKey:key]);
    }
    JVDrawingLayer * layer = trackDic[@"layer"];
   // [layer undoLayerActions:trackDic];
    NSLog(@"LAYER IS %@", layer.name);
    NSLog(@"layer array %@",self.layerArray);

    CAShapeLayer *foundLayer = nil;

    for (CAShapeLayer *layerToFind in self.layerArray) {
        // Check if the layer's identifier matches the one you're looking for
        if ([layerToFind isEqual:layer]) {
            // Found the layer
            foundLayer = layerToFind;
            break; // Exit the loop since we found the layer
        }
    }

    if (foundLayer) {
        // Layer with the specified identifier was found
        NSLog(@"Found layer: %@", foundLayer);
        
        if(JVDrawingTypeLine == layer.type){
                
            NSLog(@"Layer type is %ld", (long)layer.type);
           
            self.lastLayerInStack = [JVDrawingLayer createAllLayersAtStart:layer.startPoint endPoint:layer.endPoint type:layer.type  lineWidth:layer.lineWidth lineColor:layer.lineColor_ controlPoint:layer.controlPoint grafittiPoints:layer.pointArray];
            
            //[foundLayer removeFromSuperlayer];
           // [self.layerArray removeObject:foundLayer];
            [self.layer addSublayer:self.lastLayerInStack];
        }
        else {
            
            NSLog(@"Layer type is not LINE");
        }
        
        [self.tempLayersForUndo removeLastObject];
        
    } else {
        // Layer with the specified identifier was not found
        NSLog(@"Layer with identifier %@ not found", layer.name);
    }
    
    
   
}







- (void)addLayerToUndoManager:(JVDrawingLayer*)layer {
    [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoStack:layer];
    if (![self.undoManager isUndoing]) {
        [self.undoManager setActionName:NSLocalizedString(@"actions.add", @"Add Shape")];
    }
    
    [self.layer addSublayer:layer];
    [self.layerArray addObject:layer];
    NSLog(@"add figure");

}


-(void)addLayerToUndoStack:(JVDrawingLayer*)shape{
    
//    [[self.undoManager prepareWithInvocationTarget:self]addLayerToUndoManager:shape];
//    if (![self.undoManager isUndoing]) {
//       [self.undoManager setActionName:NSLocalizedString(@"actions.remove", @"Remove Shape")];
//    }
    
    [self.layerArray removeObject:shape];
    [shape removeFromSuperlayer];
    [shape setNeedsDisplay];
    NSLog(@"remove figure");

}

- (void)moveDrawing:(JVDrawingLayer *)layer  {
    NSLog(@"Move figure");
    
    if (self.tempLayersForUndo.count > 0){
        JVDrawingLayer *lastDrawing = [self.layerArray lastObject];
        [lastDrawing removeFromSuperlayer]; // Remove from canvas
        [self.layerArray removeLastObject];
        [lastDrawing setNeedsDisplay];
        
        NSUInteger previousLayer = self.tempLayersForUndo.count-1;
       self.drawingLayer = [self.tempLayersForUndo objectAtIndex:previousLayer];
        
        [self.tempLayersForUndo removeLastObject];
    
        [self.layer addSublayer:self.drawingLayer];
        [self.layerArray addObject:self.drawingLayer];
        
//        [self updateAllPoints];
//        [self storeDataInJson];
    }
}


-(void)removeShapeById:(int)uid{
    
    for(JVDrawingLayer* shape in [self.layerArray reverseObjectEnumerator]){
        if([shape getUid] == uid){
            [self.layerArray removeObject:shape];
            [shape removeFromSuperlayer];
            
        }
    }
    
}



- (NSUInteger)undoSteps
{
    return self.bufferOfLayers.count;
}
- (BOOL)canUndo
{
    return self.layerArray.count > 0;
}

- (BOOL)canRedo
{
    return self.bufferOfLayers.count > 0;
}
- (void)undoLatestStep
{
    
   // [undoManager undo];

//    if ([self canUndo]) {
//        if(self.selectedLayer.isSelected){
//            [self removeCircles];
//        }
//        //[self.bufferOfLayers addObject:[self.layerArray lastObject]];
//
//        [self.bufferOfLayers addObject:[self.undoRedoArray lastObject]];
//        JVDrawingLayer * layerToRemove = [self.undoRedoArray lastObject];
//
//        [layerToRemove removeFromSuperlayer];
//       // [[self.layerArray lastObject] removeFromSuperlayer];
//
//        [self.layerArray removeObjectIdenticalTo:[self.undoRedoArray lastObject]];
//        [self.undoRedoArray removeLastObject];
//        //[self.layerArray removeLastObject];
//
//        [self updateAllPoints];
//        [self storeDataInJson];
//        [self fetchData:[self.delegate getDataFromVC]];
//    }
    NSLog(@"buffer array cont %lu", self.bufferOfLayers.count);
    
}
-(void)redoLatestStep{
    if ([self canRedo]) {
        [self.layer addSublayer: [self.bufferOfLayers lastObject]];
        [self.layerArray addObject:[self.bufferOfLayers lastObject]];
        [self.undoRedoArray addObject:[self.bufferOfLayers lastObject]];
        
        [self.bufferOfLayers removeLastObject];
        [self updateAllPoints];
        [self storeDataInJson];
        [self fetchData:[self.delegate getDataFromVC]];
    }
}


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

#pragma mark Angle Detection

-(void)autoPosition:(CGPoint*)currentPoint basePoint:(CGPoint)firstPoint{
    double dist = hypot((firstPoint.x - currentPoint->x), (firstPoint.y - currentPoint->y));
    CGFloat f = [self pointPairToBearingDegrees:firstPoint secondPoint:*currentPoint];
    
    if ((f<=48)&&(f>=42)&&dist>8){
        double angle =   0.785398163;
        double endX = cos(angle) * dist + firstPoint.x;
        double endY = sin(angle) * dist + firstPoint.y;
        *currentPoint = CGPointMake(endX, endY);
        if(!performed45){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            NSLog(@"HAPTIC PERFORM 45");
            performed45 = true;
        }
    }else{ performed45 = false;}
    if ((f<=138)&&(f>=132)&&dist>8){
        double angle =   2.35619449;
        double endX = cos(angle) * dist + firstPoint.x;
        double endY = sin(angle) * dist + firstPoint.y;
        *currentPoint = CGPointMake(endX, endY);
        if(!performed135){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            NSLog(@"HAPTIC PERFORM 135");

            performed135 = true;
        }
    }else{ performed135 = false;}
    if ((f<=228)&&(f>=222)&&dist>8){
        double angle =   3.92699082;
        double endX = cos(angle) * dist +firstPoint.x;
        double endY = sin(angle) * dist + firstPoint.y;
        *currentPoint = CGPointMake(endX, endY);
        if(!performed225){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            NSLog(@"HAPTIC PERFORM 225");

            performed225 = true;
        }
    }else{ performed225 = false;}
    if ((f<=318)&&(f>=312)&&dist>8){
        double angle =   5.49778714;
        double endX = cos(angle) * dist + firstPoint.x;
        double endY = sin(angle) * dist + firstPoint.y;
        *currentPoint = CGPointMake(endX, endY);
        if(!performed315){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            NSLog(@"HAPTIC PERFORM 315");

            performed315 = true;
        }
    }else{ performed315 = false;}
    if((currentPoint->x - firstPoint.x <= 6)&&(currentPoint->x - firstPoint.x >= -6)&&dist>10){
        *currentPoint = CGPointMake(firstPoint.x, currentPoint->y);
        if(!performedX){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            performedX = true;
        }
    }else{ performedX = false;}
    if((currentPoint->y - firstPoint.y <= 6)&&(currentPoint->y - firstPoint.y >= -6)&&dist>10){
        *currentPoint = CGPointMake(currentPoint->x, firstPoint.y);
        if(!performedY){
            [HapticHelper generateFeedback:FeedbackType_Impact_Light ];
            performedY = true;
        }
    }else{performedY = false;}
}
- (void)writeStringToFile:(NSMutableArray*)arr {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    
//    if([_jsonKey isEqualToString:@"jsonLeft"]){
//
//        document.dictLeft = jsonData;
//    }
    [self.delegate saveDataToUIDocument:jsonData];
    
  // [[[DiagramFile sharedInstance]diagramFileDictionary] setObject:jsonData  forKey:_jsonKey];
    
}



- (NSMutableArray*)addLayerInfoToDict:(JVDrawingLayer*)layer{
    
    
    NSMutableArray * stringArray = [self converGraffitiPointsToString:layer];
    NSString *fontSizeStr = [[NSNumber numberWithFloat:layer.fontSize] stringValue];
    NSString *widthStr = [[NSNumber numberWithFloat:layer.lineWidth_] stringValue];
    NSString *textWidth = [[NSNumber numberWithFloat:layer.width] stringValue];
    NSString *textHeight = [[NSNumber numberWithFloat:layer.height] stringValue];
    NSString *colorStr = [[CIColor colorWithCGColor:[layer.lineColor_ CGColor]] stringRepresentation];
    
    NSLog(@"color string saving %@",colorStr);
    
    NSMutableDictionary *dictOfLayers = [NSMutableDictionary dictionary];
    NSMutableDictionary *layerProperties = [NSMutableDictionary dictionary];
    NSMutableDictionary *arrayOfPoint = [NSMutableDictionary dictionary];
    [arrayOfPoint setObject: stringArray forKey:@"points"];
    if (layer.type != JVDrawingTypeGraffiti){
        layerProperties[@"startPoint"] = NSStringFromCGPoint(layer.startPoint);
        layerProperties[@"endPoint"] = NSStringFromCGPoint(layer.endPoint);
    }else{
        layerProperties[@"pointArray"] = arrayOfPoint;
        layerProperties[@"startPoint"] = NSStringFromCGPoint([layer.pointArray[0] CGPointValue]);
        layerProperties[@"endPoint"] = NSStringFromCGPoint([[layer.pointArray lastObject] CGPointValue]);
    }
    layerProperties[@"imagedirection"] = layer.imageDirection;
    layerProperties[@"text"] = layer.text;
    layerProperties[@"height"] =  textHeight;
    layerProperties[@"width"] = textWidth;
    layerProperties[@"controlPoint"] = NSStringFromCGPoint(layer.controlPointOfCurve);
    layerProperties[@"fontSize"] = fontSizeStr;
    layerProperties[@"lineWidth"] = widthStr;
    layerProperties[@"lineColor"] = colorStr;
    layerProperties[@"isSelected"] = @(layer.isSelected);
    layerProperties[@"type"] = @(layer.type);
    dictOfLayers[@"layerproperties"] = layerProperties;
    dictOfLayers[@"id"] = [layer description];
    
    [self.arrayOfLayersForJSON addObject:dictOfLayers];
    NSLog(@"NUMBER OF OBJECTS in LAYERS DICT %lu", (unsigned long)self.arrayOfLayersForJSON.count );
    return self.arrayOfLayersForJSON;
}

- (void)storeDataInJson {
    [self.arrayOfLayersForJSON removeAllObjects];
    for (JVDrawingLayer *layer in self.layerArray) {
        [self writeStringToFile:[self addLayerInfoToDict:layer]];
    }
    if(self.layerArray.count == 0){
        [self writeStringToFile:[self removeObjectFromJSON]];
    }
}
- (NSMutableArray *)converGraffitiPointsToString:(JVDrawingLayer *)layer {
    NSMutableArray * stringArray = [[NSMutableArray alloc]init];
    for (int j = 0; j<layer.pointArray.count; j++) {
        NSString * resultString = NSStringFromCGPoint([[layer.pointArray objectAtIndex:j] CGPointValue]);
        [stringArray addObject:resultString];
    }
    
    
    return stringArray;
}

-(void)fetchData:(NSData*)jsonData{
    
//    /* LOCAL FETCHING*/
//    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//    NSString *docDirectory = [sysPaths objectAtIndex:0];
//    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
//    //NSLog(@"filepath %@", filePath);
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSError *err;
//    if (err){
//        NSLog(@"Failed to serialize into JSON: %@", err);
//        return;
//    }
    
    //NSMutableDictionary* tempDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
  
    //NSData * jsonDataFromDict = [[[DiagramFile sharedInstance]diagramFileDictionary] objectForKey:_jsonKey];
    
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

    NSMutableDictionary * props = [NSMutableDictionary dictionary];
    NSMutableDictionary * array = [NSMutableDictionary dictionary];
    if(json.count >0){
        for (NSDictionary *dictOfLayers in json) {
            NSString *name = dictOfLayers[@"id"];
            props = [dictOfLayers objectForKey:@"layerproperties"];
            array = [props objectForKey:@"pointArray"];
            
            NSString *lineWidth = props[@"lineWidth"];
            NSString *lineColor = props[@"lineColor"];
            NSString *startPoint = props[@"startPoint"];
            NSString *endPoint = props[@"endPoint"];
            NSString *layerType = props[@"type"];
            NSString *fontSize = props[@"fontSize"];
            NSString *controlPoint = props[@"controlPoint"];
            NSString *textWidth = props[@"width"];
            NSString *textHeight = props[@"height"];
            NSString *text = props[@"text"];
            NSString *imgDirection = props[@"imagedirection"];

            NSArray *grPoints = array[@"points"];
            
            LayersData *layers = LayersData.new;
            layers.startPoint = CGPointFromString(startPoint);
            layers.endPoint = CGPointFromString(endPoint);
            layers.lineWidth = [lineWidth floatValue];
            
            layers.color = [self getColorFromString:lineColor];
            layers.type = layerType;
            layers.fontSize = [fontSize floatValue];
            layers.controlPoint = CGPointFromString(controlPoint);
            layers.layerID = name;
            layers.height = [textHeight floatValue];
            layers.width = [textWidth floatValue];
            layers.text = text;
            layers.grafittiPoints = grPoints;
            layers.imageDirection = imgDirection;
            NSLog(@"img direct %@", layers.imageDirection);

            [self.arrayOfLayersForJSON addObject:layers];
            
        }
    }
}

-(UIColor*)getColorFromString:(NSString*)colorString{
    NSArray *parts = [colorString componentsSeparatedByString:@" "];
    UIColor *colorFromString = [UIColor colorWithRed:[parts[0] floatValue]
                                               green:[parts[1] floatValue]
                                                blue:[parts[2] floatValue]
                                               alpha:[parts[3] floatValue]];
    NSLog(@"COLOR COLOR %@", colorFromString);
    return colorFromString;
}


-(NSMutableArray*)removeObjectFromJSON {
    [self.arrayOfLayersForJSON removeAllObjects];
    return self.arrayOfLayersForJSON;
}

#pragma mark BringArrowsToFront
-(void)bringArrowsToFront{
    
    for(JVDrawingLayer * layer in self.layerArray){
        if(layer.type == JVDrawingTypeArrow){
            [self.layer insertSublayer:layer above:[self.layerArray lastObject]];
        }
    }
}

/*
 
 - (void)fetchCoursesUsingJSON {
 NSLog(@"Fetching Courses");
 //
 
 NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 NSString* fileName = @"layersdata.json";
 NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
 
 NSString *urlString = @"https://hairtechapp.com";
 NSURL *url = [NSURL URLWithString:urlString];
 
 [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
 NSLog(@"Finished fetching courses....");
 
 NSError *err;
 NSArray *courseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
 if (err){
 NSLog(@"Failed to serialize into JSON: %@", err);
 return;
 }
 
 NSMutableDictionary * props = [NSMutableDictionary dictionary];
 NSMutableDictionary * array = [NSMutableDictionary dictionary];
 
 for (NSDictionary *dictOfLayers in courseJSON) {
 NSString *name = dictOfLayers[@"id"];
 props = [dictOfLayers objectForKey:@"layerproperties"];
 array = [props objectForKey:@"pointArray"];
 
 NSString *lineWidth = props[@"lineWidth"];
 NSString *lineColor = props[@"lineColor"];
 NSString *startPoint = props[@"startPoint"];
 NSString *endPoint = props[@"endPoint"];
 NSString *layerType = props[@"type"];
 NSString *fontSize = props[@"fontSize"];
 NSString *controlPoint = props[@"controlPoint"];
 NSString *textWidth = props[@"width"];
 NSString *textHeight = props[@"height"];
 NSString *text = props[@"text"];
 NSArray *grPoints = array[@"points"];
 
 LayersData *layers = LayersData.new;
 layers.startPoint = CGPointFromString(startPoint);
 layers.endPoint = CGPointFromString(endPoint);
 layers.lineWidth = [lineWidth floatValue];
 
 layers.color = [self getColorFromString:lineColor];
 layers.type = layerType;
 layers.fontSize = [fontSize floatValue];
 layers.controlPoint = CGPointFromString(controlPoint);
 layers.layerID = name;
 layers.height = [textHeight floatValue];
 layers.width = [textWidth floatValue];
 layers.text = text;
 layers.grafittiPoints = grPoints;
 NSLog(@"array of points %lu", grPoints.count);
 
 [self.arrayOfLayersForJSON addObject:layers];
 }
 
 }] resume];
 
 }*/








@end
