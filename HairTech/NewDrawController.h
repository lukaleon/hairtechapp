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


NS_ASSUME_NONNULL_BEGIN

@interface NewDrawController : UIViewController<WEPopoverControllerDelegate, UIPopoverControllerDelegate,ACEDrawingViewDelegate ,ColorViewControllerDelegate , UIScrollViewDelegate, UITextViewDelegate>
{
    ColorViewController *contentTextView;
    ColorViewController *contentViewController;
    IBOutlet UILongPressGestureRecognizer *longpressPenTool;
    IBOutlet UILongPressGestureRecognizer *longpressCurveTool;
    IBOutlet UILongPressGestureRecognizer *longpressDashTool;
    IBOutlet UILongPressGestureRecognizer *longpressArrowTool;
    IBOutlet UILongPressGestureRecognizer *longpressLineTool;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray * arrayOfGrids;
    UIButton * grid;
    NSArray * toolButtons;
    UIColor * penColor;
    UIColor * curveColor;
    UIColor * dashColor;
    UIColor * arrowColor;
    UIColor * lineColor;
    UIColor * textColor;
    BOOL curveToggleIsOn;
    BOOL textSelected;
    BOOL textSetterState;


}
@property (nonatomic, assign) NSString * labelText;
@property (nonatomic, assign) NSString * imgName;
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

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;


@property (nonatomic, strong) AMPopTip *popTipLine;
@property (nonatomic, strong) AMPopTip *popTipCurve;
@property (nonatomic, strong) WEPopoverController *popoverController;

@property CGFloat fontSizeVC;


@end

NS_ASSUME_NONNULL_END