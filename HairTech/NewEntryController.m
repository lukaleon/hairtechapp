//
//  ViewController+NewEntryController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewEntryController.h"
#import "TemporaryDictionary.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NewEntryController
//@synthesize techniqueNameID;
-(void)viewDidAppear:(BOOL)animated{
    [self captureScreenRetinaOnLoad];
}


-(void)setTechniqueID:(NSString*)techId{
    _techniqueNameID = techId;
}
-(void)viewDidLoad{
    
    NSLog(@"technique name %@", _techniqueNameID);
    self.imageLeft.image = [self openFileAtPath:_techniqueNameID key:@"imageLeft" error:nil];
    self.imageRight.image = [self openFileAtPath:_techniqueNameID key:@"imageRight" error:nil];
    self.imageTop.image = [self openFileAtPath:_techniqueNameID key:@"imageTop" error:nil];
    self.imageFront.image = [self openFileAtPath:_techniqueNameID key:@"imageFront" error:nil];
    self.imageBack.image = [self openFileAtPath:_techniqueNameID key:@"imageBack" error:nil];


//    self.imageLeft.image = [self loadImages:@"thumb1"];
//    self.imageRight.image = [self loadImages:@"thumb2"];
//    self.imageTop.image = [self loadImages:@"thumb3"];
//    self.imageFront.image = [self loadImages:@"thumb4"];
//    self.imageBack.image = [self loadImages:@"thumb5"];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(flipImage)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [self setupgestureRecognizers];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.toolbar removeFromSuperview];
}

/*-(NSDictionary*)openDictAtPath:(NSString*)fileName key:(NSString*)key error:(NSError **)outError {
    
    fileName = [fileName stringByAppendingFormat:@"%@",@".htapp"];
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
   
        return [tempDict objectForKey:key];
}*/

-(UIImage*)openFileAtPath:(NSString*)fileName key:(NSString*)key error:(NSError **)outError {

    fileName = [fileName stringByAppendingFormat:@"%@",@".htapp"];
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    UIImage * img = [UIImage imageWithData:[tempDict objectForKey:key]];

    NSMutableDictionary* tempDictDefaults = [tempDict mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:tempDictDefaults forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return img;
    
    
//    NSDictionary *readDict =
//    [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
//
//    UIImage *imageEntry = [readDict objectForKey:key];
//    return imageEntry;
    
}

//-(UIImage*)loadImages:(NSString*)headtype
//{
//    NSMutableString *filenamethumb1 = [@"%@/" mutableCopy];
//    NSMutableString *prefix= [techniqueNameID mutableCopy];
//    filenamethumb1 = [filenamethumb1 mutableCopy];
//    [filenamethumb1 appendString: prefix];
//    filenamethumb1 = [filenamethumb1 mutableCopy];
//    [filenamethumb1 appendString: headtype];
//    filenamethumb1 = [filenamethumb1 mutableCopy];
//    [filenamethumb1 appendString: @".png"];
//
//
//    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//    NSString *docDirectory = [sysPaths objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
//        NSData *data1 = [NSData dataWithContentsOfFile:filePath];
//    UIImage *tempimage = [UIImage imageWithData:data1];
//    return tempimage;
//}

-(void)openDrawingView:(UITapGestureRecognizer*)sender{
    NSInteger myViewTag = sender.view.tag;
    
    CGPoint point = [sender locationInView:sender.view];
    BOOL pointInside = false;
    
    if([self pointInside:point imageView:sender.view]){ // decrease touch area of uiimageview
        pointInside = YES;
    }
    
    NewDrawController *newDrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewDrawController"];
    newDrawVC.delegate = self;
    newDrawVC.techniqueName = _techniqueNameID;
    switch (myViewTag) {
        case 1:
            newDrawVC.headtype = @"imageLeft";
            newDrawVC.jsonType = @"jsonLeft";
            break;
        case 2:
            newDrawVC.headtype = @"imageRight";
            newDrawVC.jsonType = @"jsonRight";

            break;
        case 3:
            newDrawVC.headtype = @"imageTop";
            newDrawVC.jsonType = @"jsonTop";

            break;
        case 4:
            newDrawVC.headtype = @"imageFront";
            newDrawVC.jsonType = @"jsonFront";

            break;
        case 5:
            newDrawVC.headtype = @"imageBack";
            newDrawVC.jsonType = @"jsonBack";

            break;
        default:
            break;
    }
    if(pointInside){
        [self.navigationController pushViewController: newDrawVC animated:YES];
    }
}

- (void)setupgestureRecognizers {
    UITapGestureRecognizer * tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawingView:)];
    UITapGestureRecognizer * tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawingView:)];
    UITapGestureRecognizer * tapTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawingView:)];
    UITapGestureRecognizer * tapFront = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawingView:)];
    UITapGestureRecognizer * tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawingView:)];
    
    [self.imageLeft addGestureRecognizer:tapLeft];
    [self.imageRight addGestureRecognizer:tapRight];
    [self.imageTop addGestureRecognizer:tapTop];
    [self.imageFront addGestureRecognizer:tapFront];
    [self.imageBack addGestureRecognizer:tapBack];
}

