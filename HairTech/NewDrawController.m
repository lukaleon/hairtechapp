//
//  ViewController+NewDrawController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewDrawController.h"
#import "TemporaryDictionary.h"
#import "ColorWheelController.h"
#import "ColorViewNew.h"
#import "OverlayTransitioningDelegate.h"


#define btnColor  [UIColor colorNamed:@"cellText"]
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NewDrawController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.drawingView.drawingLayerSelectedBlock = ^(BOOL isSelected){
        };
    
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    textSelected = NO; // UITextView from drawing view is not selected
    arrayOfGrids = [NSMutableArray array];
    [self setupScrollView];
    [self setupDrawingView];
    [self LoadColorsAtStart];
    [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
    self.drawingView.viewControllerName = @"left";
    [self setupNavigationBarItems];
    [self.img setImage:[UIImage imageNamed:self.headtype]];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
 
    [self registerNotifications];
  
    /* Setup toolBar and toolButoons */
    toolButtons = @[self.penTool, self.curveTool, self.dashTool, self.arrowTool,self.lineTool,self.eraserTool,self.textTool];
    [self setupBottomToolBar];
    [self setupToolButtonsAppearance];
    self.lineTool.selected = YES;
    self.lineTool.backgroundColor = lineColor;
    self.drawingView.type = JVDrawingTypeLine;
    self.drawingView.bufferType = JVDrawingTypeLine;
    self.drawingView.previousType = self.lineTool;
    self.drawingView.lineColor = lineColor;
    self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
   
    /*setup Pop Tip */
    [self setupPopTips];
    [self setupLongPressGestures];

    /* */
    textSelected = NO;
    self.fontSizeVC = 15;
    if([self loadGridAppearanceToDefaults]){
        [self performSelector:@selector(showOrHideGrid)];
    }
    if([self loadMagnetStateToDefaults]){
        [magnet setTintColor:[UIColor colorNamed:@"orange"]];
        [self.drawingView setMagnetActivated:YES];
    }
    else {
        [magnet setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
        [self.drawingView setMagnetActivated:NO];
    }
    
    
  
   
    
    }

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [self saveColorsToDefaults];
    [self removeGrid];
    [self.drawingView removeCircles]; //remove control circles when selected
    [self.drawingView removeTextViewFrame]; //create text layer when closing window
    [self screentShot:self.headtype];
    [self clearPageForClosing];
    
    [self saveDiagramToFile:self.techniqueName];
}

- (void)setupScrollView {
    CGRect newFrame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 170);
    scrollView.frame = newFrame;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 6.0;
    scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
}
- (void)setupDrawingView {
    CGFloat newHeightIdx = (self.view.frame.size.height - self.drawingView.frame.size.height) / 4;
    CGPoint newCenter = CGPointMake(self.view.center.x, scrollView.center.y - newHeightIdx);
    CGFloat zoomIdx = self.view.frame.size.height / self.drawingView.frame.size.height;
    self.drawingView.center = newCenter;
    self.drawingView.delegate = self;
    self.drawingView.editMode = NO;
    self.drawingView.editModeforText = NO;
    self.drawingView.touchForText = 0;
     
    NSLog(@"%@ json type", self.techniqueName);
    
    //[self.drawingView loadJSONData:[self loadDictionaryFromPathWithKey:self.jsonType error:nil]];
    [self.drawingView loadJSONData:[self openDictAtPath:self.techniqueName key:self.jsonType error:nil]];
   // [self.drawingView loadJSONData:[self openFileNameJSON:self.techniqueName headtype:self.headtype]];
    if(UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
    [scrollView setZoomScale:1.7 animated:YES];
    }
}

//-(NSDictionary*)loadDictionaryFromPathWithKey:(NSString*)key error:(NSError **)outError {
//
//    NSDictionary * tempDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"temporaryDictionary"];
//    return [tempDict objectForKey:key];
//
//}
-(NSData*)openDictAtPath:(NSString*)fileName key:(NSString*)key error:(NSError **)outError {
    
//    fileName = [fileName stringByAppendingFormat:@"%@",@".htapp"];
//    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//    NSString *docDirectory = [sysPaths objectAtIndex:0];
//    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
//
//    NSURL * url = [NSURL fileURLWithPath:filePath];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//
//    NSDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    NSDictionary * tempDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"temporaryDictionary"];
    NSData * jsonData = [tempDict objectForKey:key];
    
    [self.drawingView setJsonData: [tempDict objectForKey:key]];
    [self.drawingView setJsonKey:key];
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[tempDict objectForKey:key]
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:outError];
    return jsonData;
    
}

-(NSMutableString *)openFileNameJSON:(NSString*)fileName headtype:(NSString*)type{
    NSMutableString * newString = [fileName mutableCopy];
    newString = [newString mutableCopy];
    [newString appendString:type];
    newString = [newString mutableCopy];
    [newString appendString:@".json"];
    NSLog(@"filename %@", newString);
    return newString;
}

