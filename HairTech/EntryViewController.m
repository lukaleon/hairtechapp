//
//  MainViewController.m
//  HairTech
//
//  Created by Admin on 15/11/2012.
//  Copyright (c) 2012 Admin. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "EntryViewController.h"
#import "DrawViewController.h"
#import "TopHeadViewController.h"
#import "DrawViewControllerRight.h"
#import "FrontHeadViewController.h"
#import "BackHeadViewController.h"
#import "AppDelegate.h"
#import "HelpViewController.h"
#import "Cell.h"
#import "Defines.h"


#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define degreestoradians(x) (M_PI * x / 180)

@interface EntryViewController()

@end

@implementation EntryViewController

@synthesize button;
@synthesize buttonRightHead;
@synthesize buttonFrontHead;
@synthesize buttonTopHead;
@synthesize buttonBackHead;

NSMutableString *foothumb1;
NSMutableString *foothumb2;
CGPoint currentPoint;
CGPoint lastPoint;
CGPoint point1;
UIImageView *dragImg;
CGPoint location;

-(void)showPopoverForRating:(id)sender
{
}
-(void)showImageFirst
{
}


-(void)viewWillAppear:(BOOL)animated{
    
    //[self.navigationController.navigationBar
    // setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    if ((screenHeight == 736)||(screenHeight == 667)||(screenHeight == 568))
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/4.8, screenRect.size.width/2, screenRect.size.height/2);
        
        self.button.frame = CGRectMake(0, 20, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width-(screenRect.size.width/2), 20, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonFrontHead.frame = CGRectMake(0, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
    }
    
    
    
    
    else if (screenHeight == 812)
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/5, screenRect.size.width/2, screenRect.size.height/2);
        
        self.button.frame = CGRectMake(0, 10, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width/2, 10, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
    }
    
    
    self.labelHairTech.text =  self.navigationItem.title;
    /*if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale >= 2.0)) {
        [self captureScreenRetina];        // Retina display
    }
    
    else
        
        // non-Retina display
        [self captureScreen];
*/
    
    [self captureScreenRetina];
}

