
#import "DrawViewController.h"
#import "math.h"
#import "AppDelegate.h"
#import "ColorViewController.h"
//#import "ACEViewController.h"
#import "ACEDrawingView.h"
//#import "Flurry.h"

#define kActionSheetColor       100
#define kActionSheetTool        101

#define kOFFSET_FOR_KEYBOARD 200.0

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface DrawViewController()<ACEDrawingViewDelegate>
{

    NSMutableArray *arrayOfTechnique;
     NSMutableArray *arrayOfThumbs;
    sqlite3 *techniqueDB;
    NSString *dbPathString;
    NSString *convertedLabel;
    NSString * tempColorString;
    BOOL *tap;
    BOOL *firstTap1;
    BOOL *firstTap2;
    BOOL *firstTap3;
    BOOL *firstTap4;
    BOOL *firstTap5;
    
    




}
@end

@implementation DrawViewController




@synthesize popoverController;
@synthesize mainImage;
@synthesize tempDrawImage;
@synthesize middleImg;
@synthesize loadImg;
@synthesize blackbtn;
@synthesize bluebtn;
@synthesize redbtn;
@synthesize eraserbtn;
@synthesize lineButton;
@synthesize labelDrawController;
@synthesize textbtn;
@synthesize penbtn;

/*@synthesize brush;
@synthesize opacity;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize redconv;
@synthesize greenconv;
@synthesize blueconv;
*/







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

#pragma mark -didRecieveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(void)loadMainImage
{
    


    NSMutableString *filenamethumb = @"%@/";
    NSMutableString *prefix = self.stringForLabel;
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"big1"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
    NSLog(@"Результат завантаження файлу: %@.",filenamethumb);
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
    
 //  UIImage *tempimage = [UIImage initWithContentsOfFile:filePath];
    // UIImage *tempimage = [UIImage imageWithContentsOfFile:filePath];
    NSData *data1 = [NSData dataWithContentsOfFile:filePath];
    UIImage *tempimage = [UIImage imageWithData:data1];
    self.NewImageView.image = tempimage;
  //self.NewImageView.alpha = 1;
   // [self.drawingView getScreenShot:tempimage];
    tempimage = nil;


}