- (void)setupLongPressGestures {
    longpressCurveTool = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCurveTool:)];
    longpressCurveTool .minimumPressDuration = 0.2;
    [self.curveTool addGestureRecognizer:longpressCurveTool];
    
    longpressDashTool = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDashTool:)];
    longpressDashTool .minimumPressDuration = 0.2;
    [self.dashTool addGestureRecognizer:longpressDashTool];
    
    longpressArrowTool = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressArrowTool:)];
    longpressArrowTool .minimumPressDuration = 0.2;
    [self.arrowTool addGestureRecognizer:longpressArrowTool];
    
    longpressLineTool = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressLineTool:)];
    longpressLineTool .minimumPressDuration = 0.2;
    [self.lineTool addGestureRecognizer:longpressLineTool];
    
    longpressPenTool = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPenTool:)];
    longpressPenTool .minimumPressDuration = 0.2;
    [self.penTool addGestureRecognizer:longpressPenTool];
}
- (void)setupPopTips {
    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    self.popTipCurve = [AMPopTip popTip];
    self.popTipCurve.shouldDismissOnTap = YES;
    self.popTipCurve.edgeMargin = 5;
    self.popTipCurve.offset = 2;
    self.popTipCurve.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.popTipCurve.shouldDismissOnTap = YES;
    
    self.popTipLine = [AMPopTip popTip];
    self.popTipLine.shouldDismissOnTap = YES;
    self.popTipLine.edgeMargin = 5;
    self.popTipLine.offset = 2;
    self.popTipLine.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.popTipLine.shouldDismissOnTap = YES;
  
    self.magnetTip = [AMPopTip popTip];
    self.magnetTip.shouldDismissOnTap = YES;
    self.magnetTip.edgeMargin = 5;
    self.magnetTip.offset = 2;
    self.magnetTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.magnetTip.shouldDismissOnTap = YES;

    
    self.magnetTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
        
        [self.magnetTip showText:@"Long press to change color" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:magnet.frame];
        
        
    };
    
}


- (void)setupBottomToolBar {
   self.toolbar.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + self.view.frame.size.height - 80, self.view.frame.size.width - 20, 55);
    self.toolbar.alpha = 1.0f;
    [self.toolbar setBackgroundColor:[UIColor colorNamed:@"whiteDark"]];
    [self.toolbar.layer setCornerRadius:15.0f];
    [super viewDidLoad];
    self.toolbar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolbar.layer.shadowOffset = CGSizeMake(0,0);
    self.toolbar.layer.shadowRadius = 8.0f;
    self.toolbar.layer.shadowOpacity = 0.2f;
    self.toolbar.layer.masksToBounds = NO;
    self.toolbar.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.toolbar.bounds cornerRadius:self.toolbar.layer.cornerRadius].CGPath;
}

-(void)setupToolButtonsAppearance{
    for(int i=0; i< toolButtons.count; i++) {
        if(![[toolButtons objectAtIndex:i] isSelected]){
            UIButton *btn = [toolButtons objectAtIndex:i];
            btn.backgroundColor = btnColor;
            btn.layer.cornerRadius = 12.0;
        }
    }
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
   // [self.drawingView updateZoomFactor:scrollView.zoomScale];
    }

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if ( IDIOM == IPAD){
//        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
//    } else {
//        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.65, 0.0);
//        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.30, 0.0);
//        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
//    }
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageViewFrame = self.drawingView.frame ;

    // centre horizontally
    if (imageViewFrame.size.width < boundsSize.width) {
        imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2;
    } else {
        imageViewFrame.origin.x = 0;
    }

    // centre vertically
    if (imageViewFrame.size.height < boundsSize.height && self.drawingView) {
        imageViewFrame.origin.y = (boundsSize.height - imageViewFrame.size.height) / 2;
    } else {
        imageViewFrame.origin.y = 0;
    }
    self.drawingView.frame = imageViewFrame;

}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.drawingView updateZoomFactor:scrollView.zoomScale];
    NSLog(@"zoom scale %f", scrollView.zoomScale);
//    if ( IDIOM == IPAD){
//        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
//    } else {
//        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.65, 0.0);
//        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.30, 0.0);
//        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
//    }
//
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageViewFrame = self.drawingView.frame ;

    // centre horizontally
    if (imageViewFrame.size.width < boundsSize.width) {
        imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2;
    } else {
        imageViewFrame.origin.x = 0;
    }

    // centre vertically
    if (imageViewFrame.size.height < boundsSize.height && self.drawingView) {
        imageViewFrame.origin.y = (boundsSize.height - imageViewFrame.size.height) / 2;
    } else {
        imageViewFrame.origin.y = 0;
    }
    self.drawingView.frame = imageViewFrame;


}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.drawingView;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveColorsToDefaults) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShotNotification) name:@"didEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShotNotification) name:@"appDidTerminate" object:nil];
}


#pragma mark NAvigation Bar And Share Setup

