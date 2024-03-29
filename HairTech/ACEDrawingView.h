
#import <UIKit/UIKit.h>
#import "ColorViewController.h"
#import "TextViewCustom.h"
#import "UITextView+PinchZoom.h"
#import "JVDrawingLayer.h"
#import "CircleLayer.h"
#import "TextRect.h"
#import "SPUserResizableView.h"
#import "LayersData.h"
#import "FrameLayer.h"
#import "CHMagnifierView.h"
#import "ACMagnifyingGlass.h"
#import "Hairtech-Bridging-Header.h"
#import "Hairtech-Swift.h"
#define ACEDrawingViewVersion   1.0.0

typedef enum {
    ACEDrawingToolTypePen,
    ACEDrawingToolTypeCurve,
    ACEDrawingToolTypeDashCurve,
    ACEDrawingToolTypeDashLine,
    ACEDrawingToolTypeArrow,
    ACEDrawingToolTypeLine,
    ACEDrawingToolTypeEraser,
    ACEDrawingToolTypeText,
   
} ACEDrawingToolType;

@protocol ACEDrawingViewDelegate, ACEDrawingTool,ACEDrawingViewDataSource;

@interface ACEDrawingView : UIView <ColorViewControllerDelegate,UITextViewDelegate,SPUserResizableViewDelegate>

{
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
    SEL changer;
    
    CGRect screenRect;
    
    CGFloat screenHeight;
    
    CGPoint pointOfStart;
    BOOL pointConnected;
    BOOL performedX;
    BOOL performedY;
    BOOL performed45;
    BOOL performed135;
    BOOL performed225;
    BOOL performed315;
    double distGlobal;
    unsigned long countGlobal;
    CGPoint pointForLoupe;
    NSArray *sortedArray;
    CGPoint arrowEndPoint;
    
    UIImageView *dot;
    UIImageView *dot2;
    UITapGestureRecognizer *lineTapRecognizer;
    CAShapeLayer *line;
    UIBezierPath *linePath;
    CALayer *drawingLayer;
    BOOL pathContainsPoint;
    
    NSArray *arrayOfLastPoints;
    NSMutableArray *arrayOfPoints;
    
    double distToPoint;
    CGPoint location1;
    CGPoint location2;
    CGPoint touchToCalculateDistance;
    
    CGPoint pointToReplaceInArray;
    BOOL replacedPoint;
    
    NSUInteger touchMove;
    
    
    CGPoint firstOrReplacedPoint;
    NSMutableDictionary *data;
    
    NSString *viewName;
    NSString *currentTechniqueName;
    CAShapeLayer *lineNew;
    
    NSMutableArray *lookupArray;
    
    BOOL touchesMoved;
    BOOL menuVisible;
    BOOL frameVisible;
    UIMenuController * menu;
    UIMenuController * menuForTextView;
    
    
    CGFloat previousWidth;
    CGFloat previousHeight;
    UITapGestureRecognizer * gestureRecognizer;
    UITapGestureRecognizer * gestureRecognizer2;
    UITapGestureRecognizer * gestureRecognizerDot;
    
    UITapGestureRecognizer * gestureRecognizerHidingDot;
    
    BOOL textViewSelected;
    CGPoint startOfLine;
    CGPoint currentPointOfLine;
    CGFloat zoomIdx;
    CGPoint bufferStartPoint;
    CGPoint bufferEndPoint;
    int cycle;
    CGFloat distanceBetweentTouches;
    CGPoint pointBegin;
    CGPoint pointEnd;
    
    BOOL _magnetActivated;
    NSData * _jsonData;
    NSString * _jsonKey;
    
    BOOL touchCanceled;
    UIWindow *window;
    NSUndoManager* undoManager;


}

@property (nonatomic, strong) NSMutableArray<JVDrawingLayer *> *undoStack;
@property (nonatomic, strong) NSMutableArray *tempLayersForUndo;


