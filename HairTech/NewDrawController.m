//
//  ViewController+NewDrawController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewDrawController.h"
#define btnColor  [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]


@implementation NewDrawController






-(void)viewDidLoad{
    arrayOfGrids = [NSMutableArray array];
    
    self.drawingView.delegate = self;
    self.drawingView.editMode = NO;
    self.drawingView.editModeforText = NO;
    self.drawingView.touchForText = 0;
    
    [self LoadColorsAtStart];
    [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
    self.drawingView.viewControllerName = @"left";
    [self setupNavigationBarItems];
    [self.img setImage:[UIImage imageNamed:self.imgName]];
    [self setupScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveColorsToDefaults) name:UIApplicationWillTerminateNotification object:nil];
   /* Setup toolBar and toolButoons */
    
    toolButtons = @[self.penTool, self.curveTool, self.dashTool, self.arrowTool,self.lineTool,self.eraserTool,self.textTool];
    [self setupBottomToolBar];
    [self setupToolButtonsAppeatance];
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
//    curveColor = [UIColor colorNamed:@"orange"];
//    dashColor = [UIColor colorNamed:@"deepblue"];
//    arrowColor = [UIColor redColor];
//    lineColor = [UIColor blueColor];
//    textColor = [UIColor blackColor];
    self.fontSizeVC = 15;
    }
- (void)viewWillDisappear:(BOOL)animated{
    [self saveColorsToDefaults];
    [self removeGrid];
}

- (void)setupScrollView {
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 5.0;
    scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
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
}


- (void)setupBottomToolBar {
   self.toolbar.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + self.view.frame.size.height - 80, self.view.frame.size.width - 20, 55);
    self.toolbar.alpha = 1.0f;
    [self.toolbar.layer setBackgroundColor:[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f]CGColor]];
    [self.toolbar.layer setCornerRadius:15.0f];
    [super viewDidLoad];
    self.toolbar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolbar.layer.shadowOffset = CGSizeMake(0,0);
    self.toolbar.layer.shadowRadius = 8.0f;
    self.toolbar.layer.shadowOpacity = 0.2f;
    self.toolbar.layer.masksToBounds = NO;
    self.toolbar.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.toolbar.bounds cornerRadius:self.toolbar.layer.cornerRadius].CGPath;
}

-(void)setupToolButtonsAppeatance{
    for(int i=0; i< toolButtons.count; i++) {
        if(![[toolButtons objectAtIndex:i] isSelected]){
            UIButton *btn = [toolButtons objectAtIndex:i];
            btn.backgroundColor = btnColor;
            btn.layer.cornerRadius = 15.0;
        }
    }
}


-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
   // [self.drawingView updateZoomFactor:scrollView.zoomScale];
    }

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
      CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);

      scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.drawingView;
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

    [grid setTintColor:[UIColor colorNamed:@"deepblue"]];

    
    UIButton *undo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [undo addTarget:self
             action:@selector(undo)
   forControlEvents:UIControlEventTouchUpInside];
    [undo.widthAnchor constraintEqualToConstant:30].active = YES;
    [undo.heightAnchor constraintEqualToConstant:30].active = YES;
    [undo setImage:[UIImage imageNamed:@"undoNew.png"] forState:UIControlStateNormal];
    [undo setTintColor:[UIColor colorNamed:@"deepblue"]];
    
    UIButton *redo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [redo addTarget:self
             action:@selector(redo)
   forControlEvents:UIControlEventTouchUpInside];
    [redo.widthAnchor constraintEqualToConstant:30].active = YES;
    [redo.heightAnchor constraintEqualToConstant:30].active = YES;
    [redo setImage:[UIImage imageNamed:@"redoNew.png"] forState:UIControlStateNormal];
    [redo setTintColor:[UIColor colorNamed:@"deepblue"]];

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [more addTarget:self
             action:@selector(presentAlertView)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    [more setImage:[UIImage imageNamed:@"dots.png"] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"deepblue"]];

    UIBarButtonItem * gridBtn =[[UIBarButtonItem alloc] initWithCustomView:grid];
    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc]initWithCustomView:undo];
    UIBarButtonItem *redoBtn = [[UIBarButtonItem alloc]initWithCustomView:redo];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBtn, redoBtn, undoBtn,gridBtn, nil];
}

