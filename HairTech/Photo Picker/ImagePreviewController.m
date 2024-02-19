//
//  ImagePreviewController.m
//  hairtech
//
//  Created by Alexander Prent on 10.02.2024.
//  Copyright © 2024 Admin. All rights reserved.
//

#import "ImagePreviewController.h"

@interface ImagePreviewController ()

@end

@implementation ImagePreviewController


- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
//    panGesture.delegate = self;
//    [self.view addGestureRecognizer:panGesture];
    
    self.presentedViewController.view.userInteractionEnabled = YES;


    // Create a UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    
    // Set the image (replace "imageNamed:" with your actual image name)
   // UIImage *image = [[UIImage alloc]init];
    
    imageView.image = self.imgFromPhoto;
    
    // Set content mode to scale aspect fill
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Enable clipping to bounds to ensure the image does not overflow its bounds
    imageView.clipsToBounds = YES;
    
    // Add the UIImageView to the view controller's view
    [self.view addSubview:imageView];
    
    // Add constraints to make the UIImageView span the full width of the view controller's view
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [self setupNavigationBar];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeNotes:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupNavigationBar{
    CGFloat x;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        x = 80;
    }else{
        x = 65;
    }
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor clearColor];
        appearance.shadowColor =  [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:18]};
        self.navigationItem.standardAppearance = appearance;
        self.navigationItem.scrollEdgeAppearance = appearance;

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -  x, 100, 40, 40)];
    [more addTarget:self
             action:@selector(closeNotes:)
   forControlEvents:UIControlEventTouchUpInside];
    
    [more setTitle:@"Close" forState:UIControlStateNormal];
    more.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [more setTitleColor:[UIColor colorNamed:@"yellow"] forState:UIControlStateNormal];
    more.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]; // Adjust background color // Adjust background color
    // Adjust the frame of the button as per your requirement
    more.frame = CGRectMake(self.view.frame.size.width -  x, 100, 55, 25); // Adjust position and size
    more.layer.cornerRadius = CGRectGetHeight(more.frame) / 2; // Makes the button pill-shaped
    more.layer.masksToBounds = YES;
    
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
//    [more setImage:[UIImage systemImageNamed:@"xmark.circle.fill" withConfiguration:conf] forState:UIControlStateNormal];
//    [more setTintColor:[UIColor colorNamed:@"yellow"]];
    
    
   
   
    
    
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    [self.view addSubview:more];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches moved");
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.view];
    CGPoint previousLocation = [touch previousLocationInView:self.view];
    CGFloat deltaY = currentLocation.y - previousLocation.y;

    CGRect presentedFrame = self.view.frame;
    presentedFrame.origin.y += deltaY;
    self.view.frame = presentedFrame;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGRect presentedFrame = self.view.frame;
    if (presentedFrame.origin.y > self.view.bounds.size.height / 8) {
        // Dismiss the presented view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // Reset the position if not dismissed
        presentedFrame.origin = CGPointZero; // Reset the origin
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = presentedFrame;
        }];
    }
}




@end


