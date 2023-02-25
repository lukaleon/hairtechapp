//
//  ViewController+NewDrawController.h
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ViewController.h"
#import "ACEDrawingView.h"
#import "WEPopoverController.h"
#import "ColorViewController.h"
#import "AMPopTip.h"
#import "NewEntryController.h"
#import "ColorWheelController.h"
#import "ColorViewNew.h"
#import "OverlayTransitioningDelegate.h"


NS_ASSUME_NONNULL_BEGIN
@class NewDrawController;
@protocol NewDrawControllerDelegate<NSObject>
-(void)imageForButton:(UIImage*)imageForButton;
-(void)passItemBackLeft:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing;
-(void)passItemBackRight:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing;
-(void)passItemBackTop:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing;
-(void)passItemBackFront:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing;
-(void)passItemBackBack:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing;;

@end

@interface NewDrawController : UIViewController<WEPopoverControllerDelegate, UIPopoverControllerDelegate,ACEDrawingViewDelegate ,ColorViewControllerDelegate,ColorWheelControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, ColorViewNewdelegate>
{
    
    ColorViewController *contentTextView;
    ColorViewController *toolsColorPicker;

    ColorViewController *contentViewController;
    IBOutlet UILongPressGestureRecognizer *longpressPenTool;
    IBOutlet UILongPressGestureRecognizer *longpressCurveTool;
    IBOutlet UILongPressGestureRecognizer *longpressDashTool;
    IBOutlet UILongPressGestureRecognizer *longpressArrowTool;
    IBOutlet UILongPressGestureRecognizer *longpressLineTool;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray * arrayOfGrids;
    UIButton * grid;
    UIButton * magnet;
    NSArray * toolButtons;
    UIColor * penColor;
    UIColor * curveColor;
    UIColor * dashColor;
    UIColor * arrowColor;
    UIColor * lineColor;
    UIColor * textColor;
    UIColor * dotColor;
    UIColor * clipperColor;
    UIColor * razorColor;
    BOOL curveToggleIsOn;
    BOOL textSelected;
    BOOL textSetterState;
    UIColor * currentColor;
    NSMutableArray * arrayOfColorPickers;
    UIButton *more;
}

@property (nonatomic, strong) OverlayTransitioningDelegate* overlayDelegate;

@property (nonatomic, assign) NSString * techniqueName;
@property (nonatomic, assign) NSString * labelText;
@property (nonatomic, assign) NSString * headtype;
@property (nonatomic, assign) NSString * jsonType;

@property (nonatomic, assign) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet ACEDrawingView *drawingView;
// UIButtons
@property (weak, nonatomic) IBOutlet UIImageView *toolbar;

@property (weak, nonatomic) IBOutlet UIButton *penTool;
@property (weak, nonatomic) IBOutlet UIButton *curveTool;
@property (weak, nonatomic) IBOutlet UIButton *dashTool;
@property (weak, nonatomic) IBOutlet UIButton *arrowTool;
@property (weak, nonatomic) IBOutlet UIButton *lineTool;
@property (weak, nonatomic) IBOutlet UIButton *eraserTool;
@property (weak, nonatomic) IBOutlet UIButton *textTool;
@property CGFloat fontSizeVC;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
@property (strong, nonatomic)  IBOutlet UIView * toolbarNotification;
@property (strong, nonatomic) IBOutlet UILabel * infoLabel;
@property (strong, nonatomic) IBOutlet UIButton * okButton;

@property (strong, nonatomic) NSTimer *touchTimer;
@property (nonatomic, strong) AMPopTip *popTipLine;
@property (nonatomic, strong) AMPopTip *popTipCurve;
@property (nonatomic, strong) AMPopTip *magnetTip;

@property (nonatomic, strong) WEPopoverController *popoverController;
@property (weak, nonatomic) id<NewDrawControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
