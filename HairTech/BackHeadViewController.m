
#import "BackHeadViewController.h"
#import "AppDelegate.h"

#define btnColor  [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@implementation BackHeadViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
*/
@synthesize mainImage;
@synthesize tempDrawImage;
@synthesize middleImg;
//@synthesize loadImg;
@synthesize blackbtn;
@synthesize bluebtn;
@synthesize redbtn;
@synthesize eraserbtn;
@synthesize lineButton;
@synthesize textbtn;
@synthesize labelDrawController;
@synthesize penbtn;
@synthesize brush;
@synthesize opacity;

@synthesize red;
@synthesize green;
@synthesize blue;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(actionSheet5.visible)
        [actionSheet5 dismissWithClickedButtonIndex:-1 animated:YES];
    [self closeAndSave];
    
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [self setMiddleImg:nil];
    //[self setLoadImg:nil];
    [self setBlackbtn:nil];
    [self setBluebtn:nil];
    [self setRedbtn:nil];
    [self setEraserbtn:nil];
    [self setBlackbtn:nil];
    [self setLabelDrawController:nil];
    
    [self.drawingView removeFromSuperview];
    
    self.imagethumb1 = nil;
    self.imagethumb2 = nil;
    self.imagethumb3 = nil;
    self.imagethumb4 = nil;
    self.imagethumb5=nil;
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
    
    
    [self.colorBar1 setTextColor:self.blackExtract];
    [self.colorBar2 setTextColor:self.blueExtract];
    [self.colorBar3 setTextColor:self.redExtract];
    [self.colorBar4 setTextColor:self.lineExtract];
    [self.colorBar5 setTextColor:self.penExtract];
    
    self.textExtract = [self extractRGBforTextNew:[GzColors colorFromHex:@"0xFF292F40"]];
    self.fontSizeVC = 15;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //if(appDelegate.checkwindow !=1 && appDelegate.checkHead2==1){

    [self loadMainImage];
   // [self LoadColorsAtStart];
    //}
    //appDelegate.checkwindow = 0;
    self.labelDrawController.text = self.stringForLabel;
    
    
    NSLog(@"The LabelDrawController = %@",self.stringForLabel);
    
    //   self.labelfoo.text = self.foo; ////Show entered text in Mysubview textfield in drawViewController
    //convertedLabel = self.labelfoo.text;
    [super viewWillAppear:YES];
    

    //////-------------------------------------------
    longpressblackbtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    longpressblackbtn .minimumPressDuration = 0.2;
    
    [blackbtn addGestureRecognizer:longpressblackbtn];
    //////-------------------------------------------
    longpressbluebtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandlerBlue:)];
    longpressbluebtn .minimumPressDuration = 0.2;
    
    [bluebtn addGestureRecognizer:longpressbluebtn];
    ///////---------------------------------------
    longpressredbtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandlerRed:)];
    longpressredbtn .minimumPressDuration = 0.2;
    
    [redbtn addGestureRecognizer:longpressredbtn];
    ////---------------------------------------------
    longpresslinebtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandlerLine:)];
    longpresslinebtn .minimumPressDuration = 0.2;
    
    [lineButton addGestureRecognizer:longpresslinebtn];
    longpresspenbtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandlerPen:)];
    longpresspenbtn .minimumPressDuration = 0.2;
    
    [penbtn addGestureRecognizer:longpresspenbtn];

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
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
    
//    [txtView scrollRangeToVisible:NSMakeRange(txtView.text.length, 0)];
//        [txtView scrollRectToVisible:[txtView caretRectForPosition:txtView.endOfDocument] animated:NO];
}


-(void)setupButtons
{
    redbtn.layer.cornerRadius = 15;
    redbtn.backgroundColor = self.redExtract;
    
    lineButton.layer.cornerRadius = 15;
    lineButton.backgroundColor = self.lineExtract;
    
    bluebtn.layer.cornerRadius = 15;
    bluebtn.backgroundColor = self.blueExtract;
    
    penbtn.layer.cornerRadius = 15;
    penbtn.backgroundColor = self.penExtract;
    
    blackbtn.layer.cornerRadius = 15;
    blackbtn.backgroundColor = self.blackExtract;
    
    textbtn.layer.cornerRadius = 15.0;
    textbtn.backgroundColor = [UIColor blackColor];
    
    eraserbtn.layer.cornerRadius = 15.0;
    

    penbtn.backgroundColor =  btnColor;
    blackbtn.backgroundColor = btnColor;
    bluebtn.backgroundColor = btnColor;
    redbtn.backgroundColor =  btnColor;
    textbtn.backgroundColor = btnColor;
    
    self.btn.layer.cornerRadius = 15.0;
    self.btn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    self.btn.layer.shadowOpacity = 0.5;
    self.btn.layer.shadowRadius = 2;
    self.btn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    redbtn.alpha = 0.0;
    lineButton.alpha = 0.0;
    bluebtn.alpha = 0.0;
    penbtn.alpha = 0.0;
    blackbtn.alpha = 0.0;
    textbtn.alpha = 0.0;
    eraserbtn.alpha = 0.0;

}

