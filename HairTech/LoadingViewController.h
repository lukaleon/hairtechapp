//
//  LoadingViewController.h
//  HairTech
//
//  Created by Lion on 12/13/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@class LoadingViewController;
@protocol LoadingViewControllerDelegate <NSObject>
-(void)getValue:(int*)value;
-(void)openSubView;
@end

@interface LoadingViewController : UIViewController

@property (weak, nonatomic) id<LoadingViewControllerDelegate>lvdelegate;
@property (weak, nonatomic) IBOutlet UIButton *openLibrary;
@property (nonatomic,assign)BOOL *emptyArray;
@end