@property (nonatomic, assign) CGFloat magnifyingGlassShowDelay;
@property  CHMagnifierView * magnifierView;
@property MagnifyingGlassView * magnifingGlass;
@property (nonatomic, retain) NSTimer *touchTimer;
- (void)addMagnifyingGlassAtPoint:(CGPoint)point;
- (void)removeMagnifyingGlass;
- (void)updateMagnifyingGlassAtPoint:(CGPoint)point;


- (void)applyScale:(CGFloat)scale toView:(UIView *)view;

-(void)setJsonData:(NSData*)jsonData;
-(void)setJsonKey:(NSString*)jsonKey;

-(void)setMagnetActivated:(BOOL)activated;

@property CAShapeLayer * dot;
@property UIView * viewForDot;

@property     NSMutableArray * undoRedoArray;
@property NSMutableArray * bufferOfLayers;
@property NSMutableString * fileNameInside;
@property BOOL newAppVersion;
@property (strong, nonatomic) NSMutableArray<LayersData *> *layers;

@property (nonatomic, strong) NSDictionary * layersDict;
@property (nonatomic, strong) NSMutableArray * arrayOfLayersForJSON;
@property (nonatomic, strong) NSMutableArray * fetchedLayersFromJSON;

@property CGFloat textViewFontSize;
-(void)enableGestures;
-(void)disableGestures;
-(void)addFrameForTextView:(CGRect)rect centerPoint:(CGPoint)center text:(NSString*)text color:(UIColor*)color font:(CGFloat)fontSize;
-(void)hideAndSaveTextViewWhenNewAdded;

-(void)addDotToView:(CGPoint)centerPoint;
-(void)addClipperToView:(CGPoint)centerPoint;
-(void)addRazorToView:(CGPoint)centerPoint;
-(void)addTextToView:(CGPoint)centerPoint;

@property SPUserResizableView *userResizableView;
@property SPUserResizableView *userResizableDotView;

@property (nonatomic, retain) TextViewCustom * textViewNew;
@property (nonatomic, assign) BOOL eraserSelected;
@property (nonatomic, copy) void (^drawingLayerSelectedBlock)(BOOL isSelected);
@property (nonatomic, assign) JVDrawingType type;
@property (nonatomic, assign) JVDrawingType bufferType;
@property (nonatomic ,assign) id previousType;
@property (nonatomic ,assign) id textTypesSender;


@property (nonatomic, assign) CircleLayer * circleLayer1;
@property (nonatomic, assign) CircleLayer * circleLayer2;
@property (nonatomic, assign) CircleLayer * circleLayer3;
@property (nonatomic, assign) CircleLayer * circleLayer4;
@property (nonatomic, assign) FrameLayer * frameForDot;

@property (nonatomic, assign) TextRect * textRect;



-(void)removeCircles;
@property NSMutableArray * arrayOfCircles;
@property NSMutableArray * arrayOfTextViews;

@property CGFloat zoomFactor;

- (void)revoke;
-(void)addTextViewToRect:(CGRect)rect;


-(void)adjustRectWhenTextChanged:(CGRect)rect;
-(void)updateZoomFactor:(CGFloat)zoomFactor;
-(void)addJVDTextView;


@property (nonatomic, weak) IBOutlet id <ACEDrawingViewDataSource> dataSource;

- (void)reloadData;
- (void)reloadDataInRect:(CGRect)rect;



-(void)getViewControllerId:(NSString*)nameOfView nameOfTechnique:(NSString*)techniqueName;


//-(void)savePointsToDefaults;

@property (nonatomic, strong) NSString *viewControllerName;

@property (nonatomic, strong) UIBezierPath *tapTarget;

@property  UIImageView *dragger;
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@property (nonatomic,retain) UIImageView *lastDot;

@property CGPoint pointForRecognizer;
@property BOOL editMode;
@property BOOL editModeforText;

@property BOOL pan;
@property CGPoint touchCoord;
@property int touchesCount;
@property int touchesForUpdate;
@property CGPoint firstTouch;
@property CGPoint lastTouch;