- (void)setupBottomToolBar {
    self.imageToolbar1.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + self.view.frame.size.height - 70, self.view.frame.size.width - 20, 55);
    self.imageToolbar1.alpha = 1.0f;
    [self.imageToolbar1 setBackgroundColor:[UIColor colorNamed:@"whiteDark"]];
    [self.imageToolbar1.layer setCornerRadius:15.0f];
    [super viewDidLoad];
    self.imageToolbar1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageToolbar1.layer.shadowOffset = CGSizeMake(0,0);
    self.imageToolbar1.layer.shadowRadius = 8.0f;
    self.imageToolbar1.layer.shadowOpacity = 0.2f;
    self.imageToolbar1.layer.masksToBounds = NO;
    self.imageToolbar1.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.imageToolbar1.bounds cornerRadius:self.imageToolbar1.layer.cornerRadius].CGPath;
    [self addInfoButtonOnToolbar];

}
- (void)viewDidLoad
{
    self.drawingView.userInteractionEnabled = NO;
    textSelected = NO; // UITextView from drawing view is not selected
    [self LoadColorsAtStart];
    [self setupButtons];
    [self loadFloatFromUserDefaultsForKey:@"lineWidth"];

    self.drawingView.viewControllerName = @"back";
    [self setupBottomToolBar];
    [super viewDidLoad];
    [self.drawingView getViewControllerId:[self restorationIdentifier] nameOfTechnique: self.stringForLabel];
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"GLOBALDATE %@", appDelegate.globalDate);
    appDelegate.currentViewName = @"back";    
    if((![appDelegate.globalDate isEqualToString:@"new_version"])||(![appDelegate.globalDate isEqualToString:@"men_heads"]))
       {
        [self.NewImageView setImage:[UIImage imageNamed:@"View_backHead_created.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"View_backHead_created_transp.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"View_backHead_created_transp.png"]];
        
        
    }
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    

    
    if (((screenHeight==736)&&[appDelegate.globalDate isEqualToString:@"new_version"])||((screenHeight==568)&&[appDelegate.globalDate isEqualToString:@"new_version"])||((screenHeight==667)&&[appDelegate.globalDate isEqualToString:@"new_version"]))
    {
    
    
        [self.NewImageView setImage:[UIImage imageNamed:@"back_7p_tr.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"back_7p_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"back_7p_tr.png"]];
    }
    
    if (((screenHeight==1024)&&[appDelegate.globalDate isEqualToString:@"new_version"])||
        ((screenHeight==1366)&&[appDelegate.globalDate isEqualToString:@"new_version"])||
        ((screenHeight==834)&&[appDelegate.globalDate isEqualToString:@"new_version"])){
        
        [self.NewImageView setImage:[UIImage imageNamed:@"ipad_back.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"ipad_back_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"ipad_back_tr.png"]];
        
    }
    
    if ((screenHeight==812)&&[appDelegate.globalDate isEqualToString:@"new_version"])
    {
        
        [self.NewImageView setImage:[UIImage imageNamed:@"x_back.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"x_back_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"x_back_tr.png"]];
    }
    
    /*----------------------MEN HEADS------------------------------*/
           
           
            if (((screenHeight==736)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||((screenHeight==568)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||((screenHeight==667)&&[appDelegate.globalDate isEqualToString:@"men_heads"]))
               {
               
               //[self.NewImageView setImage:[UIImage imageNamed:@"iphone7plus.png"]];
       [self.NewImageView setImage:[UIImage imageNamed:@"men-iphone7-back.png"]];
               [self.middleImg setImage:[UIImage imageNamed:@"men-iphone7-back-tr.png"]];
               [self.previewImageView setImage:[UIImage imageNamed:@"men-iphone7-back-tr.png"]];
           }
           
           if (((screenHeight==1024)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||
              ((screenHeight==1366)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||
              ((screenHeight==834)&&[appDelegate.globalDate isEqualToString:@"men_heads"])){
               
               [self.NewImageView setImage:[UIImage imageNamed:@"men-ipad-back.png"]];
               [self.middleImg setImage:[UIImage imageNamed:@"men-ipad-back-tr.png"]];
               [self.previewImageView setImage:[UIImage imageNamed:@"men-ipad-back-tr.png"]];
               
           }
           if ((screenHeight==812)&&[appDelegate.globalDate isEqualToString:@"men_heads"])
           {
               
               [self.NewImageView setImage:[UIImage imageNamed:@"men-back-11.png"]];
               [self.middleImg setImage:[UIImage imageNamed:@"men-back-11-tr.png"]];
               [self.previewImageView setImage:[UIImage imageNamed:@"men-back-11-tr.png"]];
           }
       
//    [self adGridToImgView];

    self.navigationItem.title=self.stringFromVC;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    [self.toolbar setClipsToBounds:YES];
    UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    self.view.backgroundColor = mycolor2;
    self.drawingView.delegate = self;
    [self.toolbarImg.layer setBorderWidth:2.0];
    [self.toolbarImg.layer setBorderColor:[UIColor yellowColor].CGColor];

    
[self.lineButton setSelected:YES];

    [super viewDidLoad];

    self.drawingView.editMode = NO;
    self.drawingView.editModeforText = NO;
    self.drawingView.touchForText=0;
    

    [self.btn setEnabled:NO];
    [self.btn setHidden:YES];

    self.drawingView.type = JVDrawingTypeLine;
    self.drawingView.bufferType = JVDrawingTypeLine;
    self.drawingView.previousType = lineButton;
    self.drawingView.lineColor = self.lineExtract;
    self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
    
       penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
         blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
         bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
         redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
         lineButton.backgroundColor = self.lineExtract;
       
       

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageRetina) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveColorsToDefaults) name:UIApplicationWillTerminateNotification object:nil];
    

    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.7;
    scrollView.maximumZoomScale = 5.0;
    scrollView.contentSize = self.viewForImg.frame.size;

    
    
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
    
    
    
    
    
    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([sharedDefaults boolForKey:@"FirstPopCurve1"])
    {
        [self.popTipCurve showText:@"Tap to change type of curved line" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:blackbtn.frame];
        
        
        [sharedDefaults setBool:NO forKey:@"FirstPopCurve1"];
        [sharedDefaults synchronize];
        
    }
    
    
    self.popTipCurve.dismissHandler = ^{
        NSLog(@"Dismiss!");
        
        [self.popTipLine showText:@"Long press to change color" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:lineButton.frame];
        
        
    };
    
    buttons = @[blackbtn, penbtn, redbtn, lineButton,bluebtn,textbtn,eraserbtn];
    [self setupNavigationBarItems];
}
- (void)setupNavigationBarItems {
    //    UIButton *undo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [undo addTarget:self
    //             action:@selector(undo)
    //   forControlEvents:UIControlEventTouchUpInside];
    //    [undo.widthAnchor constraintEqualToConstant:30].active = YES;
    //    [undo.heightAnchor constraintEqualToConstant:30].active = YES;
    //    [undo setImage:[UIImage imageNamed:@"undoNew.png"] forState:UIControlStateNormal];
    //
    //    UIButton *redo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [redo addTarget:self
    //             action:@selector(redo)
    //   forControlEvents:UIControlEventTouchUpInside];
    //    [redo.widthAnchor constraintEqualToConstant:30].active = YES;
    //    [redo.heightAnchor constraintEqualToConstant:30].active = YES;
    //    [redo setImage:[UIImage imageNamed:@"redoNew.png"] forState:UIControlStateNormal];
    //
    //    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [more addTarget:self
    //             action:@selector(presentAlertView)
    //   forControlEvents:UIControlEventTouchUpInside];
    //    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    //    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    //    [more setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    //    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
    //    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc]initWithCustomView:undo];
    //    UIBarButtonItem *redoBtn = [[UIBarButtonItem alloc]initWithCustomView:redo];
    //
    //
    //    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBtn, redoBtn, undoBtn, nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openShareMenu)];
    self.navigationItem.rightBarButtonItem = shareButton;
}
-(void)presentAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Alert Title" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Presenting the great... StackOverFlow!"];
//    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(24, 11)];
//    [alertVC setValue:hogan forKey:@"attributedTitle"];
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"Share"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   [self openShareMenu];
                                                   }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Clear"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action){
                                                    [self clearPage];
                                                   }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                       //add code to make something happen once tapped
                                                   }];
    [button setValue:[[UIImage imageNamed:@"image.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

    [button2 setValue:[[UIImage systemImageNamed:@"trash"]
                       imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
    [button setValue:[[UIImage systemImageNamed:@"tray.and.arrow.up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
    [alertVC addAction:button];
    [alertVC addAction:button2];
    [alertVC addAction:button3];

    [self presentViewController:alertVC animated:YES completion:nil];

}



-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.drawingView updateZoomFactor:scrollView.zoomScale];
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageViewFrame = self.viewForImg.frame ;
    
    // centre horizontally
    if (imageViewFrame.size.width < boundsSize.width) {
        imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2;
    } else {
        imageViewFrame.origin.x = 0;
    }
    
    // centre vertically
    if (imageViewFrame.size.height < boundsSize.height && self.viewForImg) {
        imageViewFrame.origin.y = (boundsSize.height - imageViewFrame.size.height) / 2;
    } else {
        imageViewFrame.origin.y = 0;
    }
    self.viewForImg.frame = imageViewFrame;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.viewForImg;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
}
- (void)viewDidUnload
{
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [self setMiddleImg:nil];
    //[self setLoadImg:nil];
    [self setBlackbtn:nil];
    [self setBluebtn:nil];
    [self setRedbtn:nil];
    [self setEraserbtn:nil];
    [self setBlackbtn:nil];
    [self setLabelDrawController:nil];
    
    [self.drawingView removeFromSuperview];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)saveColorsToDefaults{
    
    //  const CGFloat  *components1 = CGColorGetComponents([UIColor darkGrayColor].CGColor);
    const CGFloat  *components2 = CGColorGetComponents(self.blueExtract.CGColor);
    const CGFloat  *components3 = CGColorGetComponents(self.redExtract.CGColor);
    const CGFloat  *components4 = CGColorGetComponents(self.lineExtract.CGColor);
    const CGFloat  *components5 = CGColorGetComponents(self.blackExtract.CGColor);
    const CGFloat  *components6 = CGColorGetComponents(self.penExtract.CGColor);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //    [prefs setFloat:components1[0]  forKey:@"cr"];
    //   [prefs setFloat:components1[1]  forKey:@"cg"];
    //  [prefs setFloat:components1[2]  forKey:@"cb"];
    // [prefs setFloat:components1[3]  forKey:@"ca"];
    
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
    NSLog(@"I just saved colors");
    
    
}


- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}
/*- (void)longPressHandlerPen:(UILongPressGestureRecognizer *)gestureRecognizer {
        [self saveColorsToDefaults];
        [self pencilPressed:[self.view viewWithTag:5]];
        penbtn.selected = YES;
        blackbtn.selected=NO;
        bluebtn.selected=NO;
        redbtn.selected=NO;
        eraserbtn.selected=NO;
        lineButton.selected=NO;
        [longpresspenbtn setDelaysTouchesBegan:YES];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:self.penExtract];
            contentViewController.delegate = self;
            contentViewController.currentPenColor = self.penExtract;
            self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromRect:CGRectMake(penbtn.frame.origin.x,penbtn.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        penbtn.selected = YES;
}
- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:0]];
    lineButton.selected = NO;
    longpressblackbtn.minimumPressDuration = 0.2;
    [longpressblackbtn setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:self.blackExtract];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.blackExtract;
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(blackbtn.frame.origin.x,blackbtn.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

    }
}
- (void)longPressHandlerBlue:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:1]];
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=YES;
    redbtn.selected=NO;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    longpressbluebtn .minimumPressDuration = 0.2;
    [longpressbluebtn setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:self.blueExtract];        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.blueExtract;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(bluebtn.frame.origin.x,bluebtn.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    bluebtn.selected=YES;
}
- (void)longPressHandlerRed:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:2]];
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=NO;
    redbtn.selected=YES;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    longpressredbtn .minimumPressDuration = 0.2;
    [longpressredbtn setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:self.redExtract];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.redExtract;
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(redbtn.frame.origin.x,redbtn.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    redbtn.selected=YES;
}

- (void)longPressHandlerLine:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:3]];
    if(self.popTipLine){
        [self.popTipLine hide];
    }
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=NO;
    redbtn.selected=NO;
    eraserbtn.selected=NO;
    lineButton.selected=YES;
    longpresslinebtn .minimumPressDuration = 0.2;
    [longpresslinebtn setDelaysTouchesBegan:YES];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        ColorViewController *contentViewController = [[ColorViewController alloc] initWithFrame:CGRectMake(0,0,240,120) isSelected:NO color:self.lineExtract];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.lineExtract;
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:CGRectMake(lineButton.frame.origin.x,lineButton.frame.origin.y - 5,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    lineButton.selected=YES;
}*/
-(void)extractRGBforPen:(UIColor*)tempcolor
{
    
    /////// PUT NSNOTIFICATION METHOD TO SEND SAVED COLOS;
    redtemp5 = 0.0; greentemp5= 0.0; bluetemp5 = 0.0; alphatemp5 = 1.0;
    
    [tempcolor getRed:&redtemp5 green:&greentemp5 blue:&bluetemp5 alpha:&alphatemp5];
    self.penExtract=tempcolor;
    red_pen=redtemp5;
    green_pen=greentemp5;
    blue_pen=bluetemp5;
    alpha_pen=1.0;
    opacity=1.0;
    //  brush_blue=3.0;
    NSLog(@"Color was extracted");
    
}

-(void)extractRGBforBlue:(UIColor*)tempcolor
{
    
    /////// PUT NSNOTIFICATION METHOD TO SEND SAVED COLOS;
    redtemp2 = 0.0; greentemp2= 0.0; bluetemp2 = 0.0; alphatemp2 = 1.0;
    
    [tempcolor getRed:&redtemp2 green:&greentemp2 blue:&bluetemp2 alpha:&alphatemp2];
    self.blueExtract =tempcolor;
    red_blue=redtemp2;
    green_blue=greentemp2;
    blue_blue=bluetemp2;
    alpha_blue=1.0;
    opacity=1.0;
    brush_blue=3.0;
    NSLog(@"Color was extracted");
    
    
}

-(void)extractRGBforBlack:(UIColor*)tempcolor
{
    redtemp1 = 0.0; greentemp1= 0.0; bluetemp1 = 0.0; alpha = 1.0;
    
    [tempcolor getRed:&redtemp1 green:&greentemp1 blue:&bluetemp1 alpha:&alphatemp1];
    self.blackExtract =tempcolor;
    red =redtemp1;
    green=greentemp1;
    blue=bluetemp1;
    alpha=1.0;
    opacity=1.0;
    brush=3.5;
    NSLog(@"Color was extracted");
    
    
}
-(void)extractRGBforRed:(UIColor*)tempcolor
{
    
    /////// PUT NSNOTIFICATION METHOD TO SEND SAVED COLOS;
    redtemp3 = 0.0; greentemp3= 0.0; bluetemp3 = 0.0; alphatemp3 = 1.0;
    
    [tempcolor getRed:&redtemp3 green:&greentemp3 blue:&bluetemp3 alpha:&alphatemp3];
    self.redExtract=tempcolor;
    red_red=redtemp3;
    green_red=greentemp3;
    blue_red=bluetemp3;
    alpha_red=1.0;
    opacity=1.0;
    brush_red=3.5;
    
    NSLog(@"Color was extracted");
    
    
}

-(void)extractRGBforLine:(UIColor*)tempcolor
{
    redtemp4 = 0.0; greentemp4= 0.0; bluetemp4 = 0.0; alphatemp4 = 1.0;
    
    [tempcolor getRed:&redtemp4 green:&greentemp4 blue:&bluetemp4 alpha:&alphatemp4];
    self.lineExtract = tempcolor;
    red_line =redtemp4;
    green_line=greentemp4;
    blue_line=bluetemp4;
    alpha_line=1.0;
    opacity=1.0;
    brush_line=3.0;
    NSLog(@"Color was extracted");
}
-(void)extractRGBforText:(UIColor*)tempcolor
{
    redtemp4 = 0.0; greentemp4= 0.0; bluetemp4 = 0.0; alphatemp4 = 1.0;
    
    [tempcolor getRed:&redtemp4 green:&greentemp4 blue:&bluetemp4 alpha:&alphatemp4];
    self.textExtract=tempcolor;
    red_line =redtemp4;
    green_line=greentemp4;
    blue_line=bluetemp4;
    alpha_line=1.0;
    opacity=1.0;
    brush_line=3.0;
}
-(UIColor*)extractRGBforTextNew:(UIColor*)tempcolor
{
    redtemp4 = 0.0; greentemp4= 0.0; bluetemp4 = 0.0; alphatemp4 = 1.0;
    
    [tempcolor getRed:&redtemp4 green:&greentemp4 blue:&bluetemp4 alpha:&alphatemp4];
  //  self.textExtract=tempcolor;
    red_line =redtemp4;
    green_line=greentemp4;
    blue_line=bluetemp4;
    alpha_line=1.0;
    opacity=1.0;
    brush_line=3.0;
    return tempcolor;
}
-(void) colorPopoverControllerDidSelectColor:(NSString *)hexColor {
    if(penbtn.selected==YES){
        [self extractRGBforPen:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypePen;
        self.drawingView.lineColor = self.penExtract;
        [self.colorBar5 setTextColor:self.penExtract];
        self.penbtn.backgroundColor = self.penExtract;
        blackbtn.backgroundColor = btnColor;
        bluebtn.backgroundColor = btnColor;
        redbtn.backgroundColor = btnColor;
        lineButton.backgroundColor = btnColor;
        [self.view setNeedsDisplay];
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    
    if(    blackbtn.selected==YES){
        [self extractRGBforBlack:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeCurve;
        self.drawingView.lineColor = self.blackExtract;
        self.blackbtn.backgroundColor = self.blackExtract;
        self.drawingView.drawTool = ACEDrawingToolTypeCurve;
        self.drawingView.lineColor = self.blackExtract;
        self.blackbtn.backgroundColor = self.blackExtract;
        self.penbtn.backgroundColor = btnColor;
        bluebtn.backgroundColor = btnColor;
        redbtn.backgroundColor = btnColor;
        lineButton.backgroundColor = btnColor;
        [self.view setNeedsDisplay];
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    if (bluebtn.selected==YES){
        [self extractRGBforBlue:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeDashLine;
        self.drawingView.lineColor = self.blueExtract;
        [self.colorBar2 setTextColor:self.blueExtract];
         self.bluebtn.backgroundColor = self.blueExtract;
        blackbtn.backgroundColor = btnColor;
        self.penbtn.backgroundColor = btnColor;
        redbtn.backgroundColor = btnColor;
        lineButton.backgroundColor = btnColor;
        [self.view setNeedsDisplay];
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    if(redbtn.selected==YES){
        [self extractRGBforRed:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeArrow;
        self.drawingView.lineColor = self.redExtract;
        [self.colorBar3 setTextColor:self.redExtract];
         self.redbtn.backgroundColor = self.redExtract;
        bluebtn.backgroundColor = btnColor;
        blackbtn.backgroundColor = btnColor;
        penbtn.backgroundColor = btnColor;
        lineButton.backgroundColor =btnColor;
        [self.view setNeedsDisplay];
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    if(lineButton.selected==YES){
        [self extractRGBforLine:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeLine;
        self.drawingView.lineColor = self.lineExtract;
        [self.colorBar4 setTextColor:self.lineExtract];
         self.lineButton.backgroundColor = self.lineExtract;
        bluebtn.backgroundColor = btnColor;
        blackbtn.backgroundColor = btnColor;
        penbtn.backgroundColor = btnColor;
        redbtn.backgroundColor = btnColor;
        [self.view setNeedsDisplay];
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverController = nil;
    [penbtn addGestureRecognizer:longpresspenbtn];

    [blackbtn addGestureRecognizer:longpressblackbtn];
    [bluebtn addGestureRecognizer:longpressbluebtn];
    [redbtn addGestureRecognizer:longpressredbtn];
    [lineButton addGestureRecognizer:longpresslinebtn];
}


-(void) sliderDidSelectWidth:(CGFloat)lineWidth {
    
    
    
    NSLog(@"Arrow Width = %f",lineWidth);
    
    
    self.drawingView.lineWidth = lineWidth;

}


-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}



/*Current tool */
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
    dashLineCount = 0;
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=NO;
    redbtn.selected=NO;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    textbtn.selected = YES;
    self.drawingView.eraserSelected = NO;
    [self makeButtonSelected];
    
    [self.drawingView enableGestures];
    self.drawingView.type = JVDrawingTypeText;
    self.drawingView.bufferType = JVDrawingTypeText;
    self.drawingView.lineColor = self.textExtract;
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
             blackbtn.selected=YES;
             penbtn.selected = NO;
             bluebtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=NO;
             textbtn.selected = NO;
             self.drawingView.eraserSelected = NO;
             blackbtn.backgroundColor=self.blackExtract;
             [self makeButtonSelected];
             
             [self saveCurrentToolToUserDeafaults:0.0 forKey:@"currentTool"];
             self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
             if(curveToggleIsOn){
                 [self.drawingView disableGestures];
                 self.drawingView.type = JVDrawingTypeCurvedDashLine;
                 self.drawingView.bufferType = JVDrawingTypeCurvedDashLine;
                 self.drawingView.previousType = sender;
                 self.drawingView.lineColor = self.blackExtract;
                 appDelegate.dashedCurve = YES;
                 [self.drawingView removeCirclesOnZoomDelegate];
             }
             else{
                 [self.drawingView disableGestures];
                 self.drawingView.type = JVDrawingTypeCurvedLine;
                 self.drawingView.bufferType = JVDrawingTypeCurvedLine;
                 self.drawingView.previousType = sender;
                 self.drawingView.lineColor = self.blackExtract;
                 appDelegate.dashedCurve = NO;
                 [self.drawingView removeCirclesOnZoomDelegate];
             }
             curveToggleIsOn = !curveToggleIsOn;
             [self.blackbtn setImage:[UIImage imageNamed:curveToggleIsOn ? @"curveNew.png" :@"curveDashNew.png"] forState:UIControlStateSelected];


             break;
         case 1:
             curveToggleIsOn = nil;
             dashLineCount = 0;
             bluebtn.selected=YES;
             penbtn.selected = NO;
             blackbtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=NO;
             textbtn.selected = NO;
             self.drawingView.eraserSelected = NO;
             bluebtn.backgroundColor = self.blueExtract;
             [self makeButtonSelected];


             [self.drawingView disableGestures];
             self.drawingView.type = JVDrawingTypeDashedLine;
             self.drawingView.bufferType = JVDrawingTypeDashedLine;
             self.drawingView.previousType = sender;
             self.drawingView.lineColor = self.blueExtract;
             [self saveCurrentToolToUserDeafaults:1.0 forKey:@"currentTool"];
             self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
             [self.drawingView removeCirclesOnZoomDelegate];

             break;
         case 2:
             curveToggleIsOn = nil;
             dashLineCount = 0;
             redbtn.selected=YES;
             penbtn.selected = NO;
             blackbtn.selected=NO;
             bluebtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=NO;
             textbtn.selected = NO;
             redbtn.backgroundColor = self.redExtract;
             self.drawingView.eraserSelected = NO;
             self.drawingView.lineColor = self.redExtract;

             [self makeButtonSelected];
             [self.drawingView disableGestures];
             self.drawingView.type = JVDrawingTypeArrow;
             self.drawingView.bufferType = JVDrawingTypeArrow;
             self.drawingView.previousType = sender;
             [self saveCurrentToolToUserDeafaults:2.0 forKey:@"currentTool"];
             self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
             [self.drawingView removeCirclesOnZoomDelegate];
             
             break;
         case 3:
             curveToggleIsOn = nil;
             dashLineCount = 0;
             penbtn.selected = NO;
             blackbtn.selected=NO;
             bluebtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=YES;
             textbtn.selected = NO;
             self.drawingView.eraserSelected = NO;
             lineButton.backgroundColor = self.lineExtract;
             
             [self makeButtonSelected];
             [self.drawingView disableGestures];
             self.drawingView.type = JVDrawingTypeLine;
             self.drawingView.bufferType = JVDrawingTypeLine;
             self.drawingView.previousType = sender;
             self.drawingView.lineColor = self.lineExtract;
             [self saveCurrentToolToUserDeafaults:3.0 forKey:@"currentTool"];
             self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
             [self.drawingView removeCirclesOnZoomDelegate];
             
             break;
         case 4:

             curveToggleIsOn = nil;
             dashLineCount = 0;
             penbtn.selected = NO;
             blackbtn.selected=NO;
             bluebtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=NO;
             textbtn.selected = YES;
             self.drawingView.eraserSelected = NO;
             [self makeButtonSelected];

             [self.drawingView enableGestures];
             self.drawingView.type = JVDrawingTypeText;
             self.drawingView.bufferType = JVDrawingTypeText;
             self.drawingView.lineColor = self.textExtract;
             self.drawingView.textTypesSender = sender; //Should be saved to user defaults
             
             CGRect gripFrame = CGRectMake(0, 0, 70, 38);
             if (!textSelected){
                 [self.drawingView addFrameForTextView:gripFrame centerPoint:self.drawingView.center text:@"TEXT" color:self.textExtract font:self.fontSizeVC];
                 [contentTextView setFontSizee:self.fontSizeVC];
                 self.drawingView.textViewFontSize = self.fontSizeVC;
             }
             
             self.drawingView.textViewNew.delegate = self;
             if (contentTextView == nil){
                 [self showTextColorsAndSize:self.textExtract]; //??????????? atttention
                 [contentTextView setFontSizee:self.fontSizeVC];
             }
             break;
         case 5:
             curveToggleIsOn = nil;
             dashLineCount = 0;
             penbtn.selected = YES;
             blackbtn.selected=NO;
             bluebtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=NO;
             lineButton.selected=NO;
             textbtn.selected = NO;
             self.drawingView.eraserSelected = NO;
             penbtn.backgroundColor = self.penExtract;
             
             [self makeButtonSelected];
             [self.drawingView disableGestures];
             self.drawingView.type = JVDrawingTypeGraffiti;
             self.drawingView.bufferType = JVDrawingTypeGraffiti;
             self.drawingView.previousType = sender;
             self.drawingView.lineColor = self.penExtract;
             [self saveCurrentToolToUserDeafaults:5.0 forKey:@"currentTool"];
             self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
             [self.drawingView removeCirclesOnZoomDelegate];

             break;
     }
     

 }
         - (IBAction)eraserPressed:(id)sender {
             dashLineCount = 0;

             penbtn.selected = NO;
             blackbtn.selected=NO;
             bluebtn.selected=NO;
             redbtn.selected=NO;
             eraserbtn.selected=YES;
             lineButton.selected=NO;
             textbtn.selected = NO;

             penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
             blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
             bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
             redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
             lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            
             self.drawingView.drawTool = ACEDrawingToolTypeEraser;
             self.drawingView.lineColor = [UIColor whiteColor];
             self.drawingView.lineWidth = 30.0;

             
     
 }


- (IBAction)reset:(id)sender {
    if (actionSheet5) {
        [actionSheet5 dismissWithClickedButtonIndex:-1 animated:YES];
        actionSheet5 = nil;
        return;
    }
    
    
    
    actionSheet5 = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear Page" otherButtonTitles:nil, nil];
    actionSheet5.delegate = self;
    
    [actionSheet5 showFromBarButtonItem:sender animated:YES];
    // [actionSheet showFromRect:CGRectMake(764,0,0,0) inView: self.view animated:YES];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
           [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
        // Do the delete
        self.NewImageView.image = nil;
        [ self.drawingView clear];
        self.drawingView.backgroundColor =[UIColor clearColor];
        [self updateButtonStatus];
        //[self saveImage];
        
    }
    else{
        actionSheet5 = nil;
    }
}
-(void)clearPage{
    [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    // Do the delete
    self.NewImageView.image = nil;
    [self.drawingView clear];
    self.drawingView.backgroundColor =[UIColor clearColor];
    [self updateButtonStatus];
}

- (void)saveImage{
    
    
    
    //   if (mainImage != nil)
    //  {
    //*save mainImage full-size
    
    UIGraphicsBeginImageContext(self.drawingView.frame.size);
    [self.NewImageView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.NewImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawingView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.middleImg.image drawInRect:CGRectMake(0, 0, self.middleImg.frame.size.width, self.middleImg.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    self.NewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    // self.middleImg.image = nil;
    UIGraphicsEndImageContext();
    
    CGSize newSize = CGSizeMake(256, 334);
    UIGraphicsBeginImageContext(newSize);
    
    [self.NewImageView.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    filenamethumb5= self.labelDrawController.text;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @"thumb5"];
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb5);
    
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:filenamethumb5];
    NSData* thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];
    
    ///------------Save big-size Image------------------------------------///////
    
    
    filenamebig5 = self.stringForLabel;
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @"big5"];
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @".png"];
    
    NSLog(@"Результат збереження великоиі картинки: %@.",filenamebig5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:filenamebig5];
    NSData* data = UIImagePNGRepresentation(self.NewImageView.image);
    [data writeToFile:path atomically:YES];
    
}
- (void)saveImageRetina{
    
      NSLog(@"DEALLOC 5");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.checkHead1=1;
    
   // UIGraphicsBeginImageContext(self.drawingView.frame.size);
    UIGraphicsBeginImageContextWithOptions(self.drawingView.frame.size, NO, 0.0);

    [self.NewImageView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.NewImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawingView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.middleImg.image drawInRect:CGRectMake(0, 0, self.middleImg.frame.size.width, self.middleImg.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    self.NewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    // self.middleImg.image = nil;
    UIGraphicsEndImageContext();
    
    
    
    CGSize newSize = CGSizeMake(512, 668);
    UIGraphicsBeginImageContext(newSize);
    
    [self.NewImageView.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    filenamethumb5= self.labelDrawController.text;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @"thumb5"];
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb5);
    
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:filenamethumb5];
    NSData* thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];
    
    ///------------Save big-size Image------------------------------------///////
    
    
    filenamebig5 = self.stringForLabel;
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @"big5"];
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @".png"];
    
    NSLog(@"Результат збереження великоиі картинки: %@.",filenamebig5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:filenamebig5];
    NSData* data = UIImagePNGRepresentation(self.NewImageView.image);
    [data writeToFile:path atomically:YES];
    
}



-(void)closeAndSave{//:(id)sender{
    NSLog(@"SAVEANDCLOSE----FUNC");
    [self saveColorsToDefaults];
    
 /*   if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale >= 2.0)) {
        [self saveImageRetina];
        // Retina display
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale < 2.0))
    {
        */[self saveImageRetina];
        // non-Retina display
       // [self saveImage];
        
    //}
    [self delegateImagesToEntryView];
}

-(void)delegateImagesToEntryView
{
    NSMutableString *filenamethumb = @"%@/";
    NSMutableString *prefix = self.stringForLabel;
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"thumb1"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb);
    
    NSMutableString *filenamethumb2 = @"%@/";
    NSMutableString *prefix2 = self.stringForLabel;
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: prefix2];
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: @"thumb2"];
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb2);
    
    NSMutableString *filenamethumb3 = @"%@/";
    NSMutableString *prefix3 = self.stringForLabel;
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: prefix3];
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: @"thumb3"];
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb3);
    
    NSMutableString *filenamethumb4 = @"%@/";
    NSMutableString *prefix4 = self.stringForLabel;
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: prefix4];
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: @"thumb4"];
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb4);
    
    
    NSMutableString *filenamethumb5 = @"%@/";
    NSMutableString *prefix5 =self.stringForLabel;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: prefix5];
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @"thumb5"];
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @".png"];
    NSLog(@"Результат: %@.",filenamethumb5);
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    NSString *filePath2 = [NSString stringWithFormat:filenamethumb2, docDirectory];
    UIImage *tempimage2 = [[UIImage alloc] initWithContentsOfFile:filePath2];
    
    NSString *filePath3 = [NSString stringWithFormat:filenamethumb3, docDirectory];
    UIImage *tempimage3 = [[UIImage alloc] initWithContentsOfFile:filePath3];
    
    NSString *filePath4 = [NSString stringWithFormat:filenamethumb4, docDirectory];
    UIImage *tempimage4 = [[UIImage alloc] initWithContentsOfFile:filePath4];
    
    NSString *filePath5 = [NSString stringWithFormat:filenamethumb5, docDirectory];
    UIImage *tempimage5 = [[UIImage alloc] initWithContentsOfFile:filePath5];
    
    
    
    self.imagethumb1 = tempimage;
    self.imagethumb2 = tempimage2;
    self.imagethumb3 = tempimage3;
    self.imagethumb4 = tempimage4;
    self.imagethumb5 = tempimage5;
    
    [self.backheadcontrollerdelegate passItemBackFromBack:self didFinishWithItem1:self.imagethumb1
                                         didFinishWithItem2:self.imagethumb2 didFinishWithItem3:self.imagethumb3 didFinishWithItem4:self.imagethumb4 didFinishWithItem5:self.imagethumb5];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadMainImage
{
    
    NSMutableString *filenamethumb = @"%@/";
    NSMutableString *prefix = self.stringForLabel;
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"big5"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
    NSLog(@"Результат завантаження файлу: %@.",filenamethumb);
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
    //UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    UIImage *tempimage = [UIImage imageWithContentsOfFile:filePath];
    self.NewImageView.image = tempimage;
    
}