- (void)setupNavigationBarItems {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
   
    
    grid = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [grid addTarget:self
             action:@selector(showOrHideGrid)
   forControlEvents:UIControlEventTouchUpInside];
    [grid.widthAnchor constraintEqualToConstant:30].active = YES;
    [grid.heightAnchor constraintEqualToConstant:30].active = YES;
    [grid setImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
    //[grid setImage:[UIImage imageNamed:@"grid_sel"] forState:UIControlStateSelected];
    [grid setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    magnet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [magnet addTarget:self
             action:@selector(activateDisableMagnet)
   forControlEvents:UIControlEventTouchUpInside];
    [magnet.widthAnchor constraintEqualToConstant:30].active = YES;
    [magnet.heightAnchor constraintEqualToConstant:30].active = YES;
    [magnet setImage:[UIImage imageNamed:@"angle"] forState:UIControlStateNormal];
    [magnet setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    
    UIButton *undo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [undo addTarget:self
             action:@selector(undoPressed)
   forControlEvents:UIControlEventTouchUpInside];
    [undo.widthAnchor constraintEqualToConstant:30].active = YES;
    [undo.heightAnchor constraintEqualToConstant:30].active = YES;
    [undo setImage:[UIImage imageNamed:@"undoNew.png"] forState:UIControlStateNormal];
    [undo setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    UIButton * redo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [redo addTarget:self
             action:@selector(redoPressed)
   forControlEvents:UIControlEventTouchUpInside];
    [redo.widthAnchor constraintEqualToConstant:30].active = YES;
    [redo.heightAnchor constraintEqualToConstant:30].active = YES;
    [redo setImage:[UIImage imageNamed:@"redoNew.png"] forState:UIControlStateNormal];
    [redo setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [more addTarget:self
             action:@selector(presentAlertView)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    [more setImage:[UIImage imageNamed:@"dots.png"] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];

    UIBarButtonItem * magnetBtn =[[UIBarButtonItem alloc] initWithCustomView:magnet];
    UIBarButtonItem * gridBtn =[[UIBarButtonItem alloc] initWithCustomView:grid];
    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
    UIBarButtonItem * undoBtn = [[UIBarButtonItem alloc]initWithCustomView:undo];
    UIBarButtonItem * redoBtn = [[UIBarButtonItem alloc]initWithCustomView:redo];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBtn, redoBtn, undoBtn, gridBtn,magnetBtn, nil];
    [self updateButtonStatus];

}

-(void)presentAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Presenting the great... StackOverFlow!"];
//    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(24, 11)];
//    [alertVC setValue:hogan forKey:@"attributedTitle"];
    
    
    UIAlertAction *showPalette = [UIAlertAction actionWithTitle:@"Color palette"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   [self changeColorPalette];
                                                   }];
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"Share"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   [self share];
                                                   }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Clear Page"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action){
                                                    [self showConfirmationAlertForClear];
                                                   }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                       //add code to make something happen once tapped
                                                   }];
  //  [button2 setValue:[[UIImage systemImageNamed:@"trash"]
                     //  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
   // [button setValue:[[UIImage systemImageNamed:@"tray.and.arrow.up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
    [alertVC addAction:showPalette];
    [alertVC addAction:button];
    [alertVC addAction:button2];
    [alertVC addAction:button3];
    
    UIBarButtonItem *item = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
        UIView *view = [item valueForKey:@"view"];
    if(view){
        [[alertVC popoverPresentationController] setSourceView:view];
        [[alertVC popoverPresentationController] setSourceRect:view.frame];
        [[alertVC popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];
        [self presentViewController:alertVC animated:true completion:nil];
    }
}
-(void)showConfirmationAlertForClear
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
  
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Clear Page"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action){
                                                    [self clearPage];
                                                   }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                       //add code to make something happen once tapped
                                                   }];
  //  [button2 setValue:[[UIImage systemImageNamed:@"trash"]
                     //  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
   // [button setValue:[[UIImage systemImageNamed:@"tray.and.arrow.up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
    [alertVC addAction:button2];
    [alertVC addAction:button3];
    
    UIBarButtonItem *item = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
        UIView *view = [item valueForKey:@"view"];
    if(view){
        [[alertVC popoverPresentationController] setSourceView:view];
        [[alertVC popoverPresentationController] setSourceRect:view.frame];
        [[alertVC popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];
        [self presentViewController:alertVC animated:true completion:nil];
    }
    
}

-(void)changeColorPalette{
    
//    NSLog(@"Show color wheel");
//   ColorWheelController *colorWheel = [self.storyboard instantiateViewControllerWithIdentifier:@"colorWheel"];
//    colorWheel.delegate = self;
//
////    colorWheel.startColor = currentColor;
//    colorWheel.modalPresentationStyle = UIModalPresentationPageSheet;
//    [self presentViewController:colorWheel animated:YES completion:nil];
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        ColorWheelController *colorWheel = [self.storyboard instantiateViewControllerWithIdentifier:@"colorWheel"];
        colorWheel.delegate = self;
        colorWheel.isIpad  = YES;
        //colorWheel.startColor = currentColor;
        colorWheel.modalPresentationStyle = UIModalPresentationPageSheet;
        colorWheel.preferredContentSize = CGSizeMake(300, 400);
        [self presentViewController:colorWheel animated:YES completion:nil];
    }
    else{
   
        ColorWheelController *controller = [[ColorWheelController alloc]init];
        [self prepareOverlay:controller];
        controller.isIpad  = NO;
        [self presentViewController:controller animated:true completion:nil];
    }
    
}