-(void)presentAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Presenting the great... StackOverFlow!"];
//    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(24, 11)];
//    [alertVC setValue:hogan forKey:@"attributedTitle"];
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"Share"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   [self openShareMenu];
                                                   }];
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

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
-(void)openShareMenu{
    NSLog(@"Open Share Menu");
}
-(void)clearPage{
    [self.drawingView removeAllDrawings];
}

-(void)addGrid{
        NSLog(@"ADD GRID TO VIEW");
        int numberOfRows = self.img.frame.size.height/12;
        int numberOfColumns = self.img.frame.size.width/12;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.25);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
        
        // Drawing column lines

        CGFloat columnWidth = self.img.frame.size.width / (numberOfColumns + 1.0);
        for(int i = 1; i <= numberOfColumns; i++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = columnWidth * i;
            startPoint.y = 0.0f;
            endPoint.x = startPoint.x;
            endPoint.y = self.img.frame.size.height;
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
        CGFloat rowHeight = self.img.frame.size.height / (numberOfRows + 1.0);
        for(int j = 1; j <= numberOfRows; j++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = 0.0f;
            startPoint.y = rowHeight * j;
            endPoint.x = self.img.frame.size.width;
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
-(void)showOrHideGrid{
    if(arrayOfGrids.count == 0){
        [grid setTintColor:[UIColor colorNamed:@"orange"]];
        [self addGrid];
    } else {
        [self removeGrid];
        [grid setTintColor:[UIColor colorNamed:@"deepblue"]];
    }
    
}


-(void)saveColorsToDefaults{
    const CGFloat  *components2 = CGColorGetComponents(dashColor.CGColor);
    const CGFloat  *components3 = CGColorGetComponents(arrowColor.CGColor);
    const CGFloat  *components4 = CGColorGetComponents(lineColor.CGColor);
    const CGFloat  *components5 = CGColorGetComponents(curveColor.CGColor);
    const CGFloat  *components6 = CGColorGetComponents(penColor.CGColor);

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setFloat:components2[0]  forKey:@"cr2"];
    [prefs setFloat:components2[1]  forKey:@"cg2"];
    [prefs setFloat:components2[2]  forKey:@"cb2"];
    [prefs setFloat:components2[3]  forKey:@"ca2"];
    
    [prefs setFloat:components3[0]  forKey:@"cr3"];
    [prefs setFloat:components3[1]  forKey:@"cg3"];
    [prefs setFloat:components3[2]  forKey:@"cb3"];
    [prefs setFloat:components3[3]  forKey:@"ca3"];
    
    [prefs setFloat:components4[0]  forKey:@"cr4"];
    [prefs setFloat:components4[1]  forKey:@"cg4"];
    [prefs setFloat:components4[2]  forKey:@"cb4"];
    [prefs setFloat:components4[3]  forKey:@"ca4"];
    
    [prefs setFloat:components5[0]  forKey:@"cr5"];
    [prefs setFloat:components5[1]  forKey:@"cg5"];
    [prefs setFloat:components5[2]  forKey:@"cb5"];
    [prefs setFloat:components5[3]  forKey:@"ca5"];
    
    [prefs setFloat:components6[0]  forKey:@"cr6"];
    [prefs setFloat:components6[1]  forKey:@"cg6"];
    [prefs setFloat:components6[2]  forKey:@"cb6"];
    [prefs setFloat:components6[3]  forKey:@"ca6"];
    
    [prefs synchronize];
}

-(void)LoadColorsAtStart
{
    NSUserDefaults *prefers = [NSUserDefaults standardUserDefaults];
    UIColor* tColor5 = [UIColor colorWithRed:[prefers floatForKey:@"cr5"] green:[prefers floatForKey:@"cg5"] blue:[prefers floatForKey:@"cb5"] alpha:[prefers floatForKey:@"ca5"]];
    
    UIColor* tColor2 = [UIColor colorWithRed:[prefers floatForKey:@"cr2"] green:[prefers floatForKey:@"cg2"] blue:[prefers floatForKey:@"cb2"] alpha:[prefers floatForKey:@"ca2"]];
    
    UIColor* tColor3 = [UIColor colorWithRed:[prefers floatForKey:@"cr3"] green:[prefers floatForKey:@"cg3"] blue:[prefers floatForKey:@"cb3"] alpha:[prefers floatForKey:@"ca3"]];
    
    UIColor* tColor4 = [UIColor colorWithRed:[prefers floatForKey:@"cr4"] green:[prefers floatForKey:@"cg4"] blue:[prefers floatForKey:@"cb4"] alpha:[prefers floatForKey:@"ca4"]];
    
    UIColor* tColor6 = [UIColor colorWithRed:[prefers floatForKey:@"cr6"] green:[prefers floatForKey:@"cg6"] blue:[prefers floatForKey:@"cb6"] alpha:[prefers floatForKey:@"ca6"]];
    [prefers synchronize];
    
    [self extractRGBforBlack:tColor5];
    [self extractRGBforBlue:tColor2];
    [self extractRGBforRed:tColor3];
    [self extractRGBforLine:tColor4];
    [self extractRGBforPen:tColor6];
    
//    [self.colorBar1 setTextColor:self.blackExtract];
//    [self.colorBar2 setTextColor:self.blueExtract];
//    [self.colorBar3 setTextColor:self.redExtract];
//    [self.colorBar4 setTextColor:self.lineExtract];
//    [self.colorBar5 setTextColor:self.penExtract];

    textColor = [self extractRGBforTextNew:[GzColors colorFromHex:@"0xFF292F40"]];
    self.fontSizeVC = 15;
    NSLog(@"I have extracted colors");
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    float height = textView.contentSize.height;
    [UITextView beginAnimations:nil context:nil];
    [UITextView setAnimationDuration:0.1];
    CGRect frame = textView.frame;
    frame.size.height = height + 20;
    textView.frame = frame;
    [self.drawingView adjustRectWhenTextChanged:frame];
    [UITextView commitAnimations];
    
    if ([textView.text isEqualToString:@"TEXT"]){
    [textView setSelectedTextRange:[textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.endOfDocument]];
    }

return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //handle user taps text view to type text
}
- (void)textViewDidChange:(UITextView *)txtView{
    float height = txtView.contentSize.height;
    [UITextView beginAnimations:nil context:nil];
    [UITextView setAnimationDuration:0.1];
    CGRect frame = txtView.frame;
    frame.size.height = height + 20;
    txtView.frame = frame;
    [self.drawingView adjustRectWhenTextChanged:frame];
    [UITextView commitAnimations];
}



//- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
//    //The popover is automatically dismissed if you click outside it, unless you return NO here
//    if (thePopoverController != self.popoverTextSettings){
//        return YES;
//    } else {
//        return  NO;
//    }
//}
- (void)longPressPenTool:(UILongPressGestureRecognizer *)gestureRecognizer {
        [self saveColorsToDefaults];
        [self pencilPressed:[self.view viewWithTag:5]];
        //[self makeButtonSelected];
        //self.penTool.selected = YES;
        [longpressPenTool setDelaysTouchesBegan:YES];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:penColor];
            contentViewController.delegate = self;
            contentViewController.currentPenColor = penColor;
            self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromRect:CGRectMake(self.penTool.frame.origin.x,self.penTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:curveColor];
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
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:dashColor];        contentViewController.delegate = self;
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
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:arrowColor];
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
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:lineColor];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = lineColor;
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(self.lineTool.frame.origin.x,self.lineTool.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
-(void)extractRGBforPen:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    penColor = tempcolor;
}


