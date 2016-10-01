//
//  MMBooklookViewController.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooklookVC.h"
#import "MMLookView.h"
#import "MMSimPageVC.h"

@interface MMBooklookVC ()

@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, assign) BOOL isHidden;


@property (nonatomic, strong) NSMutableArray* pageContent;
@property (nonatomic, strong) MMSimPageVC* pageVC;
@property (nonatomic, strong) UIPageViewController *pagesVC;


@end

@implementation MMBooklookVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self loadViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData {

}

-(void)loadViewInit
{
    self.isHidden = YES;
    [self initNavBtn];
    [self hiddenNavBtn];
    
    [self initLookView];
}

-(void)handleShowView:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBarHidden){
        [self showNavBtn];
    } else {
        [self hiddenNavBtn];
    }
}


-(void)initNavBtn
{
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    [self.view addGestureRecognizer:_tapGesture];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)hiddenNavBtn
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.isHidden = NO;
}

-(void)showNavBtn
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.isHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
}

-(void)initLookView
{
    MMLookView *lookView = [[MMLookView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:lookView];
    
    [self createContentPages];
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pagesVC = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    //_pageVC = [[MMSimPageVC alloc] init];
    
    _pagesVC.dataSource = self;
    [[_pagesVC view] setFrame:[[self view] bounds]];
//
    MMSimPageVC *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pagesVC setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:_pagesVC];
    [[self view] addSubview:[_pagesVC view]];
    [_pagesVC didMoveToParentViewController:self];
}

-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 状态栏设置
- (BOOL)prefersStatusBarHidden
{
    return self.isHidden;
}



- (NSUInteger)indexOfViewController:(MMSimPageVC *)viewController
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
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(MMSimPageVC *)viewController
{
    
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(MMSimPageVC *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (MMSimPageVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MMSimPageVC *dataViewController = [[MMSimPageVC alloc] init];
    dataViewController.dataObject = [_pageContent objectAtIndex:index];
    return dataViewController;
}


@end
