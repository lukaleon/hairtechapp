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
#import "DocumentManager.h"
#import <StoreKit/StoreKit.h>
#import "HapticHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import AmplitudeSwift;

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NewEntryController

#pragma mark - Load Methods


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did apear %s",self.openedFromDrawingView ? "true" : "false");

  //  if(self.openedFromDrawingView){
    [self captureScreenRetinaOnLoad];
    //}
    openingDrawingView = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    //Store buttons images and screenshot in dictionary after view appear
   // [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];

}
-(void)setTechniqueID:(NSString*)techId{
    _techniqueNameID = techId;
}

static void setupContextMenuForImages(NewEntryController *object) {
    [object addContextMenuInteractionToImageView:object.imageLeft];
    [object addContextMenuInteractionToImageView:object.imageRight];
    [object addContextMenuInteractionToImageView:object.imageTop];
    [object addContextMenuInteractionToImageView:object.imageBack];
    [object addContextMenuInteractionToImageView:object.imageFront];
}

-(void)viewDidLoad{
   // NSLog(@"document note = %@, name - %@, maleOrFe -  %@ ",    [MyDoc sharedDocument].note, [MyDoc sharedDocument].techniqueName , [MyDoc sharedDocument].maleFemale);
    
    [self loadImages];
    [self addNavigationItems];
    [self setupgestureRecognizers];
    [self registerNotifications];
    [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
    setupContextMenuForImages(self);
    
    
    NSLog(@"View Controllers in Storyboard: %@", [self.storyboard instantiateInitialViewController]);

    
}
-(void)saveEntryImageToCloud:(NSString*)name image:(UIImage*)img{
    name = [name stringByDeletingPathExtension];
    name = [name stringByAppendingString:@".png"];
    
    // Append the desired file name to the URL
//    NSURL *fileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL]URLByAppendingPathComponent:name]; //iCloud
    NSURL *fileURL = [[DocumentManager documentDirectory]URLByAppendingPathComponent:name];


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
   
    if (self.isMovingFromParentViewController){
        
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            // ...
            if (success) {
                [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
                
                NSLog(@"From viewWillDisappear!, %@ saved ", self.document.fileURL);
            } else {
                [NSException raise:@"YOU SUCK" format:@"Like, what the fuck man"];
            }
        }];
    }
        

        
//    [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
//
//           [[iCloud sharedCloud] saveAndCloseDocumentWithName:self.document.fileURL.lastPathComponent withContent:self.document completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {
//               if (!error) {
//
//                   NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
//               } else {
//                   NSLog(@"iCloud Document save error: %@", error);
//               }
//
//           }];
//        [[iCloud sharedCloud] setDocument:nil];

        
 
 

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
    
    more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
   // [moreBtn addTarget:self
     //           action:@selector(share)
      //forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
   // [shareBtn setImage:[UIImage systemImageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
     [more setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];

    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    UIButton *plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [plusBtn addTarget:self
                action:@selector(changeColorPalette)
      forControlEvents:UIControlEventTouchUpInside];
    [plusBtn.widthAnchor constraintEqualToConstant:30].active = YES;
    [plusBtn.heightAnchor constraintEqualToConstant:30].active = YES;
    [plusBtn setImage:[UIImage systemImageNamed:@"photo.stack"] forState:UIControlStateNormal];
    [plusBtn setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
    
    UIBarButtonItem * note = [[UIBarButtonItem alloc] initWithCustomView:addNote];
    UIBarButtonItem * moreBtn = [[UIBarButtonItem alloc] initWithCustomView:more];
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView:plusBtn];


    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBtn, plus, nil];
    
    [self registerActionView];

}

