//
//  MMBooklookViewController.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooklookVC.h"
#import "MMSimPagesVC.h"
#import "MMNovelApi.h"
#import "MMReadModel.h"
#import "MMCommon.h"


@interface MMBooklookVC ()

@property (nonatomic, strong) NSMutableArray* pageContent;
@property (nonatomic, strong) MMSimPagesVC* pageVC;
@property (nonatomic, strong) UIPageViewController *pagesVC;

@end

@implementation MMBooklookVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMReadModel *mmrm = [MMReadModel shareInstance];
    mmrm.bookInfo = _bookInfo;

    [mmrm parseBookContent:^(id responseObject) {
        [self initLookView:[responseObject objectForKey:@"content"]];
        [self initTap];
    } failure:^(int ret_code, NSString *ret_msg) {
        //MDLog(@"%d:%@", ret_code, ret_msg);
        
        [MMCommon showMessage:ret_msg];
        
        [self dismissViewControllerAnimated:NO completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)initLookView:(NSString *)content
{
    [self createContentPages];
    NSDictionary *options = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pagesVC = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                               navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal
                                                             options: options];
    
    _pagesVC.dataSource = self;
    [[_pagesVC view] setFrame:[[self view] bounds]];
    
    MMSimPagesVC *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.bookContent = content;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    
    [_pagesVC setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
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
