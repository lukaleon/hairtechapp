//
//  OverlayTransitioningDelegate.m
//  CustomPresentation
//
//  Created by Raj Dhakate on 13/10/18.
//  Copyright © 2018 Raj Dhakate. All rights reserved.
//

#import "VCPresentationDelegate.h"
#import "OverlayPresentationController.h"
#import "ControllerAnimator.h"

@interface VCPresentationDelegate()

@end

@implementation VCPresentationDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[OverlayPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    ControllerAnimator *animator = [[ControllerAnimator alloc]init];
    animator.isPresenting = true;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[ControllerAnimator alloc]init];
}

@end