-(void)registerActionView{
    
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    NSMutableArray* actions2 = [[NSMutableArray alloc] init];
    
    // if (@available(iOS 14.0, *)) {
    
    more.showsMenuAsPrimaryAction = true;
    
    
    
    [actions addObject:[UIAction actionWithTitle:@"Add Note"
                                           image:[UIImage systemImageNamed:@"text.bubble"]
                                      identifier:nil
                                         handler:^(__kindof UIAction* _Nonnull action) {
       // [self changeColorPalette];
        [self addNotes];
        
    }]];
    
    [actions addObject:[UIAction actionWithTitle:@"Share"
                                           image:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                      identifier:nil
                                         handler:^(__kindof UIAction* _Nonnull action) {
        [self share];
        
    }]];
    
    UIMenu* menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:actions];
    
    // more.offset = CGPointMake(0, 40);
    if (@available(iOS 16.0, *)) {
        //   menu.preferredElementSize = UIMenuElementSizeMedium;
    } else {
        // Fallback on earlier versions
    }
    
    more.menu = menu;
    
}
- (void)loadImages {
    self.imageLeft.layer.cornerRadius = 20;
    self.imageRight.layer.cornerRadius = 20;
    self.imageTop.layer.cornerRadius = 20;
    self.imageBack.layer.cornerRadius = 20;
    self.imageFront.layer.cornerRadius = 20;
    
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
//    
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
    
   // UIImage * imageCombined = [self combineImages:imageToShare withImage:[self.document.photoArray objectAtIndex:0]];
   
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
            
            [self amplitudeEvent:@"Entry Image Shared"];
            
            [self setupBottomToolBar];
            
//            // Retrieve number of image shares
//            self.imageShareCount =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"shareCount"]integerValue];
//            
//
//            self.imageShareCount++; // Iterate each time when image shared
//            NSLog(@"image share count = %ld", (long)self.imageShareCount);
//            
//            // Store number of image shares
//            [[NSUserDefaults standardUserDefaults] setInteger:self.imageShareCount forKey:@"shareCount"];
//            
//            if (self.imageShareCount == 3){
//                [self promptUserForReview];
//                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"shareCount"];
//            }
            
        }

       // [self showAlertAfterImageSaved];
        
    }];
}

- (UIImage *)combineImages:(UIImage *)image1 withImage:(UIImage *)image2 {
    UIImage *finalImage;

  
    CGSize outerImageSize = CGSizeMake(image1.size.width + 400 ,image1.size.height); // Provide custom size or size of your actual image
    UIGraphicsBeginImageContext(outerImageSize);

    //calculate areaSize for re-centered inner image
    CGRect areSize = CGRectMake(image1.size.width + 50, 50, image2.size.width / 10 , image2.size.height / 10);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:areSize blendMode:kCGBlendModeNormal alpha:1.0];

    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return finalImage;
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
        openingDrawingView = YES;
        newDrawVC.document = self.document;
        [self.navigationController pushViewController: newDrawVC animated:YES];
    }
}

#pragma mark - Photo Attaching Methods

-(void)changeColorPalette{
    

    
//    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
//        PhotoPicker *photoPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"colorWheel"];
//        photoPicker.delegate = self;
//        photoPicker.isIpad  = YES;
//       // colorWheel.startColor = currentColor;
//        photoPicker.modalPresentationStyle = UIModalPresentationPageSheet;
//        photoPicker.preferredContentSize = CGSizeMake(300, 400);
//        [self presentViewController:photoPicker animated:YES completion:nil];
//    }
//    else{
   
        PhotoPicker *photoPicker = [[PhotoPicker alloc]init];
        [self prepareOverlay:photoPicker];
        photoPicker.isIpad  = NO;
        photoPicker.delegate = self;
        NSLog(@"Class of object: %@", NSStringFromClass([self.document.photoArray class]));
        
        [photoPicker setMyArray:self.document.photoArray];
        NSLog(@" array count %@", self.document.photoArray);
        [self presentViewController:photoPicker animated:true completion:nil];
   // }
    
}