-(void)viewDidLoad{
    NSLog(@"APP VERSION%@", self.appVersion);
    CGRect screenRect = [[UIScreen mainScreen] nativeBounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    NSLog(@"screen width = %f", screenWidth);
    
    NSLog(@"screen height = %f", screenHeight);
    
    
    
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureScreenRetina) name:UIApplicationWillTerminateNotification object:nil];
   [self.toolbar setClipsToBounds:YES];
   
  // [KGStatusBar dismiss];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
  screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    if(appDelegate.checkEntrywindow != 1){
        
        self.navigationItem.title= self.stringFromTextfield;
        if ((screenHeight == 736)||(screenHeight == 667)||(screenHeight == 568))
        {
              self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/4.8, screenRect.size.width/2, screenRect.size.height/2);
            
             self.button.frame = CGRectMake(0, 20, screenRect.size.width/2, screenRect.size.height/2);
            self.buttonRightHead.frame = CGRectMake(screenRect.size.width-(screenRect.size.width/2), 20, screenRect.size.width/2, screenRect.size.height/2);
           self.buttonFrontHead.frame = CGRectMake(0, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
        }
        
       else if (screenHeight == 812)
        {
            self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/5, screenRect.size.width/2, screenRect.size.height/2);
            
            self.button.frame = CGRectMake(0, 10, screenRect.size.width/2, screenRect.size.height/2);
            self.buttonRightHead.frame = CGRectMake(screenRect.size.width/2, 10, screenRect.size.width/2, screenRect.size.height/2);
            self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
            self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
        }
        
        [self.button setBackgroundImage:self.entryImage1 forState:UIControlStateNormal];
        [self.buttonRightHead setBackgroundImage:self.entryImage2 forState:UIControlStateNormal];
        [self.buttonTopHead setBackgroundImage:self.entryImage3 forState:UIControlStateNormal];
        [self.buttonFrontHead setBackgroundImage:self.entryImage4 forState:UIControlStateNormal];
        [self.buttonBackHead setBackgroundImage:self.entryImage5 forState:UIControlStateNormal];
        NSLog(@"OPEN OPEN OPEN MANY TIMES");
    }
    else {
        
        
        if (((screenHeight == 736)||(screenHeight == 667)||(screenHeight == 568))&&([appDelegate.globalDate isEqualToString:@"new_version"]))
        {
            NSLog(@"I'AM using 7plus files");
            
                self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/4.8, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"btn_tophead_7p.png"] forState:UIControlStateNormal];
                
                /////////////////////////////////////////////////
                self.button.frame = CGRectMake(0, 20, screenRect.size.width/2, screenRect.size.height/2);
                [self.button setBackgroundImage:[UIImage imageNamed:@"btn_lefthead_7p.png"] forState:UIControlStateNormal];
                /////////////////////////////////////////////////
                self.buttonRightHead.frame = CGRectMake(screenRect.size.width-(screenRect.size.width/2), 20, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"btn_righthead_7p.png"] forState:UIControlStateNormal];
                
            //////////////////////////////////////////////////////////////////////////////////////////
                
                 self.buttonFrontHead.frame = CGRectMake(0, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"btn_fronthead_7p.png"] forState:UIControlStateNormal];
                
                ////////////////////////////////////////////////////////////////////////////
               self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
                 [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"btn_backhead_7p.png"] forState:UIControlStateNormal];
                
                 NSLog(@"OPENED FIRST TIME");
             }
        
        
        else if (((screenHeight == 736)||(screenHeight == 667)||(screenHeight == 568))&&([appDelegate.globalDate isEqualToString:@"men_heads"]))
        {
            NSLog(@"I'AM using 7plus MEN");
           
            NSLog(@"I'AM using 7plus files");
                
                self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/4.8, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"men-iphone7-top-sm.png"] forState:UIControlStateNormal];
                
                /////////////////////////////////////////////////
                self.button.frame = CGRectMake(0, 20, screenRect.size.width/2, screenRect.size.height/2);
                [self.button setBackgroundImage:[UIImage imageNamed:@"men-iphone7-left-sm.png"] forState:UIControlStateNormal];
                /////////////////////////////////////////////////
                self.buttonRightHead.frame = CGRectMake(screenRect.size.width-(screenRect.size.width/2), 20, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"men-iphone7-right-sm.png"] forState:UIControlStateNormal];
                
            //////////////////////////////////////////////////////////////////////////////////////////
                
                 self.buttonFrontHead.frame = CGRectMake(0, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
                [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"men-iphone7-front-sm.png"] forState:UIControlStateNormal];
                
                ////////////////////////////////////////////////////////////////////////////
               self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, (screenRect.size.height/2)+screenRect.size.height/9, screenRect.size.width/2, screenRect.size.height/2);
                 [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"men-iphone7-back-sm.png"] forState:UIControlStateNormal];
                
                 NSLog(@"OPENED FIRST TIME");
            
            
            
            
             }
        
        
    
      else  if ((screenHeight == 812)&&[appDelegate.globalDate isEqualToString:@"new_version"])
        {
            NSLog(@"I'AM using X  files");
            
           self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/5, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"btn_tophead_x.png"] forState:UIControlStateNormal];
            
            /////////////////////////////////////////////////
            self.button.frame = CGRectMake(0, 10, screenRect.size.width/2, screenRect.size.height/2);
            
            [self.button setBackgroundImage:[UIImage imageNamed:@"btn_lefthead_x.png"] forState:UIControlStateNormal];
            /////////////////////////////////////////////////
            self.buttonRightHead.frame = CGRectMake(screenRect.size.width/2, 10, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"btn_righthead_x.png"] forState:UIControlStateNormal];
            
            //////////////////////////////////////////////////////////////////////////////////////////
            
           self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"btn_fronthead_x.png"] forState:UIControlStateNormal];
            
            ////////////////////////////////////////////////////////////////////////////
        
            self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
             [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"btn_backhead_x.png"] forState:UIControlStateNormal];
            
            NSLog(@"OPENED FIRST TIME");
        }
        /*--------MEN - iphone X---------------*/
        
        
        else  if ((screenHeight == 812)&&[appDelegate.globalDate isEqualToString:@"men_heads"])
        {
            NSLog(@"I'AM using XMEN");
            
           self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-screenRect.size.width/4, (screenRect.size.height/2)-screenRect.size.height/5, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"men-top-11-sm.png"] forState:UIControlStateNormal];
            
            /////////////////////////////////////////////////
            self.button.frame = CGRectMake(0, 10, screenRect.size.width/2, screenRect.size.height/2);
            
            [self.button setBackgroundImage:[UIImage imageNamed:@"men-left-11-sm.png"] forState:UIControlStateNormal];
            /////////////////////////////////////////////////
            self.buttonRightHead.frame = CGRectMake(screenRect.size.width/2, 10, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"men-right-11-sm.png"] forState:UIControlStateNormal];
            
            //////////////////////////////////////////////////////////////////////////////////////////
            
           self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
            [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"men-front-11-sm.png"] forState:UIControlStateNormal];
            
            ////////////////////////////////////////////////////////////////////////////
        
            self.buttonBackHead.frame = CGRectMake(screenRect.size.width/2, screenRect.size.height/1.6, screenRect.size.width/2, screenRect.size.height/2);
             [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"men-back-11-sm.png"] forState:UIControlStateNormal];
            
            NSLog(@"OPENED FIRST TIME");
        }
        
        
        
        
        
        
        
        
       else if (((screenHeight==1024)||(screenHeight==1366)||(screenHeight==834))&&([appDelegate.globalDate isEqualToString:@"new_version"]))
        {
            NSLog(@"I'AM using ipad files");
            
            
            [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"ipad_top_sm.png"] forState:UIControlStateNormal];
            [self.button setBackgroundImage:[UIImage imageNamed:@"ipad_left_sm.png"] forState:UIControlStateNormal];
            [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"ipad_right_sm.png"] forState:UIControlStateNormal];
            [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"ipad_front_sm.png"] forState:UIControlStateNormal];
            [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"ipad_back_sm.png"] forState:UIControlStateNormal];
            
            NSLog(@"OPENED FIRST TIME");
            
        }
        
        /*----------------------MEN IPAD-------------------------*/
        
        
             else if (((screenHeight==1024)||(screenHeight==1366)||(screenHeight==834))&&([appDelegate.globalDate isEqualToString:@"men_heads"]))
              {
                  NSLog(@"I'AM using ipad files");
                  
                  
                  [self.buttonTopHead setBackgroundImage:[UIImage imageNamed:@"men-ipad-top-sm.png"] forState:UIControlStateNormal];
                  [self.button setBackgroundImage:[UIImage imageNamed:@"men-ipad-left-sm.png"] forState:UIControlStateNormal];
                  [self.buttonRightHead setBackgroundImage:[UIImage imageNamed:@"men-ipad-right-sm.png"] forState:UIControlStateNormal];
                  [self.buttonFrontHead setBackgroundImage:[UIImage imageNamed:@"men-ipad-front-sm.png"] forState:UIControlStateNormal];
                  [self.buttonBackHead setBackgroundImage:[UIImage imageNamed:@"men-ipad-back-sm.png"] forState:UIControlStateNormal];
                  
                  NSLog(@"OPENED FIRST TIME");
                  
              }
        
        (appDelegate.checkEntrywindow = 0);
    self.navigationItem.title = self.stringFromTextfield;
    // [super viewWillAppear:animated];
    
    
    }
   }
