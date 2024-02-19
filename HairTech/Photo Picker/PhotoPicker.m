//
//  UIViewController+ColorWheelController.m
//  hairtech
//
//  Created by Alexander Prent on 12.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "PhotoPicker.h"
#import "GzColors.h"
#import "ColorButton.h"
#import "HapticHelper.h"
#import "ImagePreviewController.h"
@import AmplitudeSwift;


@implementation PhotoPicker
{
    ColorButton * currentButton;

}
@synthesize _brightnessSlider;


-(void)setMyArray:(NSArray *)arr{
    self.tempImages = [NSMutableArray array];
    self.tempImages = [arr mutableCopy]; 
  }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //[self.delegate savePhotos:self.imagesArray];
    NSLog(@"array %lu", (unsigned long)self.imagesArray.count);
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerActionView];
    self.imagesArray = [[NSMutableArray alloc]init];
    self.imagesArray = self.tempImages;
    
    
    // Initialize the images array with your image names or URLs
      //  self.imagesArray = @[@"IMG_8905.jpg", @"IMG_8905.jpg", @"IMG_8905.jpg", @"IMG_8905.jpg", @"IMG_8905.jpg"];
    
//    UIImage * img = [UIImage imageNamed:@"IMG_8905.jpg"];
//    [self.imagesArray addObject:img];

    CGFloat leftInset = ((self.view.bounds.size.width - 300 - 20 )/2.0); //Calculate cell offset if no images in array
    
    // Set up collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10.0; // Adjust as needed
    layout.minimumInteritemSpacing = 10.0; // Adjust as needed
    layout.itemSize = CGSizeMake(200, 200); // Adjust width and height as needed
   
    //layout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, leftInset); // Adjust top, left, bottom, and right insets as needed

   layout.sectionInset = UIEdgeInsetsMake(0,0,0,20); // Adjust top, left, bottom, and right insets as needed


// Initialize collection view
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width, 300) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorNamed:@"grey"]; // Set your desired background color
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
   

    [self.view addSubview:self.collectionView];
    
  

    [self addPhotoButton];

        noPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
        // Center the button within the view
        noPhotoLabel.textAlignment = NSTextAlignmentCenter;
        noPhotoLabel.textColor = [UIColor systemGray3Color];
        noPhotoLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        noPhotoLabel.text = @"Press plus button to add photos";
        [self.collectionView addSubview:noPhotoLabel];
    if (self.imagesArray.count == 0){
        noPhotoLabel.alpha = 1;
   }
    else {
        noPhotoLabel.alpha = 0;
    }

    
    [self registerActionView];

    [self addCloseButton];
    // define a variable to store initial touch position
    initialTouchPoint  = CGPointMake(0, 0);
    
    self.colorCollection = [NSMutableArray array];
    self.buttonCollection = [NSMutableArray array];
    
    self.colorCollection = [[[NSUserDefaults standardUserDefaults] objectForKey:@"colorCollection"]mutableCopy];
    
    if(!self.isIpad){
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];
    }
  
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    
    
    CGSize size = self.view.bounds.size;
    
    CGFloat screenPartitionIdx;
    CGFloat screenPartitionWidth;

    CGFloat colorButtonSize;
    CGFloat distance;
    CGFloat correctionIdx;
    CGFloat fontSize;
    CGFloat axeYLift;
    CGFloat axeYforSE;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        screenPartitionIdx = size.height / 12;
        screenPartitionWidth = size.width / 20;

        colorButtonSize = 36;
        distance = 60;
        correctionIdx = 38;
        fontSize = 18;
        axeYLift = 120;
        axeYforSE = 0;
    
    }else {
        
        screenPartitionIdx = size.height / 20;
        screenPartitionWidth = size.width / 20;

        colorButtonSize = 26;
        distance = 36;
        correctionIdx = 0;
        fontSize = 14;
        axeYforSE = 0;

        
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        NSLog(@" difffff %f",screenSize.size.height / screenSize.size.width);

        if(screenSize.size.height / screenSize.size.width < 2){
            axeYLift = 20;
            axeYforSE = 20;

            
        }
        else {
            axeYLift = 0;

        }
    }
    
    
}





-(void)addColorButtons:(CGFloat)x height:(CGFloat)height buttonWidth:(CGFloat)width distance:(CGFloat)distance{
    int colorNumber = 0;
    for (int i=0; i<=1; i++) {
        for (int j=0; j<=5; j++) {
            
            ColorButton * colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(x +(j*distance), height +(i*distance), width, width);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            colorButton.tag = colorNumber;
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
            colorButton.layer.cornerRadius = width / 2;
            colorButton.layer.masksToBounds = YES;
            
            colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
            colorButton.layer.borderWidth = 0.0f;
            colorNumber ++;
            
            
           //dispatch_sync(dispatch_get_main_queue(), ^{
               [self.buttonCollection addObject:colorButton];
                [self.view addSubview:colorButton];
          // });//end block
            

        }
    }
}


