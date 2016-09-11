//
//  MMBookshelfViewController.m
//  MDRead
//
//  Created by midoks on 16/6/19.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookshelfViewController.h"
#import "MMBookshelfCollectionViewCell.h"

#import "MMBookInstroVC.h"

#import "MMCommon.h"
#import "MJRefresh.h"

#import "MMPresentingAnimator.h"
#import "MMDismissingAnimator.h"

static NSString *collectViewIdentifier = @"collectViewIdentifier";

@interface MMBookshelfViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UICollectionView *collectView;

@end

@implementation MMBookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的书架"];
    
    if(true){
        [self initBookShelf];
    } else {
        [self initEmptyDataView];
    }
    
    //self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 初始化空视图
-(void)initEmptyDataView
{
    UIView *bk = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 260)];
    bk.center = self.view.center;
    //[bk setBackgroundColor:[UIColor redColor]];
    
    UIImageView *bookshelf_empty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mb_bookshelf_empty"]];
    //NSLog(@"%@", NSStringFromCGPoint(bk.center));
    
    bookshelf_empty.frame = CGRectMake(bk.frame.size.width/2 - bookshelf_empty.frame.size.width/2, 30, bookshelf_empty.frame.size.width, bookshelf_empty.frame.size.height);
    bookshelf_empty.layer.cornerRadius = 3;
    [bk addSubview:bookshelf_empty];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, bookshelf_empty.frame.size.height + 40, 200, 40)];
    text.text = @"书架空空，等你填满";
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:14];
    [bk addSubview:text];
    
    
    UIButton *sosoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 220, 200, 40)];
    [sosoButton setTitle:@"搜搜看" forState:UIControlStateNormal];
    [sosoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sosoButton.layer.cornerRadius = 3;
    
    sosoButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [sosoButton setBackgroundColor:[UIColor purpleColor]];
    [sosoButton addTarget:self action:@selector(sosoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bk addSubview:sosoButton];
    
    [self.view addSubview:bk];
}

-(void)sosoBtnClick
{
    self.tabBarController.selectedIndex = 1;
}

-(void)initBookShelf
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    
    _collectView.delegate = self;
    _collectView.dataSource = self;
    
    flowLayout.itemSize = CGSizeMake((MDDeviceW - 20)/3, 180);
    flowLayout.minimumLineSpacing = 3;//定义每个UICollectionView 纵向的间距
    flowLayout.minimumInteritemSpacing = 0;//定义每个UICollectionView 的边距距
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);//上左下右
    
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectView registerClass:[MMBookshelfCollectionViewCell class] forCellWithReuseIdentifier:collectViewIdentifier];
    
    _collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        [self.recommend initRecommendData:^{
//        }];
        
        [self.collectView.mj_header endRefreshing];

        
    }];
    
    [self.view addSubview:_collectView];
}


#pragma mark - UICollectionView delegate && dataSource -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMBookshelfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectViewIdentifier forIndexPath:indexPath];
    
    cell.bookImageView.image = [UIImage imageNamed:@"books_test"];
    [cell sizeToFit];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", indexPath);
    [self presentClick];
}

- (void)presentClick
{
    MMBookInstroVC *bookInstro = [[MMBookInstroVC alloc] init];
    bookInstro.hidesBottomBarWhenPushed = YES;
    
    //[self.navigationController pushViewController:bookInstro animated:YES];
    
    UINavigationController *ss = [[UINavigationController alloc] initWithRootViewController:bookInstro];
    ss.transitioningDelegate = self; // 必须second同样设置delegate才有动画
    [self presentViewController:ss animated:YES completion:^{
    }];
}


// present动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    MMPresentingAnimator *a = [[MMPresentingAnimator alloc] init];
    a.targetEdge = UIRectEdgeRight;
    return a;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    MMDismissingAnimator *a = [[MMDismissingAnimator alloc] init];
    a.targetEdge = UIRectEdgeLeft;
    return a;
}

@end