- (void)updateButtonStatus
{
    self.undoBut.enabled = [self.drawingView canUndo];
    self.redoBut.enabled = [self.drawingView canRedo];
}

-(void)undo{
    NSLog(@"undo");
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}
-(void)redo{
    NSLog(@"redo");
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


//////////////////////////////////////////////////////////////////////

-(UIImage*)captureScreenForMail
{
    
self.previewImageView.layer.sublayers = nil;
    
    //[Flurry logEvent:@"Caprure_For_Mail"];
       [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        [self hideBar];
        self.previewImageView.layer.sublayers = nil;

        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self showBar];
        NSLog(@"Captured screen");
//        [self adGridToImgView];
        return img;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self hideBar];
        self.previewImageView.layer.sublayers = nil;

        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self showBar];
        NSLog(@"Captured screen");
//        [self adGridToImgView];
        return img;
    }
//   [self adGridToImgView];

}

-(UIImage*)captureRetinaScreenForMail
{
    [self.drawingView bringArrowsToFront];
    [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        [self hideBar];
        self.previewImageView.layer.sublayers = nil;
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self showBar];
//        [self adGridToImgView];
        return img;

    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self hideBar];
        self.previewImageView.layer.sublayers = nil;
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self showBar];
        NSLog(@"Captured screen");
