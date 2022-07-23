
#import <UIKit/UIKit.h>
#import "EntryViewController.h"
#import "WEPopoverController.h"
#import "ColorViewController.h"
#import "AMPopTip.h"

#import "ACEDrawingView.h"

@protocol DrawViewControllerRightDelegate;
@protocol EntryViewControllerDelegate;

@protocol DrawViewControllerRightDelegate <NSObject>

-(void) passItemBackFromRight:(DrawViewControllerRight *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5;
@end

 @interface DrawViewControllerRight : UIViewController<WEPopoverControllerDelegate, UIPopoverControllerDelegate, ColorViewControllerDelegate>{
     UIActionSheet *actionSheet2;
     CGPoint tempfirst;
     CGPoint tempmid;
     CGPoint tempend;
    ////////////////////
     CGMutablePathRef *path;
     UIColor *brushPattern;
     NSMutableArray *pathArray;
     NSMutableArray *bufferArray;

     
     
     
     CGFloat redtemp5;
     CGFloat greentemp5;
     CGFloat bluetemp5;
     CGFloat alphatemp5;
     ///////////////
    CGPoint lastPoint;
    CGPoint firstPoint;
     CGPoint lastMovePoint;
     CGPoint previousPoint1;
     CGPoint  previousPoint2;
     CGPoint currentPoint;
     
        
     CGFloat red;
     CGFloat green;
     CGFloat blue;
     
     CGFloat red_pen;
     CGFloat green_pen;
     CGFloat blue_pen;
     CGFloat brush_pen;
     CGFloat alpha_pen;
     
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
     
     CGFloat alpha;
int dashLineCount;
     
     WEPopoverController *popoverController2;
     IBOutlet UILongPressGestureRecognizer *longpresspenbtn;

     IBOutlet UILongPressGestureRecognizer *longpressblackbtn;
     
     IBOutlet UILongPressGestureRecognizer *longpressbluebtn;
     
     IBOutlet UILongPressGestureRecognizer *longpressredbtn;
     
     IBOutlet UILongPressGestureRecognizer *longpresslinebtn;
     
 IBOutlet UIScrollView *scrollView;
     
     CGFloat brush_eraser;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    int x;
    int y;
     NSMutableString *filenamethumb2;
     NSMutableString *filenamebig2;
     UIImage *tempthumbimage;
     
     NSArray *buttons;

    
}

@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;

@property (nonatomic, strong) AMPopTip *popTipLine;
@property (nonatomic, strong) AMPopTip *popTipCurve;

@property (weak, nonatomic) IBOutlet UIButton *penbtn;
@property (weak, nonatomic) IBOutlet UILabel * colorBar5;
@property UIColor* penExtract;

@property (weak, nonatomic) IBOutlet UIView *viewForImg;


//@property (nonatomic,assign) IBOutlet UIButton *btn;
-(IBAction)buttonTouched:(id)sender;
@property (nonatomic,retain) UIPopoverController *listPopoverdraw1;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *popoverBtn1;
- (IBAction)setColorButtonTapped:(id)sender;

@property (weak,nonatomic)UIImage *screenshotdraw1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imageToolbar1;

@property (nonatomic, weak) IBOutlet ACEDrawingView *drawingView;
@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property (nonatomic, weak) IBOutlet UIImageView *NewImageView;

@property (weak, nonatomic) IBOutlet UIButton *undoBut;

@property (weak, nonatomic) IBOutlet UIButton *redoBut;


@property (nonatomic,assign) IBOutlet UIButton *btn;




-(IBAction)buttonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel * colorBar1;
@property (weak, nonatomic) IBOutlet UILabel * colorBar2;
@property (weak, nonatomic) IBOutlet UILabel * colorBar3;
@property (weak, nonatomic) IBOutlet UILabel * colorBar4;
@property (weak,nonatomic) IBOutlet UIImageView * toolbarImg;

@property (nonatomic, strong) WEPopoverController *popoverController2;



@property (weak,nonatomic)UIImage *imagethumb1;
@property (weak,nonatomic)UIImage *imagethumb2;
@property (weak,nonatomic)UIImage *imagethumb3;
@property (weak,nonatomic)UIImage *imagethumb4;
@property (weak,nonatomic)UIImage *imagethumb5;

@property (weak,nonatomic)UIImage *imagebig2;
@property (weak,nonatomic) UIImage *myImage;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *baritem;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *popoverBtn1;

@property (weak, nonatomic) id<DrawViewControllerRightDelegate>drawcontrollerRightdelegate;

@property (weak, nonatomic)NSString *stringForLabel;

@property (weak, nonatomic) IBOutlet UIImageView *loadImg;

@property (weak, nonatomic) IBOutlet UIImageView *middleImg;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIButton *blackbtn;

@property (weak, nonatomic) IBOutlet UIButton *bluebtn;
@property (weak, nonatomic) IBOutlet UIButton *redbtn;
@property (retain, nonatomic) IBOutlet UILabel *labelDrawController;
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
@property (weak, nonatomic) IBOutlet UIButton *textbtn;



- (IBAction)UndoButton:(id)sender;

- (IBAction)RedoButton:(id)sender;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *eraserbtn;


@property CGFloat brush;
@property CGFloat opacity;
@property CGFloat brush_eraser;

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;


@property CGFloat red_blue;
@property CGFloat green_blue;
@property CGFloat blue_blue;
@property CGFloat brush_blue;
@property CGFloat alpha_blue;


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

@property CGFloat red_pen;
@property CGFloat green_pen;
@property CGFloat blue_pen;
@property CGFloat brush_pen;
@property CGFloat alpha_pen;


@property UIColor* tempExtract;

@property UIColor* blackExtract;
@property UIColor* blueExtract;
@property UIColor* redExtract;
@property UIColor* lineExtract;

//@property int currenttag;

/*- (IBAction)closeSettings:(id)sender;
- (IBAction)sliderChanged:(id)sender;*/
- (IBAction)textaText:(id)sender;
@property (weak, nonatomic) NSString *stringFromVC;


@end