/*
-(void)setImagesInEC:(ViewController*)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5{

    [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
    [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
    [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
    [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
    [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
    NSLog(@"delegateEC Called");

}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
        }


-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
 
    
    
}
- (void)viewDidUnload {
    
    [self setButton:nil];
    [self setButtonRightHead:nil];
    [self setButtonBackHead:nil];
    [self setButtonFrontHead:nil];
    [self setButtonTopHead:nil];
    [self setImageView:nil];
    [self setScreenshot:nil];
    [self setToolbar:nil];
    [self setBackbtn:nil];
    
    data = nil;
    thumbdata = nil;
    [super viewDidUnload];
    
}

- (IBAction)drawView:(id)sender {
    
dcController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftView"];
    
    dcController.stringFromVC=self.navigationItem.title;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.checkHead1!=1)
    {
        appDelegate.checkHead1=0;
    }
    self.sendImagenameToControllers = appDelegate.myGlobalName;
   
    dcController.stringForLabel = self.sendImagenameToControllers;
    dcController.appVersion = self.appVersion;
    [self.navigationController pushViewController:dcController animated:YES];
    dcController.drawcontrollerdelegate = self;
   
    appDelegate.currentView = @"drawView";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    
}
- (IBAction)drawViewRight:(id)sender{
    dcControllerRight= [self.storyboard instantiateViewControllerWithIdentifier:@"rightView"];
    
    dcControllerRight.stringFromVC=self.navigationItem.title;
    
    
    ////------Send imagename to DrawViewController -----------///////////
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.sendImagenameToControllers = appDelegate.myGlobalName;
    
    dcControllerRight.stringForLabel = self.sendImagenameToControllers;
    dcControllerRight.appVersion = self.appVersion;

    
  //  [Flurry logEvent:@"Top_View_Opened"];
    
    
    [self.navigationController pushViewController:dcControllerRight animated:YES];
    dcControllerRight.drawcontrollerRightdelegate = self;

}
- (IBAction)drawViewTop:(id)sender{
    
    topController = [self.storyboard instantiateViewControllerWithIdentifier:@"topView"];
    
    topController.stringFromVC=self.navigationItem.title;
    topController.appVersion = self.appVersion;

    
    ////------Send imagename to DrawViewController -----------///////////
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.sendImagenameToControllers = appDelegate.myGlobalName;
  
    topController.stringForLabel = self.sendImagenameToControllers;
    
    
    //[Flurry logEvent:@"Top_View_Opened"];
    
    
    [self.navigationController pushViewController:topController animated:YES];
    topController.topheadcontrollerdelegate = self;
}

- (IBAction)drawViewFront:(id)sender{
    
    frontController = [self.storyboard instantiateViewControllerWithIdentifier:@"frontView"];
    
    frontController.stringFromVC=self.navigationItem.title;
    frontController.appVersion = self.appVersion;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.checkHead2!=1){
        appDelegate.checkHead2=0;
    }
    self.sendImagenameToControllers = appDelegate.myGlobalName;
  
    frontController.stringForLabel = self.sendImagenameToControllers;
    
        NSLog(@"THE TOPHEADCONTROLLER LABEL = %@", frontController.stringForLabel);
   // [Flurry logEvent:@"Draw_View_Right_Opened"];
    
    
    [self.navigationController pushViewController:frontController animated:YES];
    frontController.frontheadcontrollerdelegate = self;
}

- (IBAction)drawViewBack:(id)sender{
    
    backController = [self.storyboard instantiateViewControllerWithIdentifier:@"backView"];
    
    backController.stringFromVC=self.navigationItem.title;
    backController.appVersion = self.appVersion;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.checkHead2!=1){
        appDelegate.checkHead2=0;
    }
    self.sendImagenameToControllers = appDelegate.myGlobalName;
    
    backController.stringForLabel = self.sendImagenameToControllers;
    
    NSLog(@"THE TOPHEADCONTROLLER LABEL = %@", backController.stringForLabel);
   // [Flurry logEvent:@"Draw_View_Right_Opened"];
    
    
    [self.navigationController pushViewController:backController animated:YES];
    backController.backheadcontrollerdelegate = self;
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"leftView"])
    {
        UINavigationController *detailViewController = segue.destinationViewController;
        dcController = [[detailViewController viewControllers] objectAtIndex:0];
        dcController.drawcontrollerdelegate = self;
    
    }
    if ([[segue identifier] isEqualToString:@"topView"])
    {
        UINavigationController *detailViewController = segue.destinationViewController;
        topController = [[detailViewController viewControllers] objectAtIndex:0];
        topController.topheadcontrollerdelegate = self;
    }
    
    
    if ([[segue identifier] isEqualToString:@"rightView"])
    {
        
        UINavigationController *detailViewController = segue.destinationViewController;
        dcControllerRight = [[detailViewController viewControllers] objectAtIndex:0];
        dcControllerRight.drawcontrollerRightdelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"frontView"])
    {
        UINavigationController *detailViewController = segue.destinationViewController;
        frontController = [[detailViewController viewControllers] objectAtIndex:0];
        frontController.frontheadcontrollerdelegate = self;
    }

    if ([[segue identifier] isEqualToString:@"backView"])
    {
        
        UINavigationController *detailViewController = segue.destinationViewController;
        backController = [[detailViewController viewControllers] objectAtIndex:0];
        backController.backheadcontrollerdelegate = self;
    }
    
   }
*/