//        [self adGridToImgView];
        return img;

    }
    
}
- (void)openShareMenu{
  
    NSString *textToShare;
    textToShare = [NSString stringWithFormat:@"HAIRTECH - HEAD SHEETS"];
    UIImage *imageToShare;
    imageToShare =  [self captureRetinaScreenForMail];
    NSMutableArray *itemsToShare = [NSMutableArray arrayWithObjects:textToShare, imageToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.listPopoverdraw1 = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        self.listPopoverdraw1.delegate = self;
        [self.listPopoverdraw1 presentPopoverFromRect:CGRectMake(685,60,10,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
       
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        
        [self presentViewController:activityViewController animated: YES completion: nil];
        
        UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(685,60,10,1);
    }
    
}


-(void)dismissPopoverDraw1
{
    
    [self.listPopoverdraw1 dismissPopoverAnimated:YES];
}
/*- (void)labelPositionMiddle {
 //CGRect labelPosition = self.labelDrawController.frame;
 NSLog(@"POSITION: %f", labelPosition.origin.x); // Returns 0.000000
 labelPosition.origin.x = 318;
 labelPosition.origin.y = 36;
 self.labelDrawController.frame = labelPosition;// Now moved to 50.000000
 
 }
 
 - (void)labelPositionLeft {
 // CGRect labelPosition = self.labelHairTech.frame;
 NSLog(@"POSITION: %f", labelPosition.origin.x); // Returns 0.000000
 labelPosition.origin.x = 60;
 labelPosition.origin.y = 23;
 
 self.labelHairTech.frame = labelPosition;  // Now moved to 50.000000
 }
 */




/*
-(void)hideBar
{
    UIColor *mycolor2 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
    // self.labelHairTech.alpha = 1.0;
    [self.colorBar1 setHidden:YES];
    [self.colorBar2 setHidden:YES];
    [self.colorBar3 setHidden:YES];
    [self.colorBar4 setHidden:YES];
    [self.colorBar5 setHidden:YES];

    [self.undoBut setHidden:YES];
    [self.redoBut setHidden:YES];
    [self.redbtn setHidden:YES];
    [self.bluebtn setHidden:YES];
    [self.blackbtn setHidden:YES];
    [self.lineButton setHidden:YES];
    [self.eraserbtn setHidden:YES];
    [self.textbtn setHidden:YES];
    [self.penbtn setHidden:YES];
    
    
    [self.imageView setHidden:YES];
    [self.imageToolbar1 setHidden:YES];
    [self.toolbarImg setHidden:YES];
    [self.toolbar setHidden:YES];
    //  self.labelHairTech.textColor = [UIColor darkGrayColor];
    self.labelDrawController.textColor = [UIColor blackColor];
    //[self labelPositionMiddle];
}
-(void)showBar

{
    UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
    
    [self.colorBar1 setHidden:NO];
    [self.colorBar2 setHidden:NO];
    [self.colorBar3 setHidden:NO];
    [self.colorBar4 setHidden:NO];
    [self.colorBar5 setHidden:NO];

    [self.undoBut setHidden:NO];
    [self.redoBut setHidden:NO];
    [self.redbtn setHidden:NO];
    [self.bluebtn setHidden:NO];
    [self.blackbtn setHidden:NO];
    [self.lineButton setHidden:NO];
    [self.eraserbtn setHidden:NO];
    [self.textbtn setHidden:NO];
    [self.penbtn setHidden:NO];
    
    [self.imageToolbar1 setHidden:NO];
    [self.imageView setHidden:NO];
    [self.toolbarImg setHidden:NO];
    [self.toolbar setHidden:NO];
    self.labelDrawController.textColor = [UIColor whiteColor];
    //    [self labelPositionLeft];
}
-(void)setButtonVisible
{
    
    [self.btn setEnabled:YES];
    [self.btn setHidden:NO];
    
    [self.penbtn setEnabled:NO];
    
    [self.blackbtn setEnabled:NO];
    [self.bluebtn setEnabled:NO];
    [self.redbtn setEnabled:NO];
    [self.lineButton setEnabled:NO];
    [self.eraserbtn setEnabled:NO];
    [self.textbtn setEnabled:NO];
    
    [self.undoBut setEnabled:NO];
    [self.redoBut setEnabled:NO];
    [self.baritem setEnabled:NO];
    [self.popoverBtn4 setEnabled:NO];
    
}
-(IBAction)buttonTouched:(id)sender
{
    if(self.drawingView.editMode ==YES && self.drawingView.touchesForEditMode == 0)
        
    {
        
        [self.btn setEnabled:NO];
        [self.btn setHidden:YES];
        
        [self.penbtn setEnabled:YES];
        
        [self.blackbtn setEnabled:YES];
        [self.bluebtn setEnabled:YES];
        [self.redbtn setEnabled:YES];
        [self.lineButton setEnabled:YES];
        [self.eraserbtn setEnabled:YES];
        [self.textbtn setEnabled:YES];
        
        [self.undoBut setEnabled:YES];
        [self.redoBut setEnabled:YES];
        [self.baritem setEnabled:YES];
        [self.popoverBtn4 setEnabled:YES];
        // self.lineColor = [UIColor redColor];
        self.drawingView.editMode = NO;
        
        
    }
    else{
        
        [self.btn setEnabled:NO];
        [self.btn setHidden:YES];
        
        [self.penbtn setEnabled:YES];
        
        [self.blackbtn setEnabled:YES];
        [self.bluebtn setEnabled:YES];
        [self.redbtn setEnabled:YES];
        [self.lineButton setEnabled:YES];
        [self.eraserbtn setEnabled:YES];
        [self.textbtn setEnabled:YES];
        
        [self.undoBut setEnabled:YES];
        [self.redoBut setEnabled:YES];
        [self.baritem setEnabled:YES];
        [self.popoverBtn4 setEnabled:YES];
        // self.lineColor = [UIColor redColor];
        self.drawingView.editMode = NO;
        [self.drawingView updateImage];
        self.drawingView.touchesForEditMode = 0;
    }
}


-(void)setButtonUNVisibleTextPressed
{
    [self.penbtn setEnabled:NO];
    [self.blackbtn setEnabled:NO];
    [self.bluebtn setEnabled:NO];
    [self.redbtn setEnabled:NO];
    [self.lineButton setEnabled:NO];
    [self.eraserbtn setEnabled:NO];
    // [self.textbtn setEnabled:NO];
    
    [self.undoBut setEnabled:NO];
    [self.redoBut setEnabled:NO];
    [self.baritem setEnabled:NO];
    [self.popoverBtn4 setEnabled:NO];
    
}

-(void)setButtonVisibleTextPressed
{
    [self.penbtn setEnabled:YES];
    [self.blackbtn setEnabled:YES];
    [self.bluebtn setEnabled:YES];
    [self.redbtn setEnabled:YES];
    [self.lineButton setEnabled:YES];
    [self.eraserbtn setEnabled:YES];
    // [self.textbtn setEnabled:NO];
    
    [self.undoBut setEnabled:YES];
    [self.redoBut setEnabled:YES];
    [self.baritem setEnabled:YES];
    [self.popoverBtn4 setEnabled:YES];
    [self.textbtn setSelected:NO];
}
*/





-(void)hideBar
{
    UIColor *mycolor2 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
   // self.labelHairTech.alpha = 1.0;
    [self.colorBar1 setHidden:YES];
    [self.colorBar2 setHidden:YES];
    [self.colorBar3 setHidden:YES];
    [self.colorBar4 setHidden:YES];
    [self.colorBar5 setHidden:YES];

    [self.undoBut setHidden:YES];
    [self.redoBut setHidden:YES];
    [self.redbtn setHidden:YES];
    [self.bluebtn setHidden:YES];
    [self.blackbtn setHidden:YES];
    [self.lineButton setHidden:YES];
    [self.eraserbtn setHidden:YES];
    [self.textbtn setHidden:YES];
    [self.penbtn setHidden:YES];


    [self.imageView setHidden:YES];
    [self.imageToolbar1 setHidden:YES];
    [self.toolbarImg setHidden:YES];
    [self.toolbar setHidden:YES];
  //  self.labelHairTech.textColor = [UIColor darkGrayColor];
    self.labelDrawController.textColor = [UIColor blackColor];
    //[self labelPositionMiddle];
}
-(void)showBar

{
    UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
    
    [self.colorBar1 setHidden:NO];
    [self.colorBar2 setHidden:NO];
    [self.colorBar3 setHidden:NO];
    [self.colorBar4 setHidden:NO];
    [self.colorBar5 setHidden:NO];

    [self.undoBut setHidden:NO];
    [self.redoBut setHidden:NO];
    [self.redbtn setHidden:NO];
    [self.bluebtn setHidden:NO];
    [self.blackbtn setHidden:NO];
    [self.lineButton setHidden:NO];
    [self.eraserbtn setHidden:NO];
    [self.textbtn setHidden:NO];
    [self.penbtn setHidden:NO];

    [self.imageToolbar1 setHidden:NO];
    [self.imageView setHidden:NO];
    [self.toolbarImg setHidden:NO];
    [self.toolbar setHidden:NO];
       self.labelDrawController.textColor = [UIColor whiteColor];
//    [self labelPositionLeft];
}
-(void)setButtonVisible
{
    
    [self.btn setEnabled:YES];
    [self.btn setHidden:NO];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    
        [self.btn setAlpha:1.0];
    [self.penbtn setAlpha:0.0];

    [self.blackbtn setAlpha:0.0];
    [self.bluebtn setAlpha:0.0];
    [self.redbtn setAlpha:0.0];
    [self.lineButton setAlpha:0.0];
    [self.eraserbtn setAlpha:0.0];
    [self.textbtn setAlpha:0.0];

    [self.undoBut setAlpha:0.0];
    [self.redoBut setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.baritem setEnabled:NO];
    [self.popoverBtn4 setEnabled:NO];
    
}
-(IBAction)buttonTouched:(id)sender
{
    if(self.drawingView.editMode ==YES && self.drawingView.touchesForEditMode == 0)
        
    {
        
        [self.btn setEnabled:NO];
        [self.btn setHidden:YES];
        
        [self.penbtn setEnabled:YES];

        [self.blackbtn setEnabled:YES];
        [self.bluebtn setEnabled:YES];
        [self.redbtn setEnabled:YES];
        [self.lineButton setEnabled:YES];
        [self.eraserbtn setEnabled:YES];
        [self.textbtn setEnabled:YES];

        [self.undoBut setEnabled:YES];
        [self.redoBut setEnabled:YES];
        [self.baritem setEnabled:YES];
        [self.popoverBtn4 setEnabled:YES];
        // self.lineColor = [UIColor redColor];
        self.drawingView.editMode = NO;
        
        
    }
    else{
        
        [self.btn setEnabled:NO];
        [self.btn setHidden:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.btn setAlpha:0.0];
            [self.penbtn setAlpha:1.0];
            
            [self.blackbtn setAlpha:1.0];
            [self.bluebtn setAlpha:1.0];
            [self.redbtn setAlpha:1.0];
            [self.lineButton setAlpha:1.0];
            [self.eraserbtn setAlpha:1.0];
            [self.textbtn setAlpha:1.0];
            
            [self.undoBut setAlpha:1.0];
            [self.redoBut setAlpha:1.0];
            
        } completion:^(BOOL finished) {
            
        }];
        [self.baritem setEnabled:YES];
        [self.popoverBtn4 setEnabled:YES];
        // self.lineColor = [UIColor redColor];
        self.drawingView.editMode = NO;
        [self.drawingView updateImage];
        self.drawingView.touchesForEditMode = 0;
    }
}