- (void)prepareOverlay:(ColorWheelController*)viewController {
    self.overlayDelegate = [[OverlayTransitioningDelegate alloc]init];
viewController.transitioningDelegate = self.overlayDelegate;
viewController.modalPresentationStyle = UIModalPresentationCustom;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

-(void)clearPage{
    [self.drawingView removeAllDrawings];
    [self updateButtonStatus];

}
-(void)clearPageForClosing{
   // [self.drawingView removeDrawingsForClosing];
}

-(void)addGrid{
        NSLog(@"ADD GRID TO VIEW");
        int numberOfRows = self.img.bounds.size.height/12;
        int numberOfColumns = self.img.bounds.size.width/12;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.25);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
        
        // Drawing column lines

        CGFloat columnWidth = self.img.bounds.size.width / (numberOfColumns + 1.0);
        for(int i = 1; i <= numberOfColumns; i++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = columnWidth * i;
            startPoint.y = 0.0f;
            endPoint.x = startPoint.x;
            endPoint.y = self.img.bounds.size.height;
            UIBezierPath *path2 = [UIBezierPath bezierPath];
            
            [path2 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
            [path2 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
            CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
            shapeLayer2.path = [path2 CGPath];
            shapeLayer2.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
            shapeLayer2.lineWidth = 0.25;
            shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
            [self.img.layer addSublayer:shapeLayer2];
            [arrayOfGrids addObject:shapeLayer2];

        }
        // Drawing row lines
        // calclulate row height
        CGFloat rowHeight = self.img.bounds.size.height / (numberOfRows + 1.0);
        for(int j = 1; j <= numberOfRows; j++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = 0.0f;
            startPoint.y = rowHeight * j;
            endPoint.x = self.img.bounds.size.width;
            endPoint.y = startPoint.y;

        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path1 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = [path1 CGPath];
        shapeLayer1.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
        shapeLayer1.lineWidth = 0.25;
        shapeLayer1.fillColor = [[UIColor clearColor] CGColor];
        [self.img.layer addSublayer:shapeLayer1];
        [arrayOfGrids addObject:shapeLayer1];
        }
}

-(void)removeGrid{
    for (CAShapeLayer * layer in arrayOfGrids) {
        [layer performSelector:@selector(removeFromSuperlayer)];
    }
    [arrayOfGrids removeAllObjects];
}


-(void)activateDisableMagnet{
    if(![self loadMagnetStateToDefaults]){
        [magnet setTintColor:[UIColor colorNamed:@"orange"]];
        [self saveMagnetStateToDefaults:YES];
        [self.drawingView setMagnetActivated:YES];

    }
    else {
        [magnet setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
        [self saveMagnetStateToDefaults:NO];
        [self.drawingView setMagnetActivated:NO];

    }
    
}

-(void)showOrHideGrid{
    if(arrayOfGrids.count == 0){
        [grid setTintColor:[UIColor colorNamed:@"orange"]];
        [self addGrid];
        [self saveGridAppearanceToDefaults:YES];
    } else {
        [grid setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
        [self removeGrid];
        [self saveGridAppearanceToDefaults:NO];
    }
    
}

-(void)saveGridAppearanceToDefaults:(BOOL)isVisible{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:isVisible  forKey:@"grid"];
    [prefs synchronize];
}
-(BOOL)loadGridAppearanceToDefaults{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isVisible = [prefs boolForKey:@"grid"];
    [prefs synchronize];
    return  isVisible;
}

-(void)saveMagnetStateToDefaults:(BOOL)isVisible{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:isVisible  forKey:@"magnet"];
    [prefs synchronize];
}
-(BOOL)loadMagnetStateToDefaults{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isVisible = [prefs boolForKey:@"magnet"];
    [prefs synchronize];
    return  isVisible;
}


-(void)saveColorsToDefaults{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self hexFromUIColor:penColor] forKey:@"penToolColor"];
    [defaults setObject:[self hexFromUIColor:curveColor] forKey:@"curveToolColor"];
    [defaults setObject:[self hexFromUIColor:dashColor] forKey:@"dashToolColor"];
    [defaults setObject:[self hexFromUIColor:arrowColor] forKey:@"arrowToolColor"];
    [defaults setObject:[self hexFromUIColor:lineColor]forKey:@"lineToolColor"];
    [defaults setObject:[self hexFromUIColor:textColor] forKey:@"textToolColor"];
    [defaults synchronize];
}



-(void)LoadColorsAtStart
{

    
    self.fontSizeVC = 15;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    penColor = [self colorFromHex:[defaults objectForKey:@"penToolColor"]];
    curveColor = [self colorFromHex:[defaults objectForKey:@"curveToolColor"]];
    dashColor = [self colorFromHex:[defaults objectForKey:@"dashToolColor"]];
    arrowColor = [self colorFromHex:[defaults objectForKey:@"arrowToolColor"]];
    lineColor = [self colorFromHex:[defaults objectForKey:@"lineToolColor"]];
    textColor = [self colorFromHex:[defaults objectForKey:@"textToolColor"]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    float height = textView.contentSize.height;
    [UIView animateWithDuration:0.1 animations:^{

    CGRect frame = textView.frame;
    frame.size.height = height + 20;
    textView.frame = frame;
    [self.drawingView adjustRectWhenTextChanged:frame];
   
    } completion:^(BOOL finished){
    }];
    
    if ([textView.text isEqualToString:@"TEXT"]){
    [textView setSelectedTextRange:[textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.endOfDocument]];
    }

return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
    CGPoint origin = [self.drawingView.textViewNew convertPoint:CGPointMake(self.drawingView.textViewNew.frame.origin.x, self.drawingView.textViewNew.frame.origin.y)  toView:self.view.window];
    NSLog(@"pointY %f", origin.y);
    if (origin.y > 500){

        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200., self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
        }];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.view.frame.origin.y < 0){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200., self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
        }];
    }
}
- (void)textViewDidChange:(UITextView *)txtView{
    float height = txtView.contentSize.height;

    [UIView animateWithDuration:0.1 animations:^{

    CGRect frame = txtView.frame;
    frame.size.height = height + 20;
    txtView.frame = frame;
    [self.drawingView adjustRectWhenTextChanged:frame];

    } completion:^(BOOL finished){
    }];
    
 
}



//- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
//    //The popover is automatically dismissed if you click outside it, unless you return NO here
//    if (thePopoverController != self.popoverTextSettings){
//        return YES;
//    } else {
//        return  NO;
//    }
//}