-(void)captureScreenRetina
{
    
    self.hideBar;
    [self.label setHidden:YES];
    [self.labelHairTech setHidden:YES];
    entryviewImage = self.navigationItem.title;
    entryviewImage = [entryviewImage mutableCopy];
    [entryviewImage appendString: @"EntryBig"];
    entryviewImage = [entryviewImage mutableCopy];
    [entryviewImage appendString: @".png"];
    
    NSLog(@"Результат збереження великоиі EntryViewController: %@.",entryviewImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:entryviewImage];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
   // if ((screenWidth == 414)&&(screenHeight==736))
   // {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        NSLog(@"CAPRUREEEEEEEEECAPTUREEEEEEEEEEE");
       /* CGSize newSize = CGSizeMake(screenWidth*([UIScreen mainScreen].scale),screenHeight*([UIScreen mainScreen].scale));
        UIGraphicsBeginImageContext(newSize);
        
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();*/
        
        entryviewImageSmall = self.navigationItem.title;
        entryviewImageSmall = [entryviewImageSmall mutableCopy];
        [entryviewImageSmall appendString: @"Entry"];
        entryviewImageSmall = [entryviewImageSmall mutableCopy];
        [entryviewImageSmall appendString: @".png"];
        NSLog(@"Результат: entryviewImageSmall %@.",entryviewImageSmall);
        
        NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
        NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
        NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:entryviewImageSmall];
        thumbdata = UIImagePNGRepresentation(newImage);
        [thumbdata writeToFile:thumbpath atomically:YES];
        
  //  }
    /*else {
    CGSize newSize = CGSizeMake(512 * ([UIScreen mainScreen].scale), 668 *([UIScreen mainScreen].scale));
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    entryviewImageSmall = self.navigationItem.title;
    entryviewImageSmall = [entryviewImageSmall mutableCopy];
    [entryviewImageSmall appendString: @"Entry"];
    entryviewImageSmall = [entryviewImageSmall mutableCopy];
    [entryviewImageSmall appendString: @".png"];
    NSLog(@"Результат: %@.",entryviewImageSmall);
    
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:entryviewImageSmall];
    thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];
    }*/
    [self.label setHidden:NO];
    [self.labelHairTech setHidden:NO];
    [self showBar];
}