-(void)setButtonUNVisibleTextPressed
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    [self.penbtn setAlpha:0.0];
    [self.blackbtn setAlpha:0.0];
    [self.bluebtn setAlpha:0.0];
    [self.redbtn setAlpha:0.0];
    [self.lineButton setAlpha:0.0];
    [self.eraserbtn setAlpha:0.0];
    [self.textbtn setAlpha:0.0];
    
    [self.undoBut setAlpha:0.0];
    [self.redoBut setAlpha:0.0];
    [self.baritem setEnabled:NO];
    [self.popoverBtn4 setEnabled:NO];
    
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setButtonVisibleTextPressed
{
       [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
           
    [self.penbtn setAlpha:1.0];
    [self.blackbtn setAlpha:1.0];
    [self.bluebtn setAlpha:1.0];
    [self.redbtn setAlpha:1.0];
    [self.lineButton setAlpha:1.0];
    [self.eraserbtn setAlpha:1.0];
    [self.textbtn setAlpha:1.0];
    
    [self.undoBut setAlpha:1.0];
    [self.redoBut setAlpha:1.0];
    [self.baritem setEnabled:YES];
    [self.popoverBtn4 setEnabled:YES];
    [self.textbtn setSelected:NO];
           
       } completion:^(BOOL finished) {
           
       }];
    
    
}

