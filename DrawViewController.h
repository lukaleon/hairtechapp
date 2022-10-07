
#import <UIKit/UIKit.h>
#import "EntryViewController.h"
#import "sqlite3.h"

#import "WEPopoverController.h"
#import "ColorViewController.h"
#import "AppDelegate.h"
#import "ACEDrawingView.h"
#import "toolbar.h"

#import "AMPopTip.h"

@class DrawViewController;
@class EntryViewController;
@protocol DrawViewControllerDelegate<NSObject>

-(void) passItemBack:(DrawViewController *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5;

-(void)selectedBtn:(NSString*)color;



@end





@interface DrawViewController : UIViewController<WEPopoverControllerDelegate, UIPopoverControllerDelegate,ACEDrawingViewDelegate ,ColorViewControllerDelegate , UIScrollViewDelegate, UITextViewDelegate>{
    
    
    
    EntryViewController*entryView;
    NSData * data;
    NSData * thumbdata;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    CGFloat red_blue;
    CGFloat green_blue;
    CGFloat blue_blue;
    CGFloat brush_blue;
    CGFloat alpha_blue;
    
    
    
    
    CGFloat red_red;
    CGFloat green_red;
    CGFloat blue_red;
    CGFloat brush_red;
    CGFloat alpha_red;
    
    CGFloat red_pen;
    CGFloat green_pen;
    CGFloat blue_pen;
    CGFloat brush_pen;
    CGFloat alpha_pen;
    
    CGFloat red_line;
    CGFloat green_line;
    CGFloat blue_line;
    CGFloat brush_line;
    CGFloat alpha_line;
    
    CGFloat red_eraser;
    CGFloat green_eraser;
    CGFloat blue_eraser;
    
    CGFloat redtemp1;
    CGFloat greentemp1;
    CGFloat bluetemp1;
    CGFloat alphatemp1;
    
    CGFloat redtemp2;
    CGFloat greentemp2;
    CGFloat bluetemp2;
    CGFloat alphatemp2;
    
    CGFloat redtemp3;
    CGFloat greentemp3;
    CGFloat bluetemp3;
    CGFloat alphatemp3;
    CGFloat redtemp4;
    CGFloat greentemp4;
    CGFloat bluetemp4;
    CGFloat alphatemp4;
    
    CGFloat redtemp5;
    CGFloat greentemp5;
    CGFloat bluetemp5;
    CGFloat alphatemp5;

    

    
    CGFloat alpha;
    
    CGFloat brush;
    CGFloat brush_eraser;
    
    CGFloat opacity;
    
    int dashLineCount;
    
    
    
    UIActionSheet *actionSheet1;
    CGPoint lastPoint;
    CGPoint firstPoint;
    CGPoint lastMovePoint;

    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
    
       BOOL mouseSwiped;
    
    UIColor * mycolor;
    
    UIColor * tempColor;
    
    int x;
    int y;
  //  NSString *picFullPath;
    //NSString *tempFileName;
    NSMutableString *filenamethumb1;
    NSMutableString *filenamebig1;
    UIImage *tempthumbimage;
    
    
    IBOutlet UIButton* loginButton;

    WEPopoverController *popoverController;

    

    IBOutlet UILongPressGestureRecognizer *longpresspenbtn;

    IBOutlet UILongPressGestureRecognizer *longpressblackbtn;
    
    IBOutlet UILongPressGestureRecognizer *longpressbluebtn;
    
    IBOutlet UILongPressGestureRecognizer *longpressredbtn;
    
    IBOutlet UILongPressGestureRecognizer *longpresslinebtn;
    
    __weak IBOutlet UIBarButtonItem *popoverBtn;
    
     IBOutlet UIScrollView *scrollView;

    
    
    BOOL digitsPopTipDismissed;
    BOOL timerPopTipDismissed;
    NSArray *buttons;
    BOOL textSelected;
    BOOL curveToggleIsOn;
    ColorViewController *contentTextView;
    ColorViewController *contentViewController;
    BOOL textSetterState;

}
@property CGFloat fontSizeVC;
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;


@property (nonatomic, strong) AMPopTip *popTipLine;
@property (nonatomic, strong) AMPopTip *popTipCurve;



@property (weak,nonatomic) IBOutlet UIToolbar *toolbar1;

@property (nonatomic, retain) UIPopoverController *listPopoverdraw1;
@property (weak, nonatomic) IBOutlet UIView *viewForImg;

@property (nonatomic, weak) IBOutlet ACEDrawingView *drawingView;
@property (nonatomic, weak) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, weak) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property (nonatomic, weak) IBOutlet UIImageView *NewImageView;

