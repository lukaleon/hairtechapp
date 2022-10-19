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

-(void)viewDidAppear:(BOOL)animated{
    
    [self captureScreenRetina];

}
-(void)viewDidLoad{
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
}
-(void)openDrawingView:(UITapGestureRecognizer*)sender{
    NSInteger myViewTag = sender.view.tag;
    NewDrawController *newDrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewDrawController"];

    switch (myViewTag) {
        case 1:
            newDrawVC.imgName = @"lefthead";
            break;
        case 2:
            newDrawVC.imgName = @"righthead";
            break;
        case 3:
            newDrawVC.imgName = @"tophead";
            break;
        case 4:
            newDrawVC.imgName = @"fronthead";
            break;
        case 5:
            newDrawVC.imgName = @"backhead";
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
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
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

@end