-(void)adGridToImgView {
    
    
    self.numberOfRows = self.view.frame.size.height/12;
    self.numberOfColumns=self.view.frame.size.width/12;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.25);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    
    // calculate column width
    CGFloat columnWidth = self.view.frame.size.width / (self.numberOfColumns + 1.0);
    
    for(int i = 1; i <= self.numberOfColumns; i++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.view.frame.size.height;
        
        //CGFloat dashes[] = {1.5,12};
        
        
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        
        [path2 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path2 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        
        CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
        shapeLayer2.path = [path2 CGPath];
        shapeLayer2.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
        shapeLayer2.lineWidth = 0.25;
        shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
        
        [self.previewImageView.layer addSublayer:shapeLayer2];

    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    
    
    // calclulate row height
    CGFloat rowHeight = self.view.frame.size.height / (self.numberOfRows + 1.0);
    
    for(int j = 1; j <= self.numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.view.frame.size.width;
        endPoint.y = startPoint.y;
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    [path1 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    [path1 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = [path1 CGPath];
    shapeLayer1.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
    shapeLayer1.lineWidth = 0.25;

    shapeLayer1.fillColor = [[UIColor clearColor] CGColor];
    
    [self.previewImageView.layer addSublayer:shapeLayer1];
    }
    /*----------------------MEN HEADS END------------------------------*/

    
}
-(void)makeButtonSelected {
    for(int i=0; i< buttons.count; i++) {
        
        if(![[buttons objectAtIndex:i] isSelected]){
            UIButton *btn = [buttons objectAtIndex:i];
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
    contentTextView = [[ColorViewController alloc] initWithFrame:self.imageToolbar1.bounds isSelected:YES color:color currentTool:@"Pen tool"] ;
    contentTextView.center = self.imageToolbar1.center;
    //contentTextView.currentPenColor = color;
    textSetterState = YES;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
;
}

- (void)colorPopoverDidSelectTextColor:(NSString *)hexColor{
    NSLog(@"selected color for text");
    [self extractRGBforText:[GzColors colorFromHex:hexColor]];
    self.drawingView.lineColor = self.textExtract;
    self.textbtn.backgroundColor = self.textExtract;
    self.drawingView.textViewNew.textColor = self.textExtract;
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

- (UIButton*)fontButton:(NSString*)selector imageName1:(NSString*)imgName imageName2:(NSString*)imgName2 startX:(CGFloat)startX width:(CGFloat)btnWidth yAxe:(CGFloat)yAxe
{
    SEL selectorNew = NSSelectorFromString(selector);
     UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:selectorNew
     forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor orangeColor];
    button.adjustsImageWhenHighlighted = NO;
    UIImage *img = [UIImage imageNamed:imgName];
    [button setImage:img forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName2] forState:UIControlStateHighlighted];
    [button setTintColor:[UIColor lightGrayColor]];
    button.frame = CGRectMake(startX , 0 + yAxe, btnWidth, btnWidth);
    button.layer.cornerRadius = btnWidth / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
    button.layer.borderWidth = 0.0f;
    return button;
}
-(UILabel*)addInfoLabel:(NSString*)string startX:(CGFloat)startX font:(CGFloat)fntSize width:(CGFloat)width{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, width,50)];
    CGPoint newCenter = CGPointMake(startX + 5, self.imageToolbar1.frame.size.height / 2);
    label.center = newCenter;
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:fntSize];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = string;
    return label;
}

-(void)addInfoButtonOnToolbar{
    CGRect sizeRect = [UIScreen mainScreen].bounds;
    CGFloat screenPartitionIdx;
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
        iPadDist = 27;
    }
    originOfLabel = sizeRect.size.width / 2;
    self.infoLabel = [self addInfoLabel:@"Editing is disabled. You are in the view mode." startX:originOfLabel font:fntSize width:width];
    [self.imageToolbar1 addSubview:self.infoLabel];
    
    self.infoBtn =  [self fontButton:@"showInfoWindow:" imageName1:@"info_icon_new.png" imageName2:@"info_icon_new.png" startX:self.infoLabel.frame.origin.x - iPadDist width: 22 yAxe:15];
   [self.imageToolbar1 addSubview:self.infoBtn];
    
    
}
-(void)showInfoWindow:(UIButton*)button{
    NSLog(@"Showing info window");
}
@end
