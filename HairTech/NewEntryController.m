//
//  ViewController+NewEntryController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewEntryController.h"
#import "TemporaryDictionary.h"
#import "NotesViewController.h"
#import "DiagramFile.h"
#import "iCloud.h"
#import "CustomActivityIndicator.h"
#import "iCloudDocument.h"
#import <QuickLook/QuickLook.h>
#import <QuickLookThumbnailing/QuickLookThumbnailing.h>

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NewEntryController

#pragma mark - Load Methods


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did apear %s",self.openedFromDrawingView ? "true" : "false");

  //  if(self.openedFromDrawingView){
    [self captureScreenRetinaOnLoad];
    //}
}

-(void)viewWillAppear:(BOOL)animated{
    //Store buttons images and screenshot in dictionary after view appear
    

}
-(void)setTechniqueID:(NSString*)techId{
    _techniqueNameID = techId;
}

-(void)viewDidLoad{
    NSLog(@"document note = %@, name - %@, maleOrFe -  %@ ", self.document.note, self.document.techniqueName , self.document.maleFemale);
    
    [self loadImages];
    [self addNavigationItems];
    [self setupgestureRecognizers];
    [self registerNotifications];
    
}
-(void)saveEntryImageToCloud:(NSString*)name image:(UIImage*)img{
    name = [name stringByDeletingPathExtension];
    name = [name stringByAppendingString:@".png"];
    
    // Append the desired file name to the URL
    NSURL *fileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL]URLByAppendingPathComponent:name];

    // Get the PNG data from the UIImage
    NSData *imageData = UIImagePNGRepresentation(img);
    
    // Save the image data to the file URL
    NSError *error;
    BOOL success = [imageData writeToURL:fileURL options:NSDataWritingAtomic error:&error];
    
    if (!success) {
        NSLog(@"Error saving image: %@", error.localizedDescription);
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.toolbar removeFromSuperview];
    NSLog(@"exit entry" );
   
   // if (self.isMovingToParentViewController){

    [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];

           [[iCloud sharedCloud] saveAndCloseDocumentWithName:self.document.fileURL.lastPathComponent withContent:self.document completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {
               if (!error) {


                   NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
               } else {
                   NSLog(@"iCloud Document save error: %@", error);
               }

           }];
           
       // }
 
 

}

#pragma mark - Configure Methods

- (void)addNavigationItems {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *addNote = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addNote addTarget:self
                action:@selector(addNotes)
      forControlEvents:UIControlEventTouchUpInside];
    [addNote.widthAnchor constraintEqualToConstant:30].active = YES;
    [addNote.heightAnchor constraintEqualToConstant:30].active = YES;
    [addNote setImage:[UIImage systemImageNamed:@"text.bubble"] forState:UIControlStateNormal];
    [addNote setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shareBtn addTarget:self
                action:@selector(share)
      forControlEvents:UIControlEventTouchUpInside];
    [shareBtn.widthAnchor constraintEqualToConstant:30].active = YES;
    [shareBtn.heightAnchor constraintEqualToConstant:30].active = YES;
    [shareBtn setImage:[UIImage systemImageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
    [shareBtn setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    UIBarButtonItem * note = [[UIBarButtonItem alloc] initWithCustomView:addNote];
    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:share, note, nil];
}



- (void)loadImages {
    
    self.imageLeft.image = self.document.imageLeft;
    self.imageRight.image = self.document.imageRight;
    self.imageTop.image = self.document.imageTop;
    self.imageFront.image = self.document.imageFront;
    self.imageBack.image = self.document.imageBack;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDataToCloudWhenTerminating) name:@"didEnterBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDataToCloudWhenTerminating) name:@"appDidTerminate" object:nil];
}


- (void)share{
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
            if([_document.maleFemale isEqualToString:@"female"]){
                newDrawVC.headtype = @"imageLeft";
            }else{
                newDrawVC.headtype = @"imageLeftMan";
            }
            newDrawVC.jsonType = @"jsonLeft";
            break;
        case 2:
            if([_document.maleFemale isEqualToString:@"female"]){
                newDrawVC.headtype = @"imageRight";
            }else{
                newDrawVC.headtype = @"imageRightMan";
            }
            newDrawVC.jsonType = @"jsonRight";
            break;
        case 3:
            if([_document.maleFemale isEqualToString:@"female"]){
                newDrawVC.headtype = @"imageTop";
            }else {
                newDrawVC.headtype = @"imageTopMan";
            }
            newDrawVC.jsonType = @"jsonTop";

            break;
        case 4:
            if([_document.maleFemale isEqualToString:@"female"]){
                newDrawVC.headtype = @"imageFront";
            }else {
                newDrawVC.headtype = @"imageFrontMan";
            }
            newDrawVC.jsonType = @"jsonFront";

            break;
        case 5:
            if([_document.maleFemale isEqualToString:@"female"]){
                newDrawVC.headtype = @"imageBack";
            }else {
                newDrawVC.headtype = @"imageBackMan";
            }
            newDrawVC.jsonType = @"jsonBack";

            break;
        default:
            break;
    }
    if(pointInside){
        newDrawVC.document = self.document;
        [self.navigationController pushViewController: newDrawVC animated:YES];
    }
}

