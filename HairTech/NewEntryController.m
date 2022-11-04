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
    
    [self captureScreenRetina];
    
}
-(void)viewDidLoad{
    NSLog(@"technique name %@", self.techniqueName);
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
    
    if (!self.isFirstTime){
        self.imageLeft.image = self.imageL;
        self.imageRight.image = self.imageR;
        self.imageTop.image = self.imageT;
        self.imageFront.image = self.imageF;
        self.imageBack.image = self.imageB;
    }
    if (self.isFirstTime && [self.techniqueType isEqualToString:@"version22"]){
        self.imageLeft.image = [UIImage imageNamed:@"lefthead_s"];
        self.imageRight.image =  [UIImage imageNamed:@"righthead_s"];
        self.imageTop.image =  [UIImage imageNamed:@"tophead_s"];
        self.imageFront.image =  [UIImage imageNamed:@"fronthead_s"];
        self.imageBack.image =[UIImage imageNamed:@"fbackhead_s"];
    }
    if (self.isFirstTime && [self.techniqueType isEqualToString:@"men22"]){
        self.imageLeft.image = [UIImage imageNamed:@"backhead_s"];
        self.imageRight.image =  [UIImage imageNamed:@"backhead_s"];
        self.imageTop.image =  [UIImage imageNamed:@"backhead_s"];
        self.imageFront.image =  [UIImage imageNamed:@"backhead_s"];
        self.imageBack.image =[UIImage imageNamed:@"backhead_s"];
    }
    
//    self.imageLeft.image = self.imageL;
//    self.imageRight.image = self.imageR;
//    self.imageTop.image = self.imageT;
//    self.imageFront.image = self.imageF;
//    self.imageBack.image = self.imageB;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   // self.imageLeft.image = [self loadImages:@"thumb1"];
//    self.imageRight.image = [self loadImages:@"thumb2"];
//    self.imageTop.image = [self loadImages:@"thumb3"];
//    self.imageFront.image = [self loadImages:@"thumb4"];
//    self.imageBack.image = [self loadImages:@"thumb5"];
}

-(UIImage*)loadImages:(NSString*)headtype
{
    NSMutableString *filenamethumb;
    [filenamethumb isEqualToString: @"%@/"];
    NSMutableString *prefix;
    [prefix isEqualToString:techniqueName];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"headtype"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
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
    UIImage *imageToShare;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        //  imageToShare =  [self captureRetinaScreenForMail];
    }
    else
    {
        //imageToShare = [self captureScreenForMail];
    }
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
}


-(void)captureScreenRetina
{
    entryviewImage = self.navigationItem.title;
    entryviewImage = [entryviewImage mutableCopy];
    [entryviewImage appendString: @"EntryBig"];
    entryviewImage = [entryviewImage mutableCopy];
    [entryviewImage appendString: @".png"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:entryviewImage];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(self.imageLeft.frame.origin.x, self.imageLeft.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    entryviewImageSmall = self.navigationItem.title;
    entryviewImageSmall = [entryviewImageSmall mutableCopy];
    [entryviewImageSmall appendString: @"Entry"];
    entryviewImageSmall = [entryviewImageSmall mutableCopy];
    [entryviewImageSmall appendString: @".png"];
    NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
    NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
    NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:entryviewImageSmall];
    NSData * thumbdata = UIImagePNGRepresentation(newImage);
    [thumbdata writeToFile:thumbpath atomically:YES];
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