@property (weak, nonatomic) IBOutlet UIButton *undoBut;

@property (weak, nonatomic) IBOutlet UIButton *redoBut;

-(IBAction)buttonTouched:(id)sender;

@property (nonatomic,assign) IBOutlet UIButton *btn;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToEntry;

- (IBAction)closeActionSheet:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel * colorBar1;
@property (weak, nonatomic) IBOutlet UILabel * colorBar2;
@property (weak, nonatomic) IBOutlet UILabel * colorBar3;
@property (weak, nonatomic) IBOutlet UILabel * colorBar4;

@property (weak,nonatomic) IBOutlet UIImageView * toolbarImg;

@property (nonatomic, strong) WEPopoverController *popoverController;
@property (nonatomic, strong) WEPopoverController *popoverTextSettings;

@property (nonatomic, retain) UIPopoverController *listPopoverDrawController;
@property (weak,nonatomic)UIImage *imagethumb1;
@property (weak,nonatomic)UIImage *imagethumb2;
@property (weak,nonatomic)UIImage *imagethumb3;
@property (weak,nonatomic)UIImage *imagethumb4;
@property (weak,nonatomic)UIImage *imagethumb5;

@property (weak,nonatomic)UIImage *imagebig1;
@property (weak,nonatomic) UIImage *myImage;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *baritem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *popoverBtn;

@property (weak, nonatomic) id<DrawViewControllerDelegate>drawcontrollerdelegate;

@property (weak, nonatomic)NSString *stringForLabel;

@property (weak, nonatomic) IBOutlet UIImageView *loadImg;

@property (weak, nonatomic) IBOutlet UIImageView *middleImg;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIButton *blackbtn;

@property (weak, nonatomic) IBOutlet UIButton *bluebtn;
@property (weak, nonatomic) IBOutlet UIButton *redbtn;
@property (weak, nonatomic) IBOutlet UIButton *textbtn;


/////////////////////////
@property (weak, nonatomic) IBOutlet UIButton *penbtn;
@property (weak, nonatomic) IBOutlet UILabel * colorBar5;
@property UIColor* penExtract;


//////////////////////////




@property (weak, nonatomic) IBOutlet UILabel *labelDrawController;
@property (weak, nonatomic) NSMutableString *foo;
- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *eraserbtn;
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)UndoButton:(id)sender;

- (IBAction)RedoButton:(id)sender;


- (IBAction)textaText:(id)sender;
-(void)popoverChecking;
-(void)colorWithHexString:(NSString *)stringToConvert;

@property (weak,nonatomic)UIImage *screenshotdraw1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageToolbar1;



@property UIColor* tempExtract;

@property UIColor* blackExtract;
@property UIColor* blueExtract;
@property UIColor* redExtract;
@property UIColor* lineExtract;
@property UIColor* textExtract;




@property CGFloat brush;
@property CGFloat opacity;

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;


@property CGFloat red_blue;
@property CGFloat green_blue;
@property CGFloat blue_blue;
@property CGFloat brush_blue;
@property CGFloat alpha_blue;

@property CGFloat red_pen;
@property CGFloat green_pen;
@property CGFloat blue_pen;
@property CGFloat brush_pen;
@property CGFloat alpha_pen;



@property CGFloat red_red;
@property CGFloat green_red;
@property CGFloat blue_red;
@property CGFloat brush_red;
@property CGFloat alpha_red;


@property CGFloat red_line;
@property CGFloat green_line;
@property CGFloat blue_line;
@property CGFloat brush_line;
@property CGFloat alpha_line;

@property CGFloat red_eraser;
@property CGFloat green_eraser;
@property CGFloat blue_eraser;


@property CGFloat redtemp1;
@property CGFloat greentemp1;
@property CGFloat bluetemp1;
@property CGFloat redtemp2;
@property CGFloat greentemp2;
@property CGFloat bluetemp2;

@property CGFloat redtemp3;
@property CGFloat greentemp3;
@property CGFloat bluetemp3;

@property CGFloat redtemp4;
@property CGFloat greentemp4;
@property CGFloat bluetemp4;


@property CGFloat alpha;
@property CGFloat redconv;
@property CGFloat greenconv;
@property CGFloat blueconv;
@property CGFloat alphaconv;

@property (weak, nonatomic) NSString *stringFromVC;


@property CGFloat brush_eraser;
- (IBAction)setColorButtonTapped:(id)sender;





@end