#pragma mark - Notes Methods

-(void)addNotes{
    
//    NSMutableDictionary* dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    NSString * note = self.document.note;
    
    NotesViewController *  notesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"notes"];
    if(note.length == 0||[note isEqualToString:@"(null)"]){
    notesVC.textOfTextView = @"";
    }else
    {
    notesVC.textOfTextView = note;
    }
    notesVC.delegate = self;
    [self.navigationController presentViewController:notesVC animated:YES completion:nil];
}
-(void)saveNote:(NSString*)note{
    
    self.document.note = note;
}

#pragma mark - Saving Methods

- (NSMutableString*)createFileName:(NSMutableString*)name prefix:(NSString*)prefix {
    name = [name mutableCopy];
    [name appendString: prefix];
    name = [name mutableCopy];
    [name appendString: @".png"];
    return name;
}

-(NSData*)imageFromButton:(UIImage*)img{
    NSData * data = UIImagePNGRepresentation(img);
    return data;
}


-(UIImage*)captureScreenRetinaOnLoad
{
    self.logo.alpha = 0;
    self.labelToSave.alpha = 0;
    UIGraphicsBeginImageContextWithOptions(self.screenShotView.frame.size, self.screenShotView.opaque, 3.0);
    [self.screenShotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * thumbdata = UIImagePNGRepresentation(newImage);
    
   // [self storeImageInTempDictionary:thumbdata];
    //[self saveDataToCloudWhenCloseView];
   
    self.document.imageEntry = newImage;
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
    self.document.imageEntry = newImage;
    return newImage;
}
/*
- (void)saveDataToCloudWhenCloseView{
    
    
    NSData * data = [[DiagramFile sharedInstance] dataFromDictionary];
    NSMutableString * fileName = [[[DiagramFile sharedInstance] techniqueName] mutableCopy];
    [fileName appendString:@".htapp"];
    
    [[iCloud sharedCloud] saveAndCloseDocumentWithName:self.document.fileNameFromFile withContent:self.document.contents completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (!error) {
            NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"iCloud Document save error: %@", error);
        }

        [super viewWillDisappear:YES];
    }];
    
    
 

}
*/

- (void)saveDataToCloudWhenTerminating{
   // NSLog(@"Save when terminate");
    [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];

    [[iCloud sharedCloud] saveAndCloseDocumentWithName:self.document.fileURL.lastPathComponent withContent:self.document completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {
     if (!error) {
         NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
         
         
     } else {
         NSLog(@"iCloud Document save error: %@", error);
     }
 }];

}
 


 
#pragma mark - Setup Share Confirmation Alert View
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
#pragma mark - Delegate Methods

-(void)passItemBackLeft:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageLeft.image = item;
    self.document.imageLeft = item;
}
-(void)passItemBackRight:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageRight.image = item;
    self.document.imageRight = item;

}
-(void)passItemBackTop:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageTop.image = item;
    self.document.imageTop = item;

}
-(void)passItemBackFront:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageFront.image = item;
    self.document.imageFront = item;

}
-(void)passItemBackBack:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing
{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageBack.image = item;
    self.document.imageBack = item;

}

-(NSString*)currentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}

#pragma mark - Image Detection Area Setup

-(BOOL)pointInside:(CGPoint)point imageView:(UIView*)imgView
{
    CGRect newArea = CGRectMake(imgView.bounds.origin.x + 40, imgView.bounds.origin.y + 80, imgView.bounds.size.width-  80, imgView.bounds.size.height - 100);
    return CGRectContainsPoint(newArea, point);
}


#pragma mark - Activity Indicator Animation
-(void)startAnimating{
    NSLog(@"animate refresh ....");
    [CustomActivityIndicator.shared show:self.view backgroundColor:[UIColor darkGrayColor] size:40 duration:2.0];
}

-(void)stopAnimatingRefresh{
    NSLog(@"animate stop ....");
    [CustomActivityIndicator.shared hide:self.view duration:1.0];

}
@end