#pragma mark Long Press Gestures
- (void)longPressPenTool:(UILongPressGestureRecognizer *)gestureRecognizer {
        [self saveColorsToDefaults];
        [self pencilPressed:[self.view viewWithTag:5]];
        //[self makeButtonSelected];
        //self.penTool.selected = YES;
        [longpressPenTool setDelaysTouchesBegan:YES];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            
            ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,154) isSelected:NO color:penColor currentTool:@"Pen Tool"];
            contentViewController.delegate = self;
            contentViewController.currentPenColor = self.penTool.backgroundColor;

            self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromRect:CGRectMake(self.curveTool.frame.origin.x,self.penTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            
        }
}
- (void)longPressCurveTool:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:0]];
//self.lineTool.selected = NO;
    longpressCurveTool.minimumPressDuration = 0.2;
    [longpressCurveTool setDelaysTouchesBegan:YES];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,154) isSelected:NO color:curveColor currentTool:@"Curve Lite Tool"];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = curveColor;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(self.curveTool.frame.origin.x,self.curveTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
- (void)longPressDashTool:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:1]];
    longpressDashTool .minimumPressDuration = 0.2;
    [longpressDashTool setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,154) isSelected:NO color:dashColor currentTool:@"Dashed Line Tool"];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = dashColor;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;

        [self.popoverController presentPopoverFromRect:CGRectMake(self.dashTool.frame.origin.x,self.dashTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
- (void)longPressArrowTool:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:2]];
    longpressArrowTool .minimumPressDuration = 0.2;
    [longpressArrowTool setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,154) isSelected:NO color:arrowColor currentTool:@"Arrow Line"];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = arrowColor;
   

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(self.arrowTool.frame.origin.x,self.arrowTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)longPressLineTool:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:3]];
    if(self.popTipLine){
        [self.popTipLine hide];
    }
    longpressLineTool .minimumPressDuration = 0.2;
    [longpressLineTool setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,154) isSelected:NO color:lineColor currentTool:@"Line Tool"];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = lineColor;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(self.lineTool.frame.origin.x,self.lineTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
#pragma mark Color Extraction



- (UIColor *)colorFromHex:(NSString *)hex {
    
    
    unsigned rgbValue = 0;
       NSScanner *scanner = [NSScanner scannerWithString:hex];
       [scanner setScanLocation:1]; // bypass '#' character
       [scanner scanHexInt:&rgbValue];
       return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (NSString *)hexFromUIColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

-(void)preferredContentSizeDidChangeForChildContentContainer:(id <UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    [self setPreferredContentSize:container.preferredContentSize];
}

-(void)colorPopoverControllerDidSelectColor:(NSString *)hexColor {
    if(self.penTool.selected == YES){
//        [self extractRGBforPen:[GzColors colorFromHex:hexColor]];
        penColor = [self colorFromHex:hexColor];
        self.drawingView.drawTool = ACEDrawingToolTypePen;
        self.drawingView.lineColor = penColor;
        self.penTool.backgroundColor = penColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        [self saveColorsToDefaults];

    }
    
    
    if(self.curveTool.selected == YES){
        curveColor =  [self colorFromHex:hexColor];
        self.drawingView.drawTool = ACEDrawingToolTypeCurve;
        self.curveTool.backgroundColor = curveColor;
        self.drawingView.lineColor = curveColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
    }
    
    if (self.dashTool.selected == YES){
        dashColor = [self colorFromHex:hexColor];
        [self deselectInactioveButtons];
        self.drawingView.drawTool = ACEDrawingToolTypeDashLine;
        self.drawingView.lineColor = dashColor;
         self.dashTool.backgroundColor = dashColor;
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
    }
    
    if(self.arrowTool.selected == YES){
        arrowColor = [self colorFromHex:hexColor];
        self.drawingView.drawTool = ACEDrawingToolTypeArrow;
        self.drawingView.lineColor = arrowColor;
        self.arrowTool.backgroundColor = arrowColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
    }
    if(self.lineTool.selected == YES){
        lineColor = [self colorFromHex:hexColor];
        self.drawingView.drawTool = ACEDrawingToolTypeLine;
        self.drawingView.lineColor = lineColor;
         self.lineTool.backgroundColor = lineColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    popoverController = nil;
    [self.penTool addGestureRecognizer:longpressPenTool];
    [self.curveTool addGestureRecognizer:longpressCurveTool];
    [self.dashTool addGestureRecognizer:longpressDashTool];
    [self.arrowTool addGestureRecognizer:longpressArrowTool];
    [self.lineTool addGestureRecognizer:longpressLineTool];
    
}
-(void) sliderDidSelectWidth:(CGFloat)lineWidth {
    
    self.drawingView.lineWidth = lineWidth;
}


#pragma mark Drawing Methods

-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}

-(void)saveCurrentToolToUserDeafaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float)loadCurrentToolFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}
-(void)selectPreviousTool:(id)sender{
    textSelected = NO;
    [self pencilPressed:sender];
}
- (void)selectTextTool:(id)sender passColor:(UIColor*)color {
    curveToggleIsOn = nil;
   // dashLineCount = 0;
    [self makeButtonDeselected];
    self.textTool.selected = YES;
    self.drawingView.eraserSelected = NO;
    
    [self.drawingView enableGestures];
    self.drawingView.type = JVDrawingTypeText;
    self.drawingView.bufferType = JVDrawingTypeText;
    self.drawingView.lineColor = textColor;
    self.drawingView.textTypesSender = sender;
    self.drawingView.textViewNew.delegate = self;
    [self showTextColorsAndSize:color];
    
}
-(void)selectTextTool:(id)sender textColor:(UIColor*)color fontSize:(CGFloat)fontSz isSelected:(BOOL)isSelected{
    [self selectTextTool:sender passColor:color];
    textSelected = isSelected;
    contentTextView.fontSizee = fontSz;
    self.drawingView.textViewFontSize = fontSz;
    [contentTextView setFontSizee:fontSz];
    [contentViewController setCurrentTextColorForIndicator:color];
}
-(void)addTextFromTextSettings{
    NSLog(@"add text");
    textSelected = NO;
    [self pencilPressed:[self.view viewWithTag:4]];
}