- (void)registerNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureScreenRetinaOnLoad) name:@"didEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureScreenRetinaOnLoad) name:@"appDidTerminate" object:nil];
}


- (void)share:(id)sender{
    NSString *textToShare;
    textToShare = [NSString stringWithFormat:@""];
    self.labelToSave.text = self.navigationItem.title;
    textToShare = self.labelToSave.text;
    self.labelToSave.alpha = 1.0;
    self.logo.alpha = 1.0;
    
    UIImage * imageToShare = [self captureScreenRetina];
    NSArray *itemsToShare = [NSArray arrayWithObjects:textToShare, imageToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: itemsToShare applicationActivities:nil];

    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];

    
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:activityViewController animated: YES completion: nil];
        UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(728,60,10,1);
    
    self.labelToSave.alpha = 0.0;
    self.logo.alpha = 0.0;
    
    [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        
        if (!completed) {
            return;
            }
        else {
            [self setupBottomToolBar];
        }

       // [self showAlertAfterImageSaved];
        
    }];
}


- (NSMutableString*)createFileName:(NSMutableString*)name prefix:(NSString*)prefix {
    name = [name mutableCopy];
    [name appendString: prefix];
    name = [name mutableCopy];
    [name appendString: @".png"];
    return name;
}

-(void)storeImageInTempDictionary:(NSData*)imgData{
    NSMutableDictionary* tempDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    [tempDict setObject:imgData forKey:@"imageEntry"];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveDiagramToFile:_techniqueNameID];
}

