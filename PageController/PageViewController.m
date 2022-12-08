//
//  ViewController.m
//  PageViewController
//
//  Created by Imanou on 19/09/2017.
//  Copyright © 2017 Imanou. All rights reserved.
//

#import "PageViewController.h"
#import "PageView.h"

@interface PageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation PageViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        //[[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor blackColor]];
        //[[UIPageControl appearance] setPageIndicatorTintColor:[UIColor grayColor]];
        [self.view setBackgroundColor:[UIColor colorNamed:@"grey"]];

        self.array = @[
                       @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                       @"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                       @"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                       @"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                       ];
        
        PageView *initialViewController = [self viewControllerWithPageIndex:0];
        [self setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return self;
}


    
-(BOOL)prefersStatusBarHidden {
    return true;
}
#pragma mark - Custom methods

- (PageView *)viewControllerWithPageIndex:(NSInteger)pageIndex {
    if (pageIndex < 0 || pageIndex >= [self.array count]) {
        return nil;
    }
    PageView *viewController = [[PageView alloc] init];
    viewController.text = self.array[pageIndex];
    viewController.pageIndex = pageIndex;
  
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PageView *vc = (PageView *)viewController;
    NSUInteger index = vc.pageIndex;
    return [self viewControllerWithPageIndex:(index + 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PageView *vc = (PageView *)viewController;
    NSUInteger index = vc.pageIndex;
    return [self viewControllerWithPageIndex:(index - 1)];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.array.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return [(PageView *)pageViewController.presentedViewController pageIndex];
}

@end
