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

@property (nonatomic, strong) MMSimPagesVC *pageView;
@property (nonatomic, strong) UIPageViewController *pagesVC;
@property (nonatomic, strong) MMReadModel *readModel;

@end

@implementation MMBooklookVC

-(id)initWithBookInfo:(NSDictionary *)info
{
    self = [super init];
    _bookInfo = info;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)readBook
{
    _readModel = [MMReadModel shareInstance];
    _readModel.bookInfo = _bookInfo;
    
    MDLog(@"readBook ----- start ------");
    
    [_readModel getBookContent:^(id responseObject) {
        [self initLookView:responseObject];
        [self initTap];
        MDLog(@"readBook ----- ok ------");
    } failure:^(int ret_code, NSString *ret_msg) {
        
        [MMCommon showMessage:ret_msg];

        [self dismissViewControllerAnimated:NO completion:^{
            //[[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
        MDLog(@"readBook ----- fail ------");
    }];
    
    MDLog(@"readBook ----- end ------");
}

-(void)goChapter:(NSUInteger)chapter_pos
            page:(NSUInteger)chapter_page
         success:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    _readModel = [MMReadModel shareInstance];
    _readModel.bookInfo = _bookInfo;
    
    [_readModel goBookChapter:chapter_pos page:chapter_page success:^(id responseObject) {
        [self initLookView:responseObject];
        [self initTap];
        success(responseObject);
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:ret_msg];
        
        failure(ret_code, ret_msg);
    }];
}

#pragma mark - 仿真翻页 -
-(void)initLookView:(NSString *)content
{
    NSDictionary *options = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pagesVC = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                               navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal
                                                             options: options];
    
    _pagesVC.dataSource = self;
    [[_pagesVC view] setFrame:[[self view] bounds]];
    
    _pageView = [[MMSimPagesVC alloc] init];
    _pageView.bContent = content;
    _pageView.bTitle = [_bookInfo objectForKey:@"name"];
    //_pageView.view.backgroundColor = [UIColor blueColor];
    NSArray *viewControllers = [NSArray arrayWithObject:_pageView];
    
    [_pagesVC setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];
    
    [self addChildViewController:_pagesVC];
    [[self view] addSubview:[_pagesVC view]];
    [_pagesVC didMoveToParentViewController:self];
}


#pragma mark - UIPageViewControllerDataSource -
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    MDLog(@"上一页");
    MMBooklookVC *s = [[MMBooklookVC alloc] initWithBookInfo:_bookInfo];
    //MDLog(@"%@", _bookInfo);
    [s readBook];
    return s;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{

    MMBooklookVC *s = [[MMBooklookVC alloc] initWithBookInfo:_bookInfo];
    MDLog(@"chapter_pos:%lud", (unsigned long)_readModel.record.chapter_pos);
    s.readModel.record.chapter_pos = _readModel.record.chapter_pos + 1;
    MDLog(@"chapter_pos:%lud", (unsigned long)s.readModel.record.chapter_pos);
    
    
    [s goChapter:2 page:1 success:^(id responseObject) {
        
    } failure:^(int ret_code, NSString *ret_msg) {
        
    }];
    
    return s;
}

@end