- (IBAction)pencilPressed:(id)sender {
    
    [self.popTipLine hide];
    [self.popTipCurve hide];
    UIButton * PressedButton = (UIButton*)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch(PressedButton.tag)
    {
        case 0:
            [self makeButtonDeselected];
            self.curveTool.selected = YES;
            self.curveTool.backgroundColor = curveColor; //blackExtract
            [self.drawingView setEraserSelected:NO];
            
            [self saveCurrentToolToUserDeafaults:0.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            if(curveToggleIsOn){
                [self.drawingView disableGestures];
                self.drawingView.type = JVDrawingTypeCurvedDashLine;
                self.drawingView.bufferType = JVDrawingTypeCurvedDashLine;
                self.drawingView.previousType = sender;
                self.drawingView.lineColor = curveColor;
                appDelegate.dashedCurve = YES;
                [self.drawingView removeCirclesOnZoomDelegate];
            }
            else{
                [self.drawingView disableGestures];
                self.drawingView.type = JVDrawingTypeCurvedLine;
                self.drawingView.bufferType = JVDrawingTypeCurvedLine;
                self.drawingView.previousType = sender;
                self.drawingView.lineColor = curveColor;
                appDelegate.dashedCurve = NO;
                [self.drawingView removeCirclesOnZoomDelegate];
            }
            curveToggleIsOn = !curveToggleIsOn;
            [self.curveTool setImage:[UIImage imageNamed:curveToggleIsOn ? @"curveNew.png" :@"curveDashNew.png"] forState:UIControlStateSelected];
            
            
            break;
        case 1:
            curveToggleIsOn = nil;
            [self makeButtonDeselected];
            self.dashTool.selected = YES;
            //dashLineCount = 0;
            [self.drawingView setEraserSelected:NO];
            self.dashTool.backgroundColor = dashColor;
        
            [self.drawingView disableGestures];
            self.drawingView.type = JVDrawingTypeDashedLine;
            self.drawingView.bufferType = JVDrawingTypeDashedLine;
            self.drawingView.previousType = sender;
            self.drawingView.lineColor = dashColor;
            [self saveCurrentToolToUserDeafaults:1.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
       case 2:
            curveToggleIsOn = nil;
            //dashLineCount = 0;
            [self makeButtonDeselected];
            self.arrowTool.selected = YES;
            self.arrowTool.backgroundColor = arrowColor;
            [self.drawingView setEraserSelected:NO];
            self.drawingView.lineColor = arrowColor;
            
            [self.drawingView disableGestures];
            self.drawingView.type = JVDrawingTypeArrow;
            self.drawingView.bufferType = JVDrawingTypeArrow;
            self.drawingView.previousType = sender;
            [self saveCurrentToolToUserDeafaults:2.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
        case 3:
            [self makeButtonDeselected];
            curveToggleIsOn = nil;
            //dashLineCount = 0;
            self.lineTool.selected = YES;
            [self.drawingView setEraserSelected:NO];
            self.lineTool.backgroundColor = lineColor;
            
            [self.drawingView disableGestures];
            self.drawingView.type = JVDrawingTypeLine;
            self.drawingView.bufferType = JVDrawingTypeLine;
            self.drawingView.previousType = sender;
            self.drawingView.lineColor = lineColor;
            [self saveCurrentToolToUserDeafaults:3.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
        case 4:
           [self.drawingView removeCircles];
            curveToggleIsOn = nil;
            [self makeButtonDeselected];
            self.textTool.selected = YES;
            [self.drawingView setEraserSelected:NO];
            [self.drawingView enableGestures];
            self.drawingView.type = JVDrawingTypeText;
            self.drawingView.bufferType = JVDrawingTypeText;
            self.drawingView.lineColor = textColor;
            self.drawingView.textTypesSender = sender; //Should be saved to user defaults
            
            CGRect gripFrame = CGRectMake(0, 0, 70, 38);
            if (!textSelected){
                [self.drawingView addFrameForTextView:gripFrame centerPoint:self.img.center text:@"TEXT" color:textColor font:self.fontSizeVC];
                [contentTextView setFontSizee:self.fontSizeVC];
                self.drawingView.textViewFontSize = self.fontSizeVC;
            }
            self.drawingView.textViewNew.delegate = self;
            if (contentTextView == nil){
                [self showTextColorsAndSize:textColor]; //??????????? atttention
                [contentTextView setFontSizee:self.fontSizeVC];
            }
            
          //  [self.drawingView addDotToView];
            break;
       case 5:
            curveToggleIsOn = nil;
            //dashLineCount = 0;
            [self makeButtonDeselected];
            self.penTool.selected = YES;
            [self.drawingView setEraserSelected:NO];
            self.penTool.backgroundColor = penColor;
            [self.drawingView disableGestures];
            self.drawingView.type = JVDrawingTypeGraffiti;
            self.drawingView.bufferType = JVDrawingTypeGraffiti;
            self.drawingView.previousType = sender;
            self.drawingView.lineColor = penColor;
            [self saveCurrentToolToUserDeafaults:5.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    
    [self saveFloatToUserDefaults:1.0 forKey:@"eraserPressed"];
    
    //dashLineCount = 0;
    [self makeButtonDeselected];
    self.eraserTool.selected = YES;
    [self.drawingView setEraserSelected:YES];
    [self.drawingView removeCirclesOnZoomDelegate];
    self.eraserTool.backgroundColor = [UIColor colorNamed:@"orange"];
}
-(void)makeButtonDeselected {
        for(int i=0; i< toolButtons.count; i++){
            UIButton *btn = [toolButtons objectAtIndex:i];
            btn.selected = NO;
            btn.backgroundColor = btnColor;
        }
    }
-(void)deselectInactioveButtons {
    for(int i=0; i< toolButtons.count; i++) {
        
        if(![[toolButtons objectAtIndex:i] isSelected]){
            UIButton *btn = [toolButtons objectAtIndex:i];
            btn.backgroundColor = btnColor;
        }
    }
}
#pragma mark TextView Operations
-(void)removeTextSettings{
    NSLog(@"remove text settings");
    [contentTextView removeFromSuperview];
    contentTextView = nil;
}

-(void)showTextColorsAndSize:(UIColor*)color{
    contentTextView = [[ColorViewController alloc] initWithFrame:self.toolbar.bounds isSelected:YES color:color currentTool:@"Text Tool"];
    contentTextView.center = self.toolbar.center;
    //contentTextView.currentPenColor = color;
    textSetterState = YES;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
}

- (void)colorPopoverDidSelectTextColor:(NSString *)hexColor{
    NSLog(@"selected color for text");
    textColor = [self colorFromHex:hexColor];
    self.drawingView.lineColor = textColor;
    self.textTool.backgroundColor = textColor;
    self.drawingView.textViewNew.textColor = textColor;
}

- (void)textSettingsDidSelectFontSize:(CGFloat)fontSize
{
    self.drawingView.textViewFontSize = fontSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = -0.20;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrsDictionary =
    @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:fontSize],
     NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName : self.drawingView.textViewNew.textColor};
    self.drawingView.textViewNew.attributedText = [[NSAttributedString alloc] initWithString:self.drawingView.textViewNew.text attributes:attrsDictionary];
    [self textViewDidChange:self.drawingView.textViewNew];
    }
-(void)disableZoomWhenTouchesMoved{
    scrollView.pinchGestureRecognizer.enabled = NO;    
}
-(void)enableZoomWhenTouchesMoved{
    scrollView.pinchGestureRecognizer.enabled = YES;
}


-(void)storeImageInTempDictionary:(NSData*)imgData{
    NSMutableDictionary* tempDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    [tempDict setObject:imgData forKey:self.headtype];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (UIImage *)getImageOfScreen:(NSString*)headtype {
    self.drawingView.backgroundColor = [UIColor clearColor];

    UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, NO, [UIScreen mainScreen].scale);
    // [self drawViewHierarchyInRect:self.viewForImg.bounds afterScreenUpdates:YES];
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   // self.drawingView.backgroundColor = [UIColor whiteColor];

    
//    NSMutableString * fileToSave = [self.techniqueName mutableCopy];
//    fileToSave = [fileToSave mutableCopy];
//    [fileToSave appendString: headtype];
//    fileToSave = [fileToSave mutableCopy];
//    [fileToSave appendString: @".png"];
//    NSLog(@"screenshot nsme %@", fileToSave);

//    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
//    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
//    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:fileToSave];
    
    NSData * thumbdata = UIImagePNGRepresentation(newImage);
    [self storeImageInTempDictionary:thumbdata];
    // [thumbdata writeToFile:thumbpath atomically:YES];
    self.drawingView.backgroundColor = [UIColor whiteColor];

    return newImage;
}

-(UIImage*)screentShot:(NSString*)headtype{
    
    NSLog(@"screenshot");
    UIImage * newImage;
    if([headtype isEqualToString:@"imageLeft"]){
        newImage = [self getImageOfScreen:@"thumb1"];
        [self.delegate passItemBackLeft:self imageForButton:newImage];
    }
    if([headtype isEqualToString:@"imageRight"]){
        newImage = [self getImageOfScreen:@"thumb2"];
        [self.delegate passItemBackRight:self imageForButton:newImage];
    }
    if([headtype isEqualToString:@"imageTop"]){
        newImage = [self getImageOfScreen:@"thumb3"];
        [self.delegate passItemBackTop:self imageForButton:newImage];
    }
    if([headtype isEqualToString:@"imageFront"]){
        newImage = [self getImageOfScreen:@"thumb4"];
        [self.delegate passItemBackFront:self imageForButton:newImage];
    }
    if([headtype isEqualToString:@"imageBack"]){
        newImage = [self getImageOfScreen:@"thumb5"];
        [self.delegate passItemBackBack:self imageForButton:newImage];
    }
    return newImage;
}
-(void)screenShotNotification{
    [self saveColorsToDefaults];
    [self removeGrid];
    [self.drawingView removeCircles]; //remove control circles when selected
    [self.drawingView removeTextViewFrame]; //create text layer when closing window
    [self screentShot:self.headtype];
    if([self loadGridAppearanceToDefaults]){
        [self performSelector:@selector(showOrHideGrid)];
    }
}

-(UIImage*)screenShotForSharing{
    NSLog(@"screenshot");
    [self removeGrid];
    UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, self.drawingView.opaque, 3.0);
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)share{
    NSString *textToShare;
    textToShare = [NSString stringWithFormat:@""];
    UIImage *imageToShare;
    imageToShare = [self screenShotForSharing];
    if([self loadGridAppearanceToDefaults]){
        [self performSelector:@selector(showOrHideGrid)];
    }
    NSArray *itemsToShare = [NSArray arrayWithObjects:textToShare, imageToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: itemsToShare applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
   
        
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:activityViewController animated: YES completion: nil];
        UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(728,60,10,1);
    
        [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
            if (!completed) {
                return;
                }
            else {
                [self setupNotificationToolbar];
            }
    }];
}

-(void)undoPressed{
    NSLog(@"UNDO");
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}
-(void)redoPressed{
    NSLog(@"REDO");
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}
- (void)updateButtonStatus
{
    [[self.navigationItem.rightBarButtonItems objectAtIndex:2] setEnabled:[self.drawingView canUndo]];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:[self.drawingView canRedo]];
}

#pragma mark Sharing image

- (void)setupNotificationToolbar {
    CGFloat startOfToolbar;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfToolbar = 100;
    }else {
        startOfToolbar = 10;
    }
    
    CGRect rect = CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height , self.view.frame.size.width - startOfToolbar * 2, 55);
    self.toolbarNotification = [[UIView alloc]initWithFrame:rect];
    self.toolbarNotification.alpha = 1.0f;
    [self.toolbarNotification setBackgroundColor:[UIColor colorNamed:@"orange"]];
    [self.toolbarNotification.layer setCornerRadius:15.0f];
    self.toolbarNotification.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolbarNotification.layer.shadowOffset = CGSizeMake(0,0);
    self.toolbarNotification.layer.shadowRadius = 8.0f;
    self.toolbarNotification.layer.shadowOpacity = 0.2f;
    self.toolbarNotification.layer.masksToBounds = NO;
    self.toolbarNotification.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.toolbarNotification.bounds cornerRadius:self.toolbarNotification.layer.cornerRadius].CGPath;
    [self addInfoButtonOnToolbar];
    [self.view addSubview:self.toolbarNotification];
    [UIView animateWithDuration:0.3
                     animations:^{
        
        self.toolbarNotification.frame =  CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height - 80, self.view.frame.size.width - startOfToolbar * 2, 55);
                     }];
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                       target:self
                                                     selector:@selector(hideAlertView:)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (UIButton*)fontButton:(NSString*)selector imageName1:(NSString*)imgName imageName2:(NSString*)imgName2 startX:(CGFloat)startX width:(CGFloat)btnWidth yAxe:(CGFloat)yAxe
{
    SEL selectorNew = NSSelectorFromString(selector);
     UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self
               action:selectorNew
     forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:@"OK" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    button.backgroundColor = [UIColor whiteColor];
    [button setTintColor:[UIColor colorNamed:@"orange"]];
    button.frame = CGRectMake(startX ,yAxe, btnWidth, 30);
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.0f;
    return button;
}
-(UILabel*)addInfoLabel:(NSString*)string startX:(CGFloat)startX font:(CGFloat)fntSize width:(CGFloat)width{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, width,50)];
    CGPoint newCenter = CGPointMake(startX + 5 , self.toolbar.frame.size.height / 2);
    label.center = newCenter;
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:fntSize];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = string;
    return label;
}

