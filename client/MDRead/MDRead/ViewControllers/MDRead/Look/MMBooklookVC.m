//
//  MMBooklookViewController.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooklookVC.h"
#import "MMSimPagesVC.h"

@interface MMBooklookVC ()

@property (nonatomic, strong) NSMutableArray* pageContent;
@property (nonatomic, strong) MMSimPagesVC* pageVC;
@property (nonatomic, strong) UIPageViewController *pagesVC;

@end

@implementation MMBooklookVC

- (void)viewWillAppear:(BOOL)animated
{
    
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    MMSimPagesVC *dataViewController = [[MMSimPagesVC alloc] init];
//    
//    UINavigationController *bookInstroView = [[UINavigationController alloc] initWithRootViewController:dataViewController];
//   
//    [self presentViewController:bookInstroView animated:false completion:^{
//        
//    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:8.0/255.0 green:57.0/255.0 blue:134.0/255.0 alpha:1]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initLookView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)initLookView
{
    
    [self createContentPages];
    NSDictionary *options = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pagesVC = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll
                                               navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal
                                                             options: options];
    
//    _pagesVC = [[UIPageViewController alloc]
//                initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
//                navigationOrientation:UIPageViewControllerNavigationOrientationVertical
//                options: options];
    
    _pagesVC.dataSource = self;
    [[_pagesVC view] setFrame:[[self view] bounds]];
    
    MMSimPagesVC *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pagesVC setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    
    [self addChildViewController:_pagesVC];
    [[self view] addSubview:[_pagesVC view]];
    [_pagesVC didMoveToParentViewController:self];
}

- (NSUInteger)indexOfViewController:(MMSimPagesVC *)viewController
{
    return [_pageContent indexOfObject:viewController.dataObject];
}


- (void)createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++)
    {
        [pageStrings addObject:[NSString stringWithFormat:@"第%d页",i]];
    }
    _pageContent = [[NSMutableArray alloc] initWithArray:pageStrings];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MMSimPagesVC *)viewController
{
    
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(MMSimPagesVC *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        index = 0;
    }
    return [self viewControllerAtIndex:index];
}

- (MMSimPagesVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MMSimPagesVC *dataViewController = [[MMSimPagesVC alloc] init];
    dataViewController.dataObject = [_pageContent objectAtIndex:index];
    return dataViewController;
}

@end