-(UIImage*)captureScreenRetinaOnLoad
{
    self.logo.alpha = 0;
    self.labelToSave.alpha = 0;
    UIGraphicsBeginImageContextWithOptions(self.screenShotView.frame.size, self.screenShotView.opaque, 3.0);
    [self.screenShotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    entryviewImageSmall =  [self createFileName:[_techniqueNameID mutableCopy] prefix:@"Entry"];
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:entryviewImageSmall];
    NSData * thumbdata = UIImagePNGRepresentation(newImage);
    
   // [thumbdata writeToFile:thumbpath atomically:YES];
    [self storeImageInTempDictionary:thumbdata];
    return newImage;
}
-(UIImage*)captureScreenRetina
{
    CGFloat rescale = 2.0;
    CGSize resize = CGSizeMake(self.screenShotView.frame.size.width * rescale, self.screenShotView.frame.size.height * rescale);

    UIGraphicsBeginImageContextWithOptions(resize, self.screenShotView.opaque, 0);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), rescale, rescale);

    [self.screenShotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//-(void)showAlertAfterImageSaved{
//     UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@""
//                                 message:@"Your diagrams was saved to gallery!"
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Your diagrams was saved to gallery!"];
//    NSRange fullRange = NSMakeRange(0, hogan.length);
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16]
//                  range:fullRange];
//    [alert setValue:hogan forKey:@"attributedMessage"];
//
//    alert.view.tintColor = [UIColor colorNamed:@"orange"];
//
//    //Add Buttons
//
////    UIAlertAction* yesButton = [UIAlertAction
////                                actionWithTitle:@"Yes"
////                                style:UIAlertActionStyleDefault
////                                handler:^(UIAlertAction * action) {
////                                    //Handle your yes please button action here
////                                 //   [self clearAllData];
////                                }];
//
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"Ok"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action) {
//                                   //Handle no, thanks button
//                               }];
//    //Add your buttons to alert controller
//
//   // [alert addAction:yesButton];
//    [alert addAction:noButton];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}


- (void)setupBottomToolBar {
    CGFloat startOfToolbar;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfToolbar = 100;
    }else {
        startOfToolbar = 10;
    }
    
    CGRect rect = CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height , self.view.frame.size.width - startOfToolbar * 2, 55);
    self.toolbar = [[UIView alloc]initWithFrame:rect];
    self.toolbar.alpha = 1.0f;
    [self.toolbar setBackgroundColor:[UIColor colorNamed:@"orange"]];
    [self.toolbar.layer setCornerRadius:15.0f];
    [super viewDidLoad];
    self.toolbar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolbar.layer.shadowOffset = CGSizeMake(0,0);
    self.toolbar.layer.shadowRadius = 8.0f;
    self.toolbar.layer.shadowOpacity = 0.2f;
    self.toolbar.layer.masksToBounds = NO;
    self.toolbar.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.toolbar.bounds cornerRadius:self.toolbar.layer.cornerRadius].CGPath;
    [self addInfoButtonOnToolbar];
    [self.view addSubview:self.toolbar];
    [UIView animateWithDuration:0.3
                     animations:^{
        
        self.toolbar.frame =  CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height - 80, self.view.frame.size.width - startOfToolbar * 2, 55);
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
    [self.toolbar addSubview:self.infoLabel];
    
    self.okButton =  [self fontButton:@"hideAlertView:" imageName1:@"info_icon_new.png" imageName2:@"info_icon_new.png" startX:self.infoLabel.frame.origin.x + self.infoLabel.frame.size.width - 40  width: 60 yAxe:self.toolbar.frame.size.height - 42];
   [self.toolbar addSubview:self.okButton];
    
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
            
            self.toolbar.frame =  CGRectMake(self.view.frame.origin.x + startOfToolbar, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width - startOfToolbar * 2, 55);
  }];

}

-(void)passItemBackLeft:(NewDrawController *)controller imageForButton:(UIImage*)item{
//    self.imageLeft.backgroundColor = [UIColor colorNamed:@"grey"];
    self.imageLeft.image = item;
}
-(void)passItemBackRight:(NewDrawController *)controller imageForButton:(UIImage*)item{
//    self.imageRight.backgroundColor = [UIColor colorNamed:@"grey"];
    self.imageRight.image = item;
}
-(void)passItemBackTop:(NewDrawController *)controller imageForButton:(UIImage*)item{
//    self.imageTop.backgroundColor = [UIColor colorNamed:@"grey"];
    self.imageTop.image = item;
}
-(void)passItemBackFront:(NewDrawController *)controller imageForButton:(UIImage*)item{
//    self.imageFront.backgroundColor = [UIColor colorNamed:@"grey"];
    self.imageFront.image = item;
}
-(void)passItemBackBack:(NewDrawController *)controller imageForButton:(UIImage*)item{
//    self.imageBack.backgroundColor = [UIColor colorNamed:@"grey"];
    self.imageBack.image = item;
    
}



-(void)flipImage{
    UIImage * flippedImage = [UIImage imageWithCGImage:self.imageLeft.image.CGImage
                                                scale:self.imageLeft.image.scale
                                          orientation:UIImageOrientationUpMirrored];
    self.imageRight.image = flippedImage;
}

-(BOOL)pointInside:(CGPoint)point imageView:(UIView*)imgView
{
    CGRect newArea = CGRectMake(imgView.bounds.origin.x + 40, imgView.bounds.origin.y + 80, imgView.bounds.size.width-  80, imgView.bounds.size.height - 100);
    
//    UIView * tempView = [[UIView alloc]initWithFrame:newArea];
//    tempView.backgroundColor = [UIColor colorNamed:@"orange"];
//    [imgView addSubview:tempView];
    
    return CGRectContainsPoint(newArea, point);
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