-(void)saveColorsToDefaults{
    
    

    const CGFloat  *components2 = CGColorGetComponents(self.blueExtract.CGColor);
    const CGFloat  *components3 = CGColorGetComponents(self.redExtract.CGColor);
    const CGFloat  *components4 = CGColorGetComponents(self.lineExtract.CGColor);
    const CGFloat  *components5 = CGColorGetComponents(self.blackExtract.CGColor);
    const CGFloat  *components6 = CGColorGetComponents(self.penExtract.CGColor);

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
    NSLog(@"I just saved colors");
    
    
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

    
    
    NSLog(@"I have extracted colors");
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextView *)textView
{
return YES;
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

-(void)setupButtons
{
    redbtn.layer.cornerRadius = 25.0;
    redbtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    redbtn.layer.shadowOpacity = 0.5;
    redbtn.layer.shadowRadius = 2;
    redbtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    redbtn.backgroundColor = self.redExtract;
    
    lineButton.layer.cornerRadius = 25.0;
    lineButton.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    lineButton.layer.shadowOpacity = 0.5;
    lineButton.layer.shadowRadius = 2;
    lineButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    lineButton.backgroundColor = self.lineExtract;
    
    bluebtn.layer.cornerRadius = 25.0;
    bluebtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    bluebtn.layer.shadowOpacity = 0.5;
    bluebtn.layer.shadowRadius = 2;
    bluebtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    bluebtn.backgroundColor = self.blueExtract;
    
    penbtn.layer.cornerRadius = 25.0;
    penbtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    penbtn.layer.shadowOpacity = 0.5;
    penbtn.layer.shadowRadius = 2;
    penbtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    penbtn.backgroundColor = self.penExtract;
    
    blackbtn.layer.cornerRadius = 25.0;
    blackbtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    blackbtn.layer.shadowOpacity = 0.5;
    blackbtn.layer.shadowRadius = 2;
    blackbtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    blackbtn.backgroundColor = self.blackExtract;
    
    eraserbtn.layer.cornerRadius = 25.0;
    eraserbtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    eraserbtn.layer.shadowOpacity = 0.5;
    eraserbtn.layer.shadowRadius = 2;
    eraserbtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
   self.btn.layer.cornerRadius = 25.0;
    self.btn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    self.btn.layer.shadowOpacity = 0.5;
    self.btn.layer.shadowRadius = 2;
    self.btn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.btn.layer.cornerRadius = 25.0;
    
    textbtn.layer.cornerRadius = 25.0;
    textbtn.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    textbtn.layer.shadowOpacity = 0.5;
    textbtn.layer.shadowRadius = 2;
    textbtn.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    self.undoBut.layer.cornerRadius = 19.0;
    self.undoBut.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
    self.undoBut.layer.shadowOpacity = 0.5;
    self.undoBut.layer.shadowRadius = 2;
    self.undoBut.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
     self.redoBut.layer.cornerRadius = 19.0;
    self.redoBut.layer.shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
     self.redoBut.layer.shadowOpacity = 0.5;
     self.redoBut.layer.shadowRadius = 2;
   self.redoBut.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

//
//-(void)addTextViewToDrawingView{
//
//    CGRect rectOrigin = CGRectMake(0,0,100,24);
//    [self.drawingView addTextViewToRect:rectOrigin];
//    [self.drawingView.textViewNew setHidden:YES];
//}
//-(void)makeTextViewVisible {
//
//    [self.drawingView.textViewNew setHidden:NO];
//    [self.drawingView addJVDTextView];
//
//}

-(void)viewDidLoad{
    
   
   // [self addTextViewToDrawingView];
        
    
    [self LoadColorsAtStart];
    [self setupButtons];
    
    [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
    
    self.drawingView.viewControllerName = @"left";
   

    [super viewDidLoad];
    
    
    
    
    [self.drawingView getViewControllerId:[self restorationIdentifier] nameOfTechnique: self.stringForLabel];

    
   
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"GLOBALDATE %@", appDelegate.globalDate);
    
    //appDelegate.currentViewName = @"left";
   
    
    if((![appDelegate.globalDate isEqualToString:@"new_version"])||(![appDelegate.globalDate isEqualToString:@"men_heads"]))
    {
        [self.NewImageView setImage:[UIImage imageNamed:@"View_lefthead_created.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"View_lefthead_created_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"View_lefthead_created_tr.png"]];
        
        

    }
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
        if (((screenHeight==736)&&[appDelegate.globalDate isEqualToString:@"new_version"])||((screenHeight==568)&&[appDelegate.globalDate isEqualToString:@"new_version"])||((screenHeight==667)&&[appDelegate.globalDate isEqualToString:@"new_version"]))
        {
        
        //[self.NewImageView setImage:[UIImage imageNamed:@"iphone7plus.png"]];
            [self.NewImageView setImage:[UIImage imageNamed:@"left_7p_tr.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"left_7p_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"left_7p_tr.png"]];
    }
    
    if (((screenHeight==1024)&&[appDelegate.globalDate isEqualToString:@"new_version"])||
       ((screenHeight==1366)&&[appDelegate.globalDate isEqualToString:@"new_version"])||
       ((screenHeight==834)&&[appDelegate.globalDate isEqualToString:@"new_version"])){
        
        [self.NewImageView setImage:[UIImage imageNamed:@"ipad_left.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"ipad_left_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"ipad_left_tr.png"]];
        
    }
    if ((screenHeight==812)&&[appDelegate.globalDate isEqualToString:@"new_version"])
    {
        
        [self.NewImageView setImage:[UIImage imageNamed:@"x_left.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"x_left_tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"x_left_tr.png"]];
    }
    
    /*----------------------MEN HEADS------------------------------*/
    
    
     if (((screenHeight==736)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||((screenHeight==568)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||((screenHeight==667)&&[appDelegate.globalDate isEqualToString:@"men_heads"]))
        {
        
        //[self.NewImageView setImage:[UIImage imageNamed:@"iphone7plus.png"]];
[self.NewImageView setImage:[UIImage imageNamed:@"men-iphone7-left.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"men-iphone7-left-tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"men-iphone7-left-tr.png"]];
    }
    
    if (((screenHeight==1024)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||
       ((screenHeight==1366)&&[appDelegate.globalDate isEqualToString:@"men_heads"])||
       ((screenHeight==834)&&[appDelegate.globalDate isEqualToString:@"men_heads"])){
        
        [self.NewImageView setImage:[UIImage imageNamed:@"men-ipad-left.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"men-ipad-left-tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"men-ipad-left-tr.png"]];
        
    }
    if ((screenHeight==812)&&[appDelegate.globalDate isEqualToString:@"men_heads"])
    {
        
        [self.NewImageView setImage:[UIImage imageNamed:@"men-left-11.png"]];
        [self.middleImg setImage:[UIImage imageNamed:@"men-left-11-tr.png"]];
        [self.previewImageView setImage:[UIImage imageNamed:@"men-left-11-tr.png"]];
    }
    
    
    

    
    
    
    
    [self adGridToImgView];
    
    
    
    
    
    
    
    self.navigationItem.title=self.stringFromVC;
    
  //  [self.navigationController.navigationBar
 //    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
     UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(setColorButtonTapped:)];
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(reset:)];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:resetButton, actionButton, nil]];
    
  //[KGStatusBar showWithStatus:@""];
 
    [self.toolbar setClipsToBounds:YES];
    
    UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
    //self.toolbar.backgroundColor = mycolor2;

        UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.drawingView action:@selector(handlePan:)];
        
        recognizer.delegate = self;
        //[textview addGestureRecognizer:recognizer];
    
        [self.drawingView.textViewNew addGestureRecognizer:recognizer];
    


     /////////////////
     
   // [self.drawingView.textView setHidden:YES];
    
        //////////////////
    self.drawingView.delegate = self;
    //self.drawingView.textViewNew.delegate = self;

    
       lineButton.selected = YES;

    UIColor *color = self.lineExtract;
    

    
    self.drawingView.editMode = NO;
    self.drawingView.editModeforText = NO;
    self.drawingView.touchForText=0;
    
   [self.btn setEnabled:NO];
   [self.btn setHidden:YES];
    
    //self.drawingView.drawTool = ACEDrawingToolTypeLine;
    
    self.drawingView.type = JVDrawingTypeLine;
    self.drawingView.bufferType = JVDrawingTypeLine;
    self.drawingView.lineColor = self.lineExtract;
    
    self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];


    penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    lineButton.backgroundColor = self.lineExtract;
    
    
    
  
 //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImage) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageRetina) name:UIApplicationWillTerminateNotification object:nil];
    
 
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveColorsToDefaults) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveColorsToDefaults) name:UIApplicationWillTerminateNotification object:nil];
    
    tap=NO;
    firstTap1=NO;
    firstTap2=NO;

    

   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(closeAndSave:)];
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
    
    //////////----------------------------------
    longpresspenbtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandlerPen:)];
    longpresspenbtn .minimumPressDuration = 0.2;
    
    [penbtn addGestureRecognizer:longpresspenbtn];

    
  
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.7;
    scrollView.maximumZoomScale = 5.0;
    scrollView.contentSize = self.viewForImg.frame.size;

    NSLog(@"page width = %f", screenRect.size.width);
    NSLog(@"page height = %f", screenRect.size.height);
    
    
    
    
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
    
}