-(void)extractRGBforBlue:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    dashColor = tempcolor;
  
}

-(void)extractRGBforBlack:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    curveColor = tempcolor;
}
-(void)extractRGBforRed:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    arrowColor = tempcolor;
}

-(void)extractRGBforLine:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    lineColor = tempcolor;
}

-(void)extractRGBforText:(UIColor*)tempcolor
{
   CGFloat redtemp = 0.0;
   CGFloat greentemp = 0.0;
    CGFloat bluetemp = 0.0;
    CGFloat alphatemp = 1.0;
    
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    textColor = tempcolor;
}
-(UIColor*)extractRGBforTextNew:(UIColor*)tempcolor
{
    CGFloat redtemp = 0.0;
    CGFloat greentemp = 0.0;
     CGFloat bluetemp = 0.0;
     CGFloat alphatemp = 1.0;
    [tempcolor getRed:&redtemp green:&greentemp blue:&bluetemp alpha:&alphatemp];
    return tempcolor;
}


//-(NSString *)UIColorToHexStringWithRed:(CGFloat*)myred green:(CGFloat*)mygreen blue:(CGFloat*)myblue  alpha:(CGFloat*)myalpha{
//    
//    
//    NSString *hexString  = [NSString stringWithFormat:@"#%02x%02x%02x%02x",
//                            ((int)alpha),((int)red),((int)green),((int)blue)];
//    return hexString;
//}