- (void)prepareOverlay:(PhotoPicker*)viewController {
    self.overlayDelegate = [[OverlayTransitioningDelegate alloc]init];
viewController.transitioningDelegate = self.overlayDelegate;
viewController.modalPresentationStyle = UIModalPresentationCustom;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Notes Methods

-(void)addNotes{
    
//    NSMutableDictionary* dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    NSString * note = self.document.note;
//    NSString * note = [[iCloud sharedCloud] getDocument].note;
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
    
//    [[iCloud sharedCloud] getDocument].note = note;
    self.document.note = note;
    [self saveDataWhenReturnFromDrawing];

}
-(void)savePhotos:(NSMutableArray*)photos{
    NSLog(@"Store photos in self.document");
    self.document.photoArray = photos;
   [self saveDataWhenReturnFromDrawing];

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
   
  //  [[iCloud sharedCloud] getDocument].imageEntry = newImage;
 ////   [MyDoc sharedDocument].imageEntry = newImage;
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
    //[[iCloud sharedCloud] getDocument].imageEntry = newImage;
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
    NSLog(@"Save when terminate");
    
    
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        // ...
        if (success) {
            [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
            NSLog(@"Fuck terminator, %@ saved!", self.document.fileURL);
        } else {
            [NSException raise:@"YOU SUCK" format:@"Like, what the fuck man"];
        }
    }];
    
    
//    self.document = [[iCloud sharedCloud] getDocument];
//
//    [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
//
//    [[iCloud sharedCloud] saveAndCloseDocumentWithName:self.document.fileURL.lastPathComponent withContent:self.document completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {
//     if (!error) {
//         NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
//
//
//     } else {
//         NSLog(@"iCloud Document save error: %@", error);
//     }
// }];
//    [[iCloud sharedCloud] setDocument:nil];
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
    [self saveDataWhenReturnFromDrawing];
//    [[iCloud sharedCloud] getDocument].imageLeft = item;
    
}
-(void)passItemBackRight:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageRight.image = item;
    self.document.imageRight = item;
    [self saveDataWhenReturnFromDrawing];

//    [[iCloud sharedCloud] getDocument].imageRight = item;
}
-(void)passItemBackTop:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageTop.image = item;
    self.document.imageTop = item;
    [self saveDataWhenReturnFromDrawing];

//    [[iCloud sharedCloud] getDocument].imageTop = item;
}
-(void)passItemBackFront:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageFront.image = item;
    self.document.imageFront = item;
    [self saveDataWhenReturnFromDrawing];

//    [[iCloud sharedCloud] getDocument].imageFront = item;

}
-(void)passItemBackBack:(NewDrawController *)controller imageForButton:(UIImage*)item openedFromDrawingView:(BOOL)openedFromDrawing
{
    self.openedFromDrawingView = openedFromDrawing;
    self.imageBack.image = item;
    self.document.imageBack = item;
    [self saveDataWhenReturnFromDrawing];

//    [[iCloud sharedCloud] getDocument].imageBack = item;
}

-(NSString*)currentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
    
}

-(void)saveDataWhenReturnFromDrawing{
        
  //  if (self.isMovingFromParentViewController){
        
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            // ...
            if (success) {
                [self saveEntryImageToCloud:self.document.fileURL.lastPathComponent image:self.document.imageEntry];
                
                NSLog(@"WhenReturnFromDVC!, %@ saved ", self.document.fileURL);
            } else {
                [NSException raise:@"YOU SUCK" format:@"Like, what the fuck man"];
            }
        }];
    //}
}

#pragma mark - Image Detection Area Setup

-(BOOL)pointInside:(CGPoint)point imageView:(UIView*)imgView
{
    CGRect newArea = CGRectMake(imgView.bounds.origin.x + 40, imgView.bounds.origin.y + 80, imgView.bounds.size.width-  80, imgView.bounds.size.height - 100);
    return CGRectContainsPoint(newArea, point);
}
#pragma mark - UIContextMenuInteractionDelegate

