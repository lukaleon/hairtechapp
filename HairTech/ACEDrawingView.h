
#import <UIKit/UIKit.h>
#import "ColorViewController.h"
#import "TextView.h"
#import "UITextView+PinchZoom.h"
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

@protocol ACEDrawingViewDelegate, ACEDrawingTool;

@interface ACEDrawingView : UIView <ColorViewControllerDelegate,UITextViewDelegate>

{
    SEL changer;
    
    CGRect screenRect;
 
    CGFloat screenHeight;
    
    CGPoint pointOfStart;
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
    
}
@property (nonatomic, strong) UIBezierPath *tapTarget;

- (void)reloadDataInRect:(CGRect)rect;

@property (nonatomic, strong) NSMutableArray *shapes;

@property (nonatomic, assign) NSUInteger selectedShapeIndex;



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

@property (nonatomic, unsafe_unretained) IBOutlet UITextView *textView;




////////////
@property (nonatomic, assign) ACEDrawingToolType drawTool;
@property (nonatomic, assign) id<ACEDrawingViewDelegate> delegate;

- (void)reloadDataInRect:(CGRect)rect;


@property (nonatomic, strong) UIImageView *eraserPointer;

@property (nonatomic, strong) UIImageView *pixelBox;
@property (nonatomic, strong) UIImageView *pixelBox2;
@property (nonatomic, strong) UIImageView *pixelBox3;
@property (nonatomic, strong) UIImageView *pixelBox4;
@property (nonatomic, strong) UIImageView *pixelBox5;
@property (nonatomic, strong) UIImageView *pixelBox6;
@property (nonatomic, strong) UIImageView *pixelBox7;
@property (nonatomic, strong) UIImageView *pixelBox8;
@property (nonatomic, strong) UIImageView *pixelBox9;
@property (nonatomic, strong) UIImageView *pixelBox10;
@property (nonatomic, strong) UIImageView *pixelBox11;
@property (nonatomic, strong) UIImageView *pixelBox12;
@property (nonatomic, strong) UIImageView *pixelBox13;
@property (nonatomic, strong) UIImageView *pixelBox14;
@property (nonatomic, strong) UIImageView *pixelBox15;
@property (nonatomic, strong) UIImageView *pixelBox16;
@property (nonatomic, strong) UIImageView *pixelBox17;
@property (nonatomic, strong) UIImageView *pixelBox18;
@property (nonatomic, strong) UIImageView *pixelBox19;
@property (nonatomic, strong) UIImageView *pixelBox20;
@property (nonatomic, strong) UIImageView *pixelBox21;
@property (nonatomic, strong) UIImageView *pixelBox22;
@property (nonatomic, strong) UIImageView *pixelBox23;
@property (nonatomic, strong) UIImageView *pixelBox24;
@property (nonatomic, strong) UIImageView *pixelBox25;
@property (nonatomic, strong) UIImageView *pixelBox26;
@property (nonatomic, strong) UIImageView *pixelBox27;

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

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

-(void)getScreenShot:(UIImage*)img;
//@property (nonatomic, weak)IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@end

#pragma mark -

@protocol ACEDrawingViewDelegate <NSObject>

- (UIColor *)colorAtPixel:(CGPoint)point;


double dist(CGPoint a, CGPoint b);
double dist2(CGPoint a, CGPoint b);
-(void)setButtonVisibleTextPressed;
-(void)setButtonVisible;



@optional

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;




@end