@property (nonatomic,assign) CGPoint a;
@property (nonatomic,assign) CGPoint b;
@property (nonatomic,assign) CGPoint c;
@property (nonatomic,assign) CGPoint d;



@property (nonatomic,assign) CGPoint pa;
@property (nonatomic,assign) CGPoint pb;
@property (nonatomic,assign) CGPoint pc;
@property (nonatomic,assign) CGPoint pd;

@property (nonatomic, assign) ACEDrawingToolType drawTool;
@property (nonatomic, assign) id<ACEDrawingViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *eraserPointer;
@property  BOOL *editModeCanceled;
-(void)hidePoints;
@property (nonatomic, strong) NSMutableArray *pointsCoord;
@property (nonatomic, strong) UILabel *pointsLabel;



 //@property int  touchMove;
@property int  touchesForEditMode;
@property int touchForText;

//-(IBAction)buttonTouched:(id)sender;

//@property (nonatomic,assign) IBOutlet UIButton *btn;

-(void)keyboardWillShow1;
-(void)keyboardWillHide1;


// public properties
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *dashlineColor;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *eraserColor;

@property (nonatomic, strong) UIColor *FIRSTlineColor;



@property (nonatomic, assign) CGFloat penWidth;
@property (nonatomic, assign) CGFloat dashlineWidth;
//@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat eraserWidth;



//@property (nonatomic, assign) CGFloat lineAlpha;


// get the current drawing
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) NSUInteger undoSteps;

-(void)updateImage;
@property UIColor* firstColor;
@property UIColor* tempColor;
-(void)addTextViewToMiddle;
// erase all
- (void)clear;
-(void)removeAllDrawings;
-(void)removeDrawingsForClosing;
- (void)hideAndCreateTextLayer;
-(void)removeTextViewFrame;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;
-(void)getScreenShot:(UIImage*)img;
//@property (nonatomic, weak)IBOutlet UIPanGestureRecognizer *panRecognizer;
//@property (nonatomic, weak)IBOutlet UITapGestureRecognizer *tapRecognizer;





- (NSUInteger)numberOfShapesInDrawingView:(ACEDrawingView *)drawingView;
- (UIBezierPath *)drawingView:(ACEDrawingView *)drawingView pathForShapeAtIndex:(NSUInteger)shapeIndex;
- (UIColor *)drawingView:(ACEDrawingView *)drawingView lineColorForShapeAtIndex:(NSUInteger)shapeIndex;

- (NSUInteger)indexOfSelectedShapeInDrawingView:(ACEDrawingView *)drawingView;


-(void)removeCirclesOnZoomDelegate;
-(void)bringArrowsToFront;
//-(void)loadJSONData:(NSMutableString*)fileName;
-(void)loadJSONData:(NSData*)jsonData;
-(void)setNewColorForTools:(UIColor*)color;


@end

#pragma mark -
@protocol ACEDrawingViewDelegate <NSObject>
double dist(CGPoint a, CGPoint b);
double dist2(CGPoint a, CGPoint b);
- (UIColor *)colorAtPixel:(CGPoint)point;
-(void)setButtonVisibleTextPressed;
-(void)setButtonVisible;
-(void)selectPreviousTool:(id)sender;
-(void)selectTextTool:(id)sender textColor:(UIColor*)color fontSize:(CGFloat)fontSZ isSelected:(BOOL)isSelected;
-(void)additionalToolsColorPopover:(UIColor*)color;
-(void)hideAdditionalColorPicker;
-(void)removeTextSettings;
-(void)disableZoomWhenTouchesMoved;
-(void)enableZoomWhenTouchesMoved;
-(void)updateButtonStatus;
-(void)selectCurentToolWhenLineSelected:(NSInteger)tool;

-(void)saveDataToUIDocument:(NSData*)data;
-(NSData*)getDataFromVC;
@optional
- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
@end
