//
//  ContainerViewController.m
//  PageViewController
//
//  Created by Imanou on 20/09/2017.
//  Copyright © 2017 Imanou. All rights reserved.
//

#import "ContainerViewController.h"
#import "PageView.h"


@interface ContainerViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *arrayOfImages;
@property (nonatomic, strong) NSArray *arrayOfTexts;


@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UINavigationBar * bar;

@property (weak, nonatomic) IBOutlet UINavigationItem *item;

@end

@implementation ContainerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.array = @[
                       @"Create new diagrams",
                       @"Select head side",
                       @"Setup tools",
                       @"Share, Delete or Rename"
                       ];
        self.arrayOfImages = @[
                       @"screen1",
                       @"screen2",
                       @"screen1",
                       @"screen1"
                       ];
        self.arrayOfTexts = @[
                       @"When creating a new diagram, choose either the female or male head template, then click 'Continue' and provide a name for the new diagram in the next window.",
                       
                       @"Tap on any head side at the main diagram screen and you will be redirected to drawing space. \r Save the diagram image to the photo gallery by tapping the share button in the top right corner and selecting 'Save to Photos'.",
                       
                       @"From the main diagram editing screen select color and line width by long pressing on any tool button. \r Turn on/off the grid by pressing the 'Grid Icon' located on the top navigation bar.",
                       
                       @"You can share, delete, or rename the diagrams in the 'Collection screen'."
                       ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorNamed:@"grey"]];
    [self.view bringSubviewToFront:self.pageControl];
    
    self.pageControl.numberOfPages = self.array.count;
    self.pageControl.currentPage = 0;
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self setupNavigationBar];
}

-(void)setupNavigationBar{
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor clearColor];
        appearance.shadowColor =  [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:18]};
        self.navigationItem.standardAppearance = appearance;
        self.navigationItem.scrollEdgeAppearance = appearance;

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 30, 30)];
    [more addTarget:self
             action:@selector(closeView)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    [more setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    [self.view addSubview:more];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     Set pageViewController transition style to `scroll` in Storyboard
     */
    self.pageViewController = (UIPageViewController *)segue.destinationViewController;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    PageView *initialViewController = [self viewControllerWithPageIndex:0];
   // initialViewController.view.backgroundColor = [UIColor colorNamed:@"orange"];
    [self.pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom methods

- (PageView *)viewControllerWithPageIndex:(NSInteger)pageIndex {
    if (pageIndex < 0 || pageIndex >= [self.array count]) {
        return nil;
    }
    PageView *viewController = [[PageView alloc] init];
    viewController.text = self.array[pageIndex];
    viewController.imageName = self.arrayOfImages[pageIndex];
    viewController.smallText = self.arrayOfTexts[pageIndex];
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

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        PageView *vc = pageViewController.viewControllers.lastObject;
        self.pageControl.currentPage = vc.pageIndex;
    }

}

#pragma mark - User interaction

- (IBAction)changePage:(id)sender {
    UIPageControl *pageControl = sender;
    PageView *newViewController = [self viewControllerWithPageIndex:pageControl.currentPage];
    PageView *oldViewController = self.pageViewController.viewControllers.lastObject;
    UIPageViewControllerNavigationDirection direction = newViewController.pageIndex > oldViewController.pageIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[newViewController] direction:direction animated:YES completion:nil];

}



@end