-(void)colorPopoverControllerDidSelectColor:(NSString *)hexColor {
    if(self.penTool.selected == YES){
        [self extractRGBforPen:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypePen;
        self.drawingView.lineColor = penColor;
        self.penTool.backgroundColor = penColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    
    if(self.curveTool.selected == YES){
        [self extractRGBforBlack:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeCurve;
        self.curveTool.backgroundColor = curveColor;
        self.drawingView.lineColor = curveColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    if (self.dashTool.selected == YES){
        [self extractRGBforBlue:[GzColors colorFromHex:hexColor]];
        [self deselectInactioveButtons];
        self.drawingView.drawTool = ACEDrawingToolTypeDashLine;
        self.drawingView.lineColor = dashColor;
         self.dashTool.backgroundColor = dashColor;
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    if(self.arrowTool.selected == YES){
        [self extractRGBforRed:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeArrow;
        self.drawingView.lineColor = arrowColor;
        self.arrowTool.backgroundColor = arrowColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    if(self.lineTool.selected == YES){
        [self extractRGBforLine:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeLine;
        self.drawingView.lineColor = lineColor;
         self.lineTool.backgroundColor = lineColor;
        [self deselectInactioveButtons];
        [self.view setNeedsDisplay];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    self.popoverController = nil;
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

-(void) saveCurrentToolToUserDeafaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float) loadCurrentToolFromUserDefaultsForKey:(NSString *)key {
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
            self.arrowTool.selected=YES;
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
            self.lineTool.selected=YES;
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
            
            curveToggleIsOn = nil;
           // dashLineCount = 0;
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
                [self.drawingView addFrameForTextView:gripFrame centerPoint:self.drawingView.center text:@"TEXT" color:textColor font:self.fontSizeVC];
                [contentTextView setFontSizee:self.fontSizeVC];
                self.drawingView.textViewFontSize = self.fontSizeVC;
            }
            self.drawingView.textViewNew.delegate = self;
            if (contentTextView == nil){
                [self showTextColorsAndSize:textColor]; //??????????? atttention
                [contentTextView setFontSizee:self.fontSizeVC];
            }
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
    self.eraserTool.backgroundColor = [UIColor blackColor];
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

-(void)removeTextSettings{
    NSLog(@"remove text settings");
    [contentTextView removeFromSuperview];
    contentTextView = nil;
}


-(void)showTextColorsAndSize:(UIColor*)color{
    contentTextView = [[ColorViewController alloc] initWithFrame:self.toolbar.bounds isSelected:YES color:color];
    contentTextView.center = self.toolbar.center;
    //contentTextView.currentPenColor = color;
    textSetterState = YES;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
}



- (void)colorPopoverDidSelectTextColor:(NSString *)hexColor{
    NSLog(@"selected color for text");
    [self extractRGBforText:[GzColors colorFromHex:hexColor]];
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
@end