- (void)addContextMenuInteractionToImageView:(UIImageView *)imageView {
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [imageView addInteraction:interaction];
}
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    // Find out which UIImageView was tapped
    UIImageView *tappedImageView = (UIImageView *)interaction.view;
    
    // Create a UIContextMenuConfiguration for the tapped UIImageView
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        // You can customize the menu actions based on the tapped UIImageView
        UIAction *action = [UIAction actionWithTitle:@"Copy" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Action tapped for image view with tag: %ld", (long)tappedImageView.tag);
            
            
            NSData *imageData = UIImagePNGRepresentation(tappedImageView.image);
            
            // Create a dictionary with the image data
            NSDictionary *imageItem = @{[@(tappedImageView.tag) stringValue]: imageData};
            NSDictionary *otherItem;
            
            switch (tappedImageView.tag) {
                case 1:
                    otherItem = @{
                        [@(tappedImageView.tag) stringValue]: _document.dictLeft,@"gender": _document.maleFemale
                    };
                    break;
                case 2:
                    otherItem = @{
                        [@(tappedImageView.tag) stringValue]: _document.dictRight,@"gender": _document.maleFemale
                    };
                    break;
                case 3:
                    otherItem = @{
                        [@(tappedImageView.tag) stringValue]: _document.dictTop,@"gender": _document.maleFemale
                    };
                    break;
                case 4:
                    otherItem = @{
                        [@(tappedImageView.tag) stringValue]: _document.dictFront,@"gender": _document.maleFemale
                    };
                    
                    break;
                case 5:
                    otherItem = @{
                        [@(tappedImageView.tag) stringValue]: _document.dictBack,@"gender": _document.maleFemale
                    };
                    break;
                default:
                    break;
            }
           
           

            
            // Combine the pasteboard items into an array
            NSArray *items = @[imageItem, otherItem];

            // Place the items on the clipboard
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setItems:items];
        }];
        
        UIAction *paste = [UIAction actionWithTitle:@"Paste" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Action tapped for image view with tag: %ld", (long)tappedImageView.tag);
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

            // Retrieve the data from the pasteboard
            NSArray *items = [pasteboard items];
            
            NSDictionary * dict = [items objectAtIndex:0];
            NSDictionary * dictLeft = [items objectAtIndex:1];

            NSData *imageData = dict[[@(tappedImageView.tag) stringValue]];
//                if (imageData) {
//                    // Process the image data
//                    // Do something with the image...
//                }
            NSData *dictData = dictLeft[[@(tappedImageView.tag) stringValue]];

            if (dictData && imageData) {
                tappedImageView.image =  [UIImage imageWithData:imageData];

                switch (tappedImageView.tag) {
                    case 1:

                        _document.dictLeft = dictData;
                        _document.imageLeft = tappedImageView.image;
                        break;
                    case 2:
                        _document.dictRight = dictData;
                        _document.imageRight = tappedImageView.image;
                        break;
                    case 3:
                        _document.dictTop = dictData;
                        _document.imageTop = tappedImageView.image;
                        break;
                    case 4:
                        _document.dictFront = dictData;
                        _document.imageFront = tappedImageView.image;
                        break;
                    case 5:
                        _document.dictBack = dictData;
                        _document.imageBack = tappedImageView.image;
                        break;
                    default:
                        break;
                }
            }
            [self saveDataWhenReturnFromDrawing];

            
        }];
        
        
        UIMenu *menu;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        // Retrieve the data from the pasteboard
        NSArray *items = [pasteboard items];
    
        NSDictionary * dict = [items objectAtIndex:0];
        NSData *imageData = dict[[@(tappedImageView.tag) stringValue]];
        
       
  
        // Determine if the clipboard is "empty" for your app's purposes
        if (imageData){
            
            NSDictionary * genDict = [items objectAtIndex:1];
            NSData *genderData = genDict[@"gender"];
            NSString * gender = [NSString stringWithUTF8String:[genderData bytes]];
            
            NSLog(@"Gender: %@", gender);
            if( [gender isEqualToString:_document.maleFemale] ) {
                menu = [UIMenu menuWithTitle:@"" children:@[action,paste]];
                
            }
            else {
                menu = [UIMenu menuWithTitle:@"" children:@[action]];
            }
        }
        else {
                
                menu = [UIMenu menuWithTitle:@"" children:@[action]];
                
            }
        
        return menu;
    }];
    
    return configuration;
}

#pragma mark - Rate App



- (void)promptUserForReview {
    
  //  [SKStoreReviewController requestReviewInScene:self.view.window.windowScene];
    //[self amplitudeEvent:@"Review Controller Shown"];
    
}
#pragma mark - Amplitude Analytics

-(void)amplitudeEvent:(NSString*)eventName{
    
    AMPConfiguration* configuration = [AMPConfiguration initWithApiKey:@"b377e11e11508029515d06b38d06a0ce"];
    //configuration.serverZone = AMPServerZoneEU;
    Amplitude * amplitude = [Amplitude initWithConfiguration:configuration];
    [amplitude track:eventName eventProperties:nil];

}
@end
