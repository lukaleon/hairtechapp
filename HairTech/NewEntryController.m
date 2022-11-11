//
//  ViewController+NewEntryController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewEntryController.h"


#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NewEntryController
@synthesize techniqueName;
-(void)viewDidAppear:(BOOL)animated{
    [self captureScreenRetinaOnLoad];
}

-(void)viewDidLoad{
    NSLog(@"technique name %@", self.techniqueName);
    self.imageLeft.image = [self loadImages:@"thumb1"];
    self.imageRight.image = [self loadImages:@"thumb2"];
    self.imageTop.image = [self loadImages:@"thumb3"];
    self.imageFront.image = [self loadImages:@"thumb4"];
    self.imageBack.image = [self loadImages:@"thumb5"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
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
    
  //  if (!self.isFirstTime){
//        self.imageLeft.image = self.imageL;
//        self.imageRight.image = self.imageR;
//        self.imageTop.image = self.imageT;
//        self.imageFront.image = self.imageF;
//        self.imageBack.image = self.imageB;
   //}
//    if (self.isFirstTime && [self.techniqueType isEqualToString:@"version22"]){
//        self.imageLeft.image = [UIImage imageNamed:@"lefthead_s"];
//        self.imageRight.image =  [UIImage imageNamed:@"righthead_s"];
//        self.imageTop.image =  [UIImage imageNamed:@"tophead_s"];
//        self.imageFront.image =  [UIImage imageNamed:@"fronthead_s"];
//        self.imageBack.image =[UIImage imageNamed:@"backhead_s"];
//    }
//    if ( [self.techniqueType isEqualToString:@"men22"]){
//        self.imageLeft.image = [UIImage imageNamed:@"lefthead"];
//        self.imageRight.image =  [UIImage imageNamed:@"righthead"];
//        self.imageTop.image =  [UIImage imageNamed:@"tophead"];
//        self.imageFront.image =  [UIImage imageNamed:@"fronthead_ms"];
//        self.imageBack.image =[UIImage imageNamed:@"backhead_ms"];
//    }
    
//    self.imageLeft.image = self.imageL;
//    self.imageRight.image = self.imageR;
//    self.imageTop.image = self.imageT;
//    self.imageFront.image = self.imageF;
//    self.imageBack.image = self.imageB;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
 
}


-(UIImage*)loadImages:(NSString*)headtype
{
//    NSMutableString *filenamethumb;
//    filenamethumb = @"%@/";
//    NSMutableString *prefix;
//    prefix = techniqueName;
//    filenamethumb = [filenamethumb mutableCopy];
//    [filenamethumb appendString: prefix];
//    filenamethumb = [filenamethumb mutableCopy];
//    [filenamethumb appendString: headtype];
//    filenamethumb = [filenamethumb mutableCopy];
//    [filenamethumb appendString: @".png"];
    
    NSMutableString *filenamethumb1 = @"%@/";
    NSMutableString *prefix= techniqueName;
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: headtype];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @".png"];
    
    NSLog(@"print %@", filenamethumb1);
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
        NSData *data1 = [NSData dataWithContentsOfFile:filePath];
    UIImage *tempimage = [UIImage imageWithData:data1];
    return tempimage;
}

-(void)openDrawingView:(UITapGestureRecognizer*)sender{
    NSInteger myViewTag = sender.view.tag;
    NewDrawController *newDrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewDrawController"];
    newDrawVC.delegate = self;
    newDrawVC.techniqueName = self.techniqueName;
    switch (myViewTag) {
        case 1:
            newDrawVC.headtype = @"lefthead";
            break;
        case 2:
            newDrawVC.headtype = @"righthead";
            break;
        case 3:
            newDrawVC.headtype = @"tophead";
            break;
        case 4:
            newDrawVC.headtype = @"fronthead";
            break;
        case 5:
            newDrawVC.headtype = @"backhead";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController: newDrawVC animated:YES];
}



- (void)share:(id)sender{
    NSString *textToShare;
    textToShare = [NSString stringWithFormat:@""];
    self.labelToSave.text = self.techniqueName;
    textToShare = self.labelToSave.text;
    self.labelToSave.alpha = 1.0;
    self.logo.alpha = 1.0;
    UIImage * imageToShare = [self captureScreenRetina];
    UIImage * logoToShare =  self.logo.image;
    NSArray *itemsToShare = [NSArray arrayWithObjects:textToShare, imageToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: itemsToShare applicationActivities:nil];

    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        UIPopoverController * listPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        listPopover.delegate = self;
        [listPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:activityViewController animated: YES completion: nil];
        UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(728,60,10,1);
    }
    self.labelToSave.alpha = 0.0;
    self.logo.alpha = 0.0;
}


- (NSMutableString*)createFileName:(NSMutableString*)name prefix:(NSString*)prefix {
    name = self.navigationItem.title;
    name = [name mutableCopy];
    [name appendString: prefix];
    name = [name mutableCopy];
    [name appendString: @".png"];
    return name;
}

-(UIImage*)captureScreenRetinaOnLoad
{
    self.logo.alpha = 0;
    self.labelToSave.alpha = 0;
//    entryviewImage =  [self createFileName:entryviewImage prefix:@"EntryBig"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:entryviewImage];
//    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData * data = UIImagePNGRepresentation(image);
//    [data writeToFile:path atomically:YES];
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    
//    CGRect rect = CGRectMake(self.imageLeft.frame.origin.x, self.imageLeft.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    
    UIGraphicsBeginImageContextWithOptions(self.screenShotView.frame.size, self.screenShotView.opaque, 3.0);
    [self.screenShotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    entryviewImageSmall =  [self createFileName:entryviewImageSmall prefix:@"Entry"];
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:entryviewImageSmall];
    NSData * thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];
    return newImage;
}
-(UIImage*)captureScreenRetina
{
    UIGraphicsBeginImageContextWithOptions(self.screenShotView.frame.size, self.screenShotView.opaque, 3.0);
    [self.screenShotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//
//-(void)setImageForButton:(UIImage*)img{
//    NSLog(@"EntryView setting img");
//    self.imageLeft.image = img;
//}

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
@end