-(UIImage*)captureScreenForMail
{
    //[Flurry logEvent:@"Caprure_For_Mail"];

   
    /* if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
    self.hideBar;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
     
         self.showBar;
         NSLog(@"Captured screen");
         return img;
     }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        */ self.hideBar;
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.showBar;
    NSLog(@"Captured screen");
    return img;
  //  }
}

-(UIImage*)captureRetinaScreenForMail
{
    //[Flurry logEvent:@"Caprure_Retina_For_Mail"];
/*if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
    self.hideBar;
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.showBar;
    
    return img;
}
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        */self.hideBar;
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.showBar;
        NSLog(@"Captured screen");
        return img;
  //  }

    
}



- (void)share:(id)sender{
  // [Flurry logEvent:@"UIActivityController_Launched"];

    NSString *textToShare;

    
        textToShare = [NSString stringWithFormat:@""];
   // NSString *        textToShare2 = [NSString stringWithFormat:@"fb://profile/230787750393258"];

    UIImage *imageToShare;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
       imageToShare =  [self captureRetinaScreenForMail];
    }
    else
    {
      imageToShare = [self captureScreenForMail];
    }
  
    //NSMutableArray *itemsToShare = [NSMutableArray arrayWithObjects:textToShare, imageToShare, nil];
    //NSArray *itemsToShare = @[textToShare, imageToShare];
    
     NSArray *itemsToShare = [NSArray arrayWithObjects:textToShare, imageToShare, nil];
    
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: itemsToShare applicationActivities:nil];
    
 activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
   
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        // code here
    

    self.listPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    self.listPopover.delegate = self;

        
//[self.listPopover presentPopoverFromRect:CGRectMake(728,60,10,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
[self.listPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
   
    }
 
    
    


if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
    // code here

    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    //activityViewController.preferredContentSize = CGSizeMake(400, 400);
    
    [self presentViewController:activityViewController animated: YES completion: nil];
    
    UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPresentationController.sourceView = self.view;
    popoverPresentationController.sourceRect = CGRectMake(728,60,10,1);
}
}


-(void)dismissPopover
{

    [self.listPopover dismissPopoverAnimated:YES];
}
- (void)labelPositionMiddle {
    CGRect labelPosition = self.labelHairTech.frame;

    NSLog(@"POSITION: %f", labelPosition.origin.x); // Returns 0.000000
    
    labelPosition.origin.x = 315;
    labelPosition.origin.y = 55;

    self.labelHairTech.frame = labelPosition;// Now moved to 50.000000
    
}

- (void)labelPositionLeft {
    CGRect labelPosition = self.labelHairTech.frame;

    NSLog(@"POSITION: %f", labelPosition.origin.x); // Returns 0.000000
    labelPosition.origin.x = 315;
    labelPosition.origin.y = 55;
    
    self.labelHairTech.frame = labelPosition;  // Now moved to 50.000000
}