-(int)startingColor:(UIColor*)color{
    
    int idx;
    for (int i=0; i < self.colorCollection.count; i++) {
        
        if (CGColorEqualToColor(self.startColor.CGColor, [GzColors colorFromHex:[self.colorCollection objectAtIndex:i]].CGColor))
        {
            idx = i;
        }
    }
    return idx;
}
-(void)addCloseButton{
    CGFloat startOfButton;
    CGFloat startY;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfButton = 54;
        startY = 10;
    }else {
        startOfButton = 42;
        startY = 10;
    }
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - startOfButton, self.view.frame.origin.y + startY, 30, 30)];
    [more addTarget:self
             action:@selector(closeView:)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
   // [more setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
    [more setImage:[UIImage systemImageNamed:@"xmark" withConfiguration:conf] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    [self.view addSubview:more];
}
-(void)addTitle{
    CGFloat startOfButton;
    CGFloat startY;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startY = 10;
    }else {
        startY = 18;
    }
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + startY, self.view.frame.size.width, 30)];
    
//    CGPoint titleCenter = CGPointMake(self.view.center.x, self.view.frame.origin.y + startY);
//    title.center = titleCenter;
    title.text = @"Colors";
    title.textColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
    title.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}
-(void)addPhotoButton{
    CGFloat startOfButton;
    CGFloat startY;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfButton = 24;
        startY = 10;

    }else {
        startOfButton = 12;
        startY = 10;

    }
    restoreBtn = [[ColorResetButton alloc] initWithFrame:CGRectMake(startOfButton, startY, 30, 30)];
    [restoreBtn addTarget:self
             action:@selector(showMenu)
   forControlEvents:UIControlEventTouchUpInside];
    [restoreBtn.widthAnchor constraintEqualToConstant:30].active = YES;
    [restoreBtn.heightAnchor constraintEqualToConstant:30].active = YES;
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
    [restoreBtn setImage:[UIImage systemImageNamed:@"plus" withConfiguration:conf] forState:UIControlStateNormal];
    
    [restoreBtn setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];

    btnRect = restoreBtn.frame;
    [self.view addSubview:restoreBtn];
    [self registerActionView];
   // [self showMenu];
    
}



-(IBAction)closeView:(id)senxer{
   
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)addHorizontalLine:(CGFloat)y {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(0,y)];
    [linePath addLineToPoint:CGPointMake(self.view.frame.size.width,y)];
    line.path = linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 0.1;
    line.strokeColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:line];
}

-(void)addApplyButtonX:(CGFloat)x startY:(CGFloat)y fontSize:(CGFloat)fonttSize{
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(x, y, 120, 40);
    [self.applyBtn addTarget:self action:@selector(applyColorChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn setTitle:@"Set color" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:[UIColor colorNamed:@"textWhiteDeepBlue"] forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:[UIColor colorNamed:@"setColor"] forState:UIControlStateDisabled];
    self.applyBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:fonttSize];
    self.applyBtn.enabled = NO;
    [self.view addSubview:self.applyBtn];

}



-(void)enableGestures{
    [self.presentationController.presentedView.gestureRecognizers.firstObject setEnabled:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)panGestureAction:(UIPanGestureRecognizer*)gesture {
    
    CGPoint location = [gesture locationInView:self.view];
    CGPoint locationInWindow = [gesture locationInView:self.view.window];
    CGFloat frameStart;
    CGPoint startPoint;
    
    CGSize size = self.view.window.bounds.size;
    size.height = size.height - 400;
    
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        initialTouchPoint = location;
        
        frameStart = self.view.frame.origin.y;
        startPoint = locationInWindow;
    }
    if(gesture.state == UIGestureRecognizerStateChanged){
        
        NSLog(@"diff %f - %f", startPoint.y, location.y );
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (location.y - initialTouchPoint.y), self.view.frame.size.width, self.view.frame.size.height);
              NSLog(@"origin Y %f", self.view.frame.origin.y);
       
        
        if(self.view.frame.origin.y - (frameStart + 400)  > 200){
            NSLog(@"if > 200");

            [UIView animateWithDuration:0.5 animations:^{
                self.view.frame = CGRectMake(self.view.frame.origin.x, 800, self.view.frame.size.width, self.view.frame.size.height);
                
            } completion:^(BOOL finished){
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [self dismissViewControllerAnimated:true completion:nil];

            
            
        }
        if(self.view.frame.origin.y < (size.height)){
            self.view.frame = CGRectMake(self.view.frame.origin.x, size.height, self.view.frame.size.width, 400);
            NSLog(@"if < 00");
        }
    }

    if(gesture.state == UIGestureRecognizerStateEnded ){

        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, size.height, self.view.frame.size.width,400);
            
        } completion:^(BOOL finished){
        }];
    }


}



//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 500, 600);
//}



#pragma mark - Popover