-(void)addInfoButtonOnToolbar{
    CGRect sizeRect = [UIScreen mainScreen].bounds;
    CGFloat originOfLabel;
    CGFloat fntSize;
    CGFloat width;
    CGFloat iPadDist;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        fntSize = 16;
        width = 335;
        iPadDist = 30;
        
    } else {
        fntSize = 14;
        width = 300;
        iPadDist = 8;
    }
    originOfLabel = sizeRect.size.width / 2.8;
    self.infoLabel = [self addInfoLabel:@"Your diagrams was exported" startX:originOfLabel font:fntSize width:width];
    [self.toolbarNotification addSubview:self.infoLabel];
    
    self.okButton =  [self fontButton:@"hideAlertView:" imageName1:@"info_icon_new.png" imageName2:@"info_icon_new.png" startX:self.infoLabel.frame.origin.x + self.infoLabel.frame.size.width - 40  width: 60 yAxe:self.toolbarNotification.frame.size.height - 42];
   [self.toolbarNotification addSubview:self.okButton];
    
}
-(void)hideAlertView:(UIButton*)button{
    CGFloat startOfToolbar;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfToolbar = 100;
    }else {
        startOfToolbar = 10;
    }
        [UIView animateWithDuration:0.3
                         animations:^{
            
            self.toolbarNotification.frame =  CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width - startOfToolbar * 2, 55);
  }];

}



-(void)saveDiagramToFile:(NSString*)techniqueName{

    NSMutableString * exportingFileName = [techniqueName mutableCopy];
    [exportingFileName appendString:@".htapp"];

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSData * data = [self dataOfType];

    // Save it into file system
    [data writeToFile:filePath atomically:YES];
   // NSURL * url = [NSURL fileURLWithPath:filePath];
}

- (NSData *)dataOfType{
    NSError *error = nil;
 
        NSMutableDictionary* dictToSave = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
}


@end