-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
   // [self.drawingView updateZoomFactor:scrollView.zoomScale];
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
    
    // [pinchGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.viewForImg;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
}




-(void)viewWillDisappear:(BOOL)animated
{
    
    
    
    [super viewWillDisappear:YES];
    if(actionSheet1.visible){
        [actionSheet1 dismissWithClickedButtonIndex:-1 animated:YES];
    }
    
    [self closeAndSave];
    
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [self setMiddleImg:nil];
    [self setLoadImg:nil];
    [self setBlackbtn:nil];
    [self setBluebtn:nil];
    [self setRedbtn:nil];
    [self setEraserbtn:nil];
    [self setBlackbtn:nil];
    [self setPenbtn:nil];
    [self setLabelDrawController:nil];
    [self setNewImageView:nil];
    data = nil;
    thumbdata = nil;
    
    
}
-(void)dealloc{
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}



-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"GLOBALDATE %@", appDelegate.globalDate);
    
    appDelegate.currentViewName = @"left";
   

    
    
    [self loadMainImage];
 
    NSLog(@"DRAWCONTROLLER VIEWWILLAPEAR");

    [super viewWillAppear:YES];

    
    
   // [self loadMainImage];
  
    self.labelDrawController.text = self.stringForLabel;
    
    NSLog(@"The LabelDrawController = %@",self.stringForLabel);
    
     dashLineCount=0;
}


