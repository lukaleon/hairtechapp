//
//  IntroViewController.h
//  PageViewController
//
//  Created by Imanou on 19/09/2017.
//  Copyright © 2017 Imanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIViewController

@property (nonatomic) NSString *text;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSString *smallText;


@property (nonatomic, assign) NSInteger pageIndex;
@property (strong, nonatomic)  UIView * bottomView;
@property (strong, nonatomic)  UIImageView * imageview;

- (void)hideTextLabel;
@end