-(void)hideBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelHairTech.alpha = 1.0;
    [self.imageView setHidden:YES];
    [self.toolbar setHidden:YES];
   // self.labelHairTech.textColor = [UIColor blackColor];
    self.label.textColor = [UIColor blackColor];
   // [self labelPositionMiddle];
}
-(void)showBar

{
      UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

    self.view.backgroundColor = mycolor2;
    [self.imageView setHidden:NO];
    [self.toolbar setHidden:NO];
    //self.labelHairTech.textColor = [UIColor whiteColor];
    self.labelHairTech.alpha = 0.0;
    self.label.textColor = [UIColor whiteColor];
    //[self labelPositionLeft];
}

-(void) passItemBack:(DrawViewController *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5 version:(NSString*)version
{
    self.appVersion = version;
    
    if(![version isEqualToString:@"version22"]){
        if ((screenWidth == 414)&&(screenHeight==736))
        {
            self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
            
            self.button.frame = CGRectMake(0, 64, 165, 275);
            self.buttonRightHead.frame = CGRectMake(screenRect.size.width-165, 64, 165, 275);
            self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
            self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
        }
    } else {
        CGFloat halfWidth = self.view.frame.size.width / 2;
        
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
        
        self.button.frame = CGRectMake(self.view.frame.origin.x, 64, halfWidth, halfWidth * 1.3);
        self.buttonRightHead.frame = CGRectMake(self.view.center.x, 64, self.view.center.x * 2, halfWidth * 1.3);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
    }
        
        NSLog(@"I Was called from drawiewcontroller");
        [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
        [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
        [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
        [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
        [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
        
        [self.navigationController popToViewController:self animated:YES];
 
    
    
}
-(void) passItemBackFromRight:(DrawViewControllerRight *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5
{
    
    if ((screenWidth == 414)&&(screenHeight==736))
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
        
        self.button.frame = CGRectMake(0, 64, 165, 275);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width-165, 64, 165, 275);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
    }
    NSLog(@"I Was called from rightdrawiewcontroller");
    [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
    [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
    [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
    [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
    [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
    
    [self.navigationController popToViewController:self animated:YES];
    
}

-(void) passItemBackFromTop:(TopHeadViewController *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5
{
    if ((screenWidth == 414)&&(screenHeight==736))
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
        
        self.button.frame = CGRectMake(0, 64, 165, 275);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width-165, 64, 165, 275);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
    }
    
    NSLog(@"I Was called from topdrawiewcontroller");
    [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
    [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
    [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
    [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
    [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
    
    [self.navigationController popToViewController:self animated:YES];
    
}



-(void) passItemBackFromFront:(FrontHeadViewController *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5
{
    if ((screenWidth == 414)&&(screenHeight==736))
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
        
        self.button.frame = CGRectMake(0, 64, 165, 275);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width-165, 64, 165, 275);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
    }
    
    NSLog(@"I Was called from frontdrawiewcontroller");
    [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
    [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
    [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
    [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
    [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
    
    [self.navigationController popToViewController:self animated:YES];
    
}

-(void) passItemBackFromBack:(BackHeadViewController *)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5
{
    
    if ((screenWidth == 414)&&(screenHeight==736))
    {
        self.buttonTopHead.frame = CGRectMake((screenRect.size.width/2)-84, (screenRect.size.height/2)-120, 165, 275);
        
        self.button.frame = CGRectMake(0, 64, 165, 275);
        self.buttonRightHead.frame = CGRectMake(screenRect.size.width-165, 64, 165, 275);
        self.buttonFrontHead.frame = CGRectMake(0, screenRect.size.height-265, 165, 275);
        self.buttonBackHead.frame = CGRectMake(screenRect.size.width-165, screenRect.size.height-265, 165, 275);
    }
    NSLog(@"I Was called from backdrawiewcontroller");
    [self.button setBackgroundImage:item1 forState:UIControlStateNormal];
    [self.buttonRightHead setBackgroundImage:item2 forState:UIControlStateNormal];
    [self.buttonTopHead setBackgroundImage:item3 forState:UIControlStateNormal];
    [self.buttonFrontHead setBackgroundImage:item4 forState:UIControlStateNormal];
    [self.buttonBackHead setBackgroundImage:item5 forState:UIControlStateNormal];
    
    [self.navigationController popToViewController:self animated:YES];
    
}

 @end