-(void)registerActionView{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    

    NSMutableArray* actions = [[NSMutableArray alloc] init];
    NSMutableArray* actions2 = [[NSMutableArray alloc] init];
    
    // if (@available(iOS 14.0, *)) {
    
    restoreBtn.showsMenuAsPrimaryAction = true;
    
    
    
    [actions addObject:[UIAction actionWithTitle:@"Gallery"
                                           image:[UIImage systemImageNamed:@"photo"]
                                      identifier:nil
                                         handler:^(__kindof UIAction* _Nonnull action) {
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [actions addObject:[UIAction actionWithTitle:@"Camera"
                                           image:[UIImage systemImageNamed:@"camera"]
                                      identifier:nil
                                         handler:^(__kindof UIAction* _Nonnull action) {
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    UIMenu* menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:actions];
    
    // more.offset = CGPointMake(0, 40);
    if (@available(iOS 16.0, *)) {
        //   menu.preferredElementSize = UIMenuElementSizeMedium;
    } else {
        // Fallback on earlier versions
    }
    
    restoreBtn.menu = menu;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    

    
    if (@available(iOS 13.0, *)) {
                       UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
                       [cell.contentView addInteraction:interaction];
                   }
   
    cell.delegate = self;
   // cell.indexPath = indexPath;
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
    

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize  newsize;
    newsize = CGSizeMake(CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)));
    if ( UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
       newsize.width = 300;
       newsize.height = 300;
        return newsize;
   }
   else
   {
       newsize.width = 300;
       newsize.height = 300;
       
        return newsize;
    }
}


#pragma mark - UICollectionViewDelegate

// Implement delegate methods as needed

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Handle cell selection here
    
    // You can get the selected cell using the indexPath
    ImageCollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    // Perform any actions you want with the selected cell
    // For example, you can change its background color
    selectedCell.contentView.backgroundColor = [UIColor blueColor];
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    [self showImageFullScreen: selectedCell.imageView.image];
        
    // You can also access the data associated with the selected cell
    // Assuming you have an array of data representing each cell
    //id selectedData = self.imagesArray[indexPath.item];
    
    // Perform any additional actions based on the selected data
    
    
}





- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                   previewProvider:nil
                                                    actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
        
        // Create and return your custom UIMenu here
        UIAction *action = [UIAction actionWithTitle:@"Delete" image:nil identifier:nil handler:^(UIAction * _Nonnull action) {
            // Handle the action
            
            
            CGPoint point = [interaction locationInView:self.collectionView];
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];

            
            [self.imagesArray removeObjectAtIndex:indexPath.item];
            
            if (self.imagesArray.count == 0){
                noPhotoLabel.alpha = 1;
            }
            else {
                [noPhotoLabel setAlpha:0];
            }
            NSLog(@"imagesCount %lu", self.imagesArray.count);
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.delegate savePhotos:self.imagesArray];

            
            if (self.imagesArray.count < 6){
                
                restoreBtn.enabled = YES;
            }
            
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCellAtIndexPath:)]) {
//                                       [self.delegate deleteCellAtIndexPath:indexPath];
//                                    }
        }];
        UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[action]];
        return menu;
    }];
}

#pragma mark - ImagePickerMethods


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    // Do something with the selected image
    
    [self.imagesArray addObject:selectedImage];
    [self amplitudeEvent:@"Photo Picked Up"];

    
    [self.delegate savePhotos:self.imagesArray];

    if (self.imagesArray.count == 0){
        noPhotoLabel.alpha = 1;
    }
    else {
        noPhotoLabel.alpha = 0;
    }
    if (self.imagesArray.count ==6){
        
        restoreBtn.enabled = NO;
    }
    

    [self.collectionView reloadData];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   
    if (self.imagesArray.count > 0){
        noPhotoLabel.alpha = 0;
    }
    else {
        noPhotoLabel.alpha = 1;
    }
    [self.collectionView reloadData];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notes Methods

-(void)showImageFullScreen:(UIImage*)img{
    
    NSLog(@"View Controllers in Storyboard: %@", [self.storyboard instantiateInitialViewController]);

    // Assuming you're in a view controller and want to present another view controller modally

//    ImagePreviewController *  imagePreview = [self.storyboard instantiateViewControllerWithIdentifier:@"imagePreview"];
    ImagePreviewController * imagePreview = [[ImagePreviewController alloc]init];
    [self prepareOverlay:imagePreview];
   // imagePreview.isIpad  = NO;
   // controller.startColor = currentColor;
    imagePreview.imgFromPhoto = img;
    [self presentViewController:imagePreview animated:true completion:nil];

}
- (void)prepareOverlay:(ImagePreviewController*)viewController {
    
    self.overlayDelegate = [[VCPresentationDelegate alloc]init];
    viewController.transitioningDelegate = self.overlayDelegate;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Amplitude Analytics

-(void)amplitudeEvent:(NSString*)eventName{
    
    AMPConfiguration* configuration = [AMPConfiguration initWithApiKey:@"b377e11e11508029515d06b38d06a0ce"];
    //configuration.serverZone = AMPServerZoneEU;
    Amplitude * amplitude = [Amplitude initWithConfiguration:configuration];
    [amplitude track:eventName eventProperties:nil];

}

@end