- (void)viewDidUnload
{

    
    
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [self setMiddleImg:nil];
    [self setLoadImg:nil];
    [self setBlackbtn:nil];
    [self setBluebtn:nil];
    [self setRedbtn:nil];
    [self setEraserbtn:nil];
    [self setBlackbtn:nil];
    [self setPenbtn:nil];
    [self setLabelDrawController:nil];
    [self setNewImageView:nil];
    data = nil;
    thumbdata = nil;
    
    [super viewDidUnload];
   
    
    // Release any retained subviews of the main view.
}
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
    //The popover is automatically dismissed if you click outside it, unless you return NO here
    return YES;
}
- (void)longPressHandlerPen:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"Longpress PEN");
    
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:5]];

    
        penbtn.selected = YES;
        blackbtn.selected=NO;
        bluebtn.selected=NO;
        redbtn.selected=NO;
        eraserbtn.selected=NO;
        lineButton.selected=NO;
        
        [self addShadowToButton];

        [longpresspenbtn setDelaysTouchesBegan:YES];

        
        if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
        {
            
            ColorViewController *contentViewController = [[ColorViewController alloc] init];
            contentViewController.delegate = self;
            
            contentViewController.currentPenColor = self.penExtract;
            
            self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromRect:CGRectMake(penbtn.frame.origin.x,penbtn.frame.origin.y,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        else if
            (gestureRecognizer.state==UIGestureRecognizerStateEnded)
        {
         
        }
        penbtn.selected = YES;
        
        
    

    //[self saveColorsToDefaults];
    
    //[self saveCurrentToolToUserDeafaults:5.0 forKey:@"currentTool"];

}



- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:0]];

    NSLog(@"Long press");
    penbtn.selected = NO;
    blackbtn.selected=YES;
    bluebtn.selected=NO;
    redbtn.selected=NO;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    
    longpressblackbtn .minimumPressDuration = 0.2;
   
    [longpressblackbtn setDelaysTouchesBegan:YES];
    [self addShadowToButton];

    
    
    
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        
        ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
        
        contentViewController.currentPenColor = self.blackExtract;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        
      
        [self.popoverController presentPopoverFromRect:CGRectMake(blackbtn.frame.origin.x,blackbtn.frame.origin.y,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
    {
       

    }
    blackbtn.selected=YES;
    
   // [self pencilPressed:[self.view viewWithTag:0]];
    //[self saveColorsToDefaults];

   // [self saveCurrentToolToUserDeafaults:0.0 forKey:@"currentTool"];

    
}
- (void)longPressHandlerBlue:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    

    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:1]];

    
    NSLog(@"Long press");
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=YES;
    redbtn.selected=NO;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    longpressbluebtn .minimumPressDuration = 0.2;
    [longpressbluebtn setDelaysTouchesBegan:YES];
  
    [self addShadowToButton];

    
     
    
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {

        ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.blueExtract;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        
      
        [self.popoverController presentPopoverFromRect:CGRectMake(bluebtn.frame.origin.x,bluebtn.frame.origin.y,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    
        

    bluebtn.selected=YES;
   // [self pencilPressed:[self.view viewWithTag:1]];
   // [self saveColorsToDefaults];

   // [self saveCurrentToolToUserDeafaults:1.0 forKey:@"currentTool"];

    
}
- (void)longPressHandlerRed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    [self saveColorsToDefaults];
    [self pencilPressed:[self.view viewWithTag:2]];


    NSLog(@"Long press");
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=NO;
    redbtn.selected=YES;
    eraserbtn.selected=NO;
    lineButton.selected=NO;
    
    longpressredbtn .minimumPressDuration = 0.2;
    //longpressbluebtn .minimumPressDuration = 0.2;
    
    [self addShadowToButton];

    
    
    
    
    [longpressredbtn setDelaysTouchesBegan:YES];
    
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        
        ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
        contentViewController.currentPenColor = self.redExtract;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        
      
        [self.popoverController presentPopoverFromRect:CGRectMake(redbtn.frame.origin.x,redbtn.frame.origin.y,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
    
 //   [self saveColorsToDefaults];

  //  [self saveCurrentToolToUserDeafaults:2.0 forKey:@"currentTool"];

    redbtn.selected=YES;
    
    //[self.drawcontrollerdelegate currentColor:self.redExtract];
    
}

- (void)longPressHandlerLine:(UILongPressGestureRecognizer *)gestureRecognizer {
   
    [self saveColorsToDefaults];

    [self pencilPressed:[self.view viewWithTag:3]];

    
    NSLog(@"Long press");
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
    
    [self addShadowToButton];

    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        
        ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
        
        contentViewController.currentPenColor = self.lineExtract;

        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popoverController.delegate = self;
        
       
        [self.popoverController presentPopoverFromRect:CGRectMake(lineButton.frame.origin.x,lineButton.frame.origin.y,0,0 ) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
  //  [self saveColorsToDefaults];

  //  [self saveCurrentToolToUserDeafaults:3.0 forKey:@"currentTool"];

    lineButton.selected=YES;
    
}
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
    self.blueExtract=tempcolor;
    
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
    self.blackExtract=tempcolor;
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
    self.lineExtract=tempcolor;
    red_line =redtemp4;
    green_line=greentemp4;
    blue_line=bluetemp4;
    alpha_line=1.0;
    opacity=1.0;
    brush_line=3.0;
    NSLog(@"Color was extracted");
    
    
}
-(NSString *)UIColorToHexStringWithRed:(CGFloat*)myred green:(CGFloat*)mygreen blue:(CGFloat*)myblue  alpha:(CGFloat*)myalpha{
    
    
    NSString *hexString  = [NSString stringWithFormat:@"#%02x%02x%02x%02x",
                            ((int)alpha),((int)red),((int)green),((int)blue)];
    return hexString;
}

-(void) colorPopoverControllerDidSelectColor:(NSString *)hexColor {
    if(penbtn.selected==YES){
        
        
        [self extractRGBforPen:[GzColors colorFromHex:hexColor]];
        
        self.drawingView.drawTool = ACEDrawingToolTypePen;
        self.drawingView.lineColor = self.penExtract;
        
        [self.colorBar5 setTextColor:self.penExtract];
        self.penbtn.backgroundColor = self.penExtract;
        
       
        blackbtn.backgroundColor=[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        
        
        //  blackbtn.layer.borderColor = [[GzColors colorFromHex:hexColor]CGColor];
        
        //    [self.drawcontrollerRightdelegate selectedBtn:hexColor];
        
        [self.view setNeedsDisplay];
        
        [penbtn addGestureRecognizer:longpresspenbtn];
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        
        
       // [self.drawcontrollerdelegate selectedBtn:hexColor];
        
        
        
    }
    
    
    if(    blackbtn.selected==YES){
        [self extractRGBforBlack:[GzColors colorFromHex:hexColor]];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(dashLineCount % 2 == 0){
            
            self.drawingView.drawTool = ACEDrawingToolTypeCurve;
            self.drawingView.lineColor = self.blackExtract;
            self.blackbtn.backgroundColor = self.blackExtract;
            [blackbtn setImage: [UIImage imageNamed:@"curve_solid.png"] forState:UIControlStateSelected];
            
            
    
            
            appDelegate.dashedCurve = YES;
        }
        else{
            self.drawingView.drawTool = ACEDrawingToolTypeDashCurve;
            self.drawingView.lineColor = self.blackExtract;
            self.blackbtn.backgroundColor = self.blackExtract;
            
            [blackbtn setImage: [UIImage imageNamed:@"curve_dash.png"] forState:UIControlStateSelected];
            
            
            
            appDelegate.dashedCurve = NO;
        }
        
        [self.colorBar1 setTextColor:self.blackExtract];
        self.penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        
        
        [self.view setNeedsDisplay];

        [penbtn addGestureRecognizer:longpresspenbtn];
        
        [blackbtn addGestureRecognizer:longpressblackbtn];
        [bluebtn addGestureRecognizer:longpressbluebtn];
        [redbtn addGestureRecognizer:longpressredbtn];
        [lineButton addGestureRecognizer:longpresslinebtn];
        
        
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    
    if(bluebtn.selected==YES){
        [self extractRGBforBlue:[GzColors colorFromHex:hexColor]];
        self.drawingView.drawTool = ACEDrawingToolTypeDashLine;
        
        self.drawingView.lineColor = self.blueExtract;
        
        [self.colorBar2 setTextColor:self.blueExtract];
        
         self.bluebtn.backgroundColor = self.blueExtract;
        blackbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        self.penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        
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
        
        bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        blackbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
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
        
        bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        blackbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        
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

-(void) saveCurrentToolToUserDeafaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float) loadCurrentToolFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}


- (IBAction)pencilPressed:(id)sender {
    
    [self.popTipLine hide];
    [self.popTipCurve hide];
    UIButton * PressedButton = (UIButton*)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch(PressedButton.tag)
    {
        case 0:
            dashLineCount=dashLineCount+1;
            blackbtn.selected=YES;
            penbtn.selected = NO;
            bluebtn.selected=NO;
            redbtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=NO;
            textbtn.selected = NO;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];
    
            blackbtn.backgroundColor=self.blackExtract;
            penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
         
            [self saveCurrentToolToUserDeafaults:0.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            if(dashLineCount % 2 == 0){
                self.drawingView.type = JVDrawingTypeCurvedDashLine;
                self.drawingView.bufferType = JVDrawingTypeCurvedDashLine;
                self.drawingView.lineColor = self.blackExtract;
                [blackbtn setImage: [UIImage imageNamed:@"curve_dash.png"] forState:UIControlStateSelected];
                appDelegate.dashedCurve = YES;
                [self.drawingView removeCirclesOnZoomDelegate];
            }
            else{
                self.drawingView.type = JVDrawingTypeCurvedLine;
                self.drawingView.bufferType = JVDrawingTypeCurvedLine;
                self.drawingView.lineColor = self.blackExtract;
                [blackbtn setImage: [UIImage imageNamed:@"curve_solid.png"] forState:UIControlStateSelected];
                appDelegate.dashedCurve = NO;
                [self.drawingView removeCirclesOnZoomDelegate];
            }
            break;
        case 1:
           dashLineCount = 0;
            bluebtn.selected=YES;
            penbtn.selected = NO;
            blackbtn.selected=NO;
            redbtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=NO;
            textbtn.selected = NO;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];

            penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = self.blueExtract;
            redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            
            self.drawingView.type = JVDrawingTypeDashedLine;
            self.drawingView.bufferType = JVDrawingTypeDashedLine;
            self.drawingView.lineColor = self.blueExtract;
            [self saveCurrentToolToUserDeafaults:1.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];

            break;
        case 2:
            dashLineCount = 0;
            redbtn.selected=YES;
            penbtn.selected = NO;
            blackbtn.selected=NO;
            bluebtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=NO;
            textbtn.selected = NO;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];
            
            penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            blackbtn.backgroundColor=[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            redbtn.backgroundColor = self.redExtract;
            lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
                    
            self.drawingView.type = JVDrawingTypeArrow;
            self.drawingView.bufferType = JVDrawingTypeArrow;
            self.drawingView.lineColor = self.redExtract;
            [self saveCurrentToolToUserDeafaults:2.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
        case 3:
            dashLineCount = 0;
            penbtn.selected = NO;
            blackbtn.selected=NO;
            bluebtn.selected=NO;
            redbtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=YES;
            textbtn.selected = NO;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];

            penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            lineButton.backgroundColor = self.lineExtract;
            self.drawingView.type = JVDrawingTypeLine;
            self.drawingView.bufferType = JVDrawingTypeLine;
            self.drawingView.lineColor = self.lineExtract;
            [self saveCurrentToolToUserDeafaults:3.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];
            
            break;
        case 4:
            dashLineCount = 0;
            penbtn.selected = NO;
            blackbtn.selected=NO;
            bluebtn.selected=NO;
            redbtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=NO;
            textbtn.selected = YES;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];
            
            penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            self.drawingView.type = JVDrawingTypeText;
            self.drawingView.bufferType = JVDrawingTypeText;
            self.drawingView.lineColor = [UIColor blackColor];
            [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,
                                              self.drawingView.bounds.origin.y,
                                              self.drawingView.bounds.size.width,
                                              self.drawingView.bounds.size.height) animated:YES];
            [self.drawingView addFrameForTextView];
            self.drawingView.textViewNew.delegate = self;

            //[self setButtonUNVisibleTextPressed];
            break;
        case 5:
            dashLineCount = 0;
            penbtn.selected = YES;
            blackbtn.selected=NO;
            bluebtn.selected=NO;
            redbtn.selected=NO;
            eraserbtn.selected=NO;
            lineButton.selected=NO;
            textbtn.selected = NO;
            self.drawingView.eraserSelected = NO;
            [self addShadowToButton];

            penbtn.backgroundColor = self.penExtract;
            blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            
            self.drawingView.type = JVDrawingTypeGraffiti;
            self.drawingView.bufferType = JVDrawingTypeGraffiti;
            self.drawingView.lineColor = self.penExtract;
            [self saveCurrentToolToUserDeafaults:5.0 forKey:@"currentTool"];
            self.drawingView.lineWidth = [self loadFloatFromUserDefaultsForKey:@"lineWidth"];
            [self.drawingView removeCirclesOnZoomDelegate];

            break;
    }
    

}
- (IBAction)eraserPressed:(id)sender {
    
    [self saveFloatToUserDefaults:1.0 forKey:@"eraserPressed"];
    
    dashLineCount = 0;
    penbtn.selected = NO;
    blackbtn.selected=NO;
    bluebtn.selected=NO;
    redbtn.selected=NO;
    eraserbtn.selected=YES;
    lineButton.selected=NO;
    textbtn.selected = NO;
    self.drawingView.eraserSelected = YES;
    [self addShadowToButton];
    
    penbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    blackbtn.backgroundColor =[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    bluebtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    redbtn.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    lineButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    
    self.drawingView.lineColor = [UIColor whiteColor];
    self.drawingView.lineWidth = 30.0;
}

- (IBAction)reset:(id)sender {
    if (actionSheet1) {
        [actionSheet1 dismissWithClickedButtonIndex:-1 animated:YES];
        actionSheet1 = nil;
        return;
    }
    actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear Page" otherButtonTitles:nil, nil];
    actionSheet1.delegate = self;
   [actionSheet1 showFromBarButtonItem:sender animated:YES];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
       
        [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
        // Do the delete
        self.NewImageView.image = nil;
        [self.drawingView clear];
        self.drawingView.backgroundColor =[UIColor clearColor];
       
        [self updateButtonStatus];
               //[self saveImage];
     // [Flurry logEvent:@"Clear_Screen_Pressed"];

        
    }
    else{
        actionSheet1 = nil;
    }
}



- (void)saveImage{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.checkHead1=1;
  
     UIGraphicsBeginImageContext(self.drawingView.frame.size);
     [self.NewImageView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.NewImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
     [self.drawingView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.middleImg.image drawInRect:CGRectMake(0, 0, self.middleImg.frame.size.width, self.middleImg.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
     self.NewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
   
   // [self.NewImageView performSelectorInBackground:@selector(setImage:) withObject:UIGraphicsGetImageFromCurrentImageContext()];

    UIGraphicsEndImageContext();
    



     CGSize newSize = CGSizeMake(256, 334);
     UIGraphicsBeginImageContext(newSize);
 
   [self.NewImageView.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     
    filenamethumb1 = self.navigationItem.title;
     filenamethumb1 = [filenamethumb1 mutableCopy];
     [filenamethumb1 appendString: @"thumb1"];
     filenamethumb1 = [filenamethumb1 mutableCopy];
     [filenamethumb1 appendString: @".png"];
     NSLog(@"Результат: %@.",filenamethumb1);
     
     NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
     NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
     NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:filenamethumb1];
     NSData* thumbdata = UIImagePNGRepresentation(newImage);
     [thumbdata writeToFile:thumbpath atomically:YES];
     
     ///------------Save big-size Image------------------------------------///////
     
     
    filenamebig1 = self.navigationItem.title;
     filenamebig1 = [filenamebig1 mutableCopy];
     [filenamebig1 appendString: @"big1"];
     filenamebig1 = [filenamebig1 mutableCopy];
     [filenamebig1 appendString: @".png"];
     
     NSLog(@"Результат збереження великоиі картинки: %@.",filenamebig1);
     
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString* path = [documentsDirectory stringByAppendingPathComponent:filenamebig1];
     NSData* data = UIImagePNGRepresentation(self.NewImageView.image);
     [data writeToFile:path atomically:YES];

    
    
        }


+ (UIImage * )imageWithView:(UIView *)view
{
    
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}




- (void)saveImageRetina{
   
     
    
    NSLog(@"DEALLOC 1");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.checkHead1=1;
    UIGraphicsBeginImageContextWithOptions(self.drawingView.frame.size, NO, 0.0);
    [self.NewImageView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.NewImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawingView.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.middleImg.image drawInRect:CGRectMake(0, 0, self.middleImg.frame.size.width, self.middleImg.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    self.NewImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
   CGSize newSize = CGSizeMake(512, 668);
    
   // CGSize newSize = CGSizeMake(screenWidth/2, screenHeight/2);
    UIGraphicsBeginImageContext(newSize);
    
    [self.NewImageView.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    filenamethumb1 = self.labelDrawController.text;
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @"thumb1"];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @".png"];
    NSLog(@"РезультатDrawViewCtrl thumb 1 : %@.",filenamethumb1);
    
   NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:filenamethumb1];
    thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];

    
    
    
    ///------------Save big-size Image------------------------------------///////
    
    
    filenamebig1 = self.labelDrawController.text;
    filenamebig1 = [filenamebig1 mutableCopy];
    [filenamebig1 appendString: @"big1"];
    filenamebig1 = [filenamebig1 mutableCopy];
    [filenamebig1 appendString: @".png"];
    

    NSLog(@"Результат збереження великоиі картинки: %@.",filenamebig1);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:filenamebig1];
    data = UIImagePNGRepresentation(self.NewImageView.image);
    [data writeToFile:path atomically:YES];
    
    

}


-(void)closeAndSave{//:(id)sender{
    
    
     [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    
    NSLog(@"SAVEANDCLOSE----FUNC");
                [self saveColorsToDefaults];

       /* if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale >= 2.0)) {
            [self saveImageRetina];
            // Retina display
        }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale < 2.0))
    {*/
        [self saveImageRetina];
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

    [self.drawcontrollerdelegate passItemBack:self didFinishWithItem1:self.imagethumb1
                           didFinishWithItem2:self.imagethumb2 didFinishWithItem3:self.imagethumb3 didFinishWithItem4:self.imagethumb4 didFinishWithItem5:self.imagethumb5];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentView = @"none";
    
    
    }
- (IBAction)closeActionSheet:(id)sender {
    
    actionSheet1 = nil;
}
- (void)updateButtonStatus
{
    [self.undoBut setEnabled: [self.drawingView canUndo]];
    [self.redoBut setEnabled: [self.drawingView canRedo]];
}

- (IBAction)UndoButton:(id)sender {
    
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}



- (IBAction)RedoButton:(id)sender {
    
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


///////////////////////////////////////////////////////////////////////

-(UIImage*)captureScreenForMail
{
    
self.previewImageView.layer.sublayers = nil;
    
    //[Flurry logEvent:@"Caprure_For_Mail"];
       [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.hideBar;
        self.previewImageView.layer.sublayers = nil;

        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.showBar;
        NSLog(@"Captured screen");
        [self adGridToImgView];
        return img;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        self.hideBar;
        self.previewImageView.layer.sublayers = nil;

        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.showBar;
        NSLog(@"Captured screen");
        [self adGridToImgView];
        return img;
    }
   [self adGridToImgView];

}

-(UIImage*)captureRetinaScreenForMail
{

       // self.previewImageView.layer.sublayers = nil;

        [scrollView zoomToRect:CGRectMake(self.drawingView.bounds.origin.x,self.drawingView.bounds.origin.y,self.drawingView.bounds.size.width,self.drawingView.bounds.size.height) animated:YES];
    
    //[Flurry logEvent:@"Caprure_Retina_For_Mail"];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.hideBar;
        self.previewImageView.layer.sublayers = nil;
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.showBar;
        [self adGridToImgView];
        return img;

    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        self.hideBar;
        self.previewImageView.layer.sublayers = nil;
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.showBar;
        NSLog(@"Captured screen");
        [self adGridToImgView];
        return img;

    }
    
}


- (IBAction)setColorButtonTapped:(id)sender{

   // if(self.drawingView.editMode ==YES)
   // {
     //   [self performSelector:@selector(buttonTouched:)];
    
   // }
    NSString *textToShare;
    
    
    textToShare = [NSString stringWithFormat:@"HAIRTECH - HEAD SHEETS"];
    // NSString *        textToShare2 = [NSString stringWithFormat:@"fb://profile/230787750393258"];
    
    UIImage *imageToShare;
    /*if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        imageToShare =  [self captureRetinaScreenForMail];
    }
    else
    {
        imageToShare = [self captureScreenForMail];
    }*/
    
    imageToShare =  [self captureRetinaScreenForMail];
    
   // NSArray *itemsToShare = @[textToShare, imageToShare];
    
     NSMutableArray *itemsToShare = [NSMutableArray arrayWithObjects:textToShare, imageToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
    
    
    
    
   /*
    self.listPopoverdraw1 = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    self.listPopoverdraw1.delegate = self;
    
    [self.listPopoverdraw1 presentPopoverFromRect:CGRectMake(685,60,10,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    */
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        // code here
        
        
        self.listPopoverdraw1 = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        self.listPopoverdraw1.delegate = self;
        
        [self.listPopoverdraw1 presentPopoverFromRect:CGRectMake(685,60,10,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        
    }
    
    
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        // code here
        
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        //activityViewController.preferredContentSize = CGSizeMake(400, 400);
        
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
    [self.popoverBtn setEnabled:NO];
    
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
        [self.popoverBtn setEnabled:YES];
        
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
        [self.popoverBtn setEnabled:YES];
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
    [self.popoverBtn setEnabled:NO];
    
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
    [self.popoverBtn setEnabled:YES];
    [self.textbtn setSelected:NO];
           
       } completion:^(BOOL finished) {
           
       }];
}



-(void)adGridToImgView{
    
    NSLog(@"ADD GRID TO VIEW");
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


-(void)addShadowToButton
{

    for(int i=0; i< buttons.count; i++) {
        
        if([[buttons objectAtIndex:i] isSelected]){
      
            
            [buttons[i] layer].cornerRadius = 25.0;
            [buttons[i] layer].shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
            [buttons[i] layer].shadowOpacity = 1.0;
            [buttons[i] layer].shadowRadius = 6;
            [buttons[i] layer].shadowOffset = CGSizeMake(2.0f, 6.0f);
        
        }
        else{
            [buttons[i] layer].cornerRadius = 25.0;
                [buttons[i] layer].shadowColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
                [buttons[i] layer].shadowOpacity = 0.5;
                [buttons[i] layer].shadowRadius = 2;
                [buttons[i] layer].shadowOffset = CGSizeMake(2.0f, 2.0f);
            
        }
    }
    
}


@end
