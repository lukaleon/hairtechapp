//
//  ViewController+NewDrawController.m
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NewDrawController.h"

@implementation NewDrawController


-(void)viewDidLoad{
    [self setupNavigationBarItems];
    arrayOfGrids = [NSMutableArray array];
    [self.img setImage:[UIImage imageNamed:self.imgName]];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 5.0;
    scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self removeGrid];
}
-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
   // [self.drawingView updateZoomFactor:scrollView.zoomScale];
    }

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
      CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);

      scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0.f, 0.f);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.img;
}



#pragma mark NAvigation Bar And Share Setup

- (void)setupNavigationBarItems {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    grid = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [grid addTarget:self
             action:@selector(showOrHideGrid)
   forControlEvents:UIControlEventTouchUpInside];
    [grid.widthAnchor constraintEqualToConstant:30].active = YES;
    [grid.heightAnchor constraintEqualToConstant:30].active = YES;
    [grid setImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
    //[grid setImage:[UIImage imageNamed:@"grid_sel"] forState:UIControlStateSelected];

    [grid setTintColor:[UIColor colorNamed:@"deepblue"]];

    
    UIButton *undo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [undo addTarget:self
             action:@selector(undo)
   forControlEvents:UIControlEventTouchUpInside];
    [undo.widthAnchor constraintEqualToConstant:30].active = YES;
    [undo.heightAnchor constraintEqualToConstant:30].active = YES;
    [undo setImage:[UIImage imageNamed:@"undoNew.png"] forState:UIControlStateNormal];
    [undo setTintColor:[UIColor colorNamed:@"deepblue"]];
    
    UIButton *redo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [redo addTarget:self
             action:@selector(redo)
   forControlEvents:UIControlEventTouchUpInside];
    [redo.widthAnchor constraintEqualToConstant:30].active = YES;
    [redo.heightAnchor constraintEqualToConstant:30].active = YES;
    [redo setImage:[UIImage imageNamed:@"redoNew.png"] forState:UIControlStateNormal];
    [redo setTintColor:[UIColor colorNamed:@"deepblue"]];

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [more addTarget:self
             action:@selector(presentAlertView)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    [more setImage:[UIImage imageNamed:@"dots.png"] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"deepblue"]];

    UIBarButtonItem * gridBtn =[[UIBarButtonItem alloc] initWithCustomView:grid];
    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc]initWithCustomView:undo];
    UIBarButtonItem *redoBtn = [[UIBarButtonItem alloc]initWithCustomView:redo];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreBtn, redoBtn, undoBtn,gridBtn, nil];
}

-(void)presentAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Presenting the great... StackOverFlow!"];
//    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(24, 11)];
//    [alertVC setValue:hogan forKey:@"attributedTitle"];
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"Share"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   [self openShareMenu];
                                                   }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Clear Page"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action){
                                                    [self clearPage];
                                                   }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                       //add code to make something happen once tapped
                                                   }];
  //  [button2 setValue:[[UIImage systemImageNamed:@"trash"]
                     //  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
   // [button setValue:[[UIImage systemImageNamed:@"tray.and.arrow.up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forKey:@"image"];
    [alertVC addAction:button];
    [alertVC addAction:button2];
    [alertVC addAction:button3];
    
    UIBarButtonItem *item = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
        UIView *view = [item valueForKey:@"view"];
    if(view){
        [[alertVC popoverPresentationController] setSourceView:view];
        [[alertVC popoverPresentationController] setSourceRect:view.frame];
        [[alertVC popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];
        [self presentViewController:alertVC animated:true completion:nil];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
-(void)openShareMenu{
    NSLog(@"Open Share Menu");
}
-(void)clearPage{
    NSLog(@"Clear screen");

}

-(void)addGrid{
        NSLog(@"ADD GRID TO VIEW");
        int numberOfRows = self.img.frame.size.height/12;
        int numberOfColumns = self.img.frame.size.width/12;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.25);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
        
        // Drawing column lines

        CGFloat columnWidth = self.img.frame.size.width / (numberOfColumns + 1.0);
        for(int i = 1; i <= numberOfColumns; i++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = columnWidth * i;
            startPoint.y = 0.0f;
            endPoint.x = startPoint.x;
            endPoint.y = self.img.frame.size.height;
            UIBezierPath *path2 = [UIBezierPath bezierPath];
            
            [path2 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
            [path2 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
            CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
            shapeLayer2.path = [path2 CGPath];
            shapeLayer2.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
            shapeLayer2.lineWidth = 0.25;
            shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
            [self.img.layer addSublayer:shapeLayer2];
            [arrayOfGrids addObject:shapeLayer2];

        }
        // Drawing row lines
        // calclulate row height
        CGFloat rowHeight = self.img.frame.size.height / (numberOfRows + 1.0);
        for(int j = 1; j <= numberOfRows; j++)
        {
            CGPoint startPoint;
            CGPoint endPoint;
            
            startPoint.x = 0.0f;
            startPoint.y = rowHeight * j;
            endPoint.x = self.img.frame.size.width;
            endPoint.y = startPoint.y;

        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path1 addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = [path1 CGPath];
        shapeLayer1.strokeColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor;
        shapeLayer1.lineWidth = 0.25;
        shapeLayer1.fillColor = [[UIColor clearColor] CGColor];
        [self.img.layer addSublayer:shapeLayer1];
        [arrayOfGrids addObject:shapeLayer1];
        }
}

-(void)removeGrid{
    for (CAShapeLayer * layer in arrayOfGrids) {
        [layer performSelector:@selector(removeFromSuperlayer)];
    }
    [arrayOfGrids removeAllObjects];
}
-(void)showOrHideGrid{
    if(arrayOfGrids.count == 0){
        [grid setTintColor:[UIColor colorNamed:@"orange"]];
        [self addGrid];
    } else {
        [self removeGrid];
        [grid setTintColor:[UIColor colorNamed:@"deepblue"]];
    }
    
}
@end
