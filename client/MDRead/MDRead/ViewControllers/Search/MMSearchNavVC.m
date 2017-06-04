//
//  MMSearchNavViewController.m
//  MDRead
//
//  Created by midoks on 16/6/22.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSearchNavVC.h"
#import "MMSearchCell.h"
#import "MMNovelApi.h"
#import "MMCommon.h"
#import "MMBookInstroVC.h"

#import "MMPresentingAnimator.h"
#import "UIImageView+WebCache.h"


@interface MMSearchNavVC () <UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UISearchBar *search;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id _Nonnull tableData;

@end

@implementation MMSearchNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableData = [[NSMutableDictionary alloc] init];
    
    [self initTableView];
    [self initTableSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:_tableView];
}

-(void)initTableSearch
{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                                            CGRectGetMinY(mainViewBounds) + 22,
                                                            mainViewBounds.size.width-50, 40)];
    
    _search.placeholder = @"书名、作者名、关键字";
    _search.delegate = self;
    _search.showsCancelButton = NO;
    
    [_search setSearchBarStyle:UISearchBarStyleMinimal];
    [_search becomeFirstResponder];
    
    [self.navigationController.view addSubview:_search];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightCancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)rightCancelButtonClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UISearchBarDelegate -
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}

#pragma mark - cancel -
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //MDLog(@"%@", searchBar.text);
    [[MMNovelApi shareInstance] Search:searchBar.text success:^(id _Nonnull responseObject) {
        //MDLog(@"%@", responseObject);
        
        int code = [[responseObject objectForKey:@"ret_code"] intValue];
        if (code > -1){
            _tableData = [responseObject objectForKey:@"data"];
            [_tableView reloadData];
        } else {
            NSString *ret_msg = [responseObject objectForKey:@"ret_msg"];
            [MMCommon showMessage:[NSString stringWithFormat:@"%@", ret_msg]];
        }
        
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%@", ret_msg]];
    }];
    
    [searchBar resignFirstResponder];
    
}

-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMSearchCell *cell = [[MMSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MMSearchNavVC"];
    
    [cell setSTitle:[[_tableData objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell setSDesc:[[_tableData objectAtIndex:indexPath.row] objectForKey:@"desc"]];
    
    NSString *image = [[_tableData objectAtIndex:indexPath.row] objectForKey:@"image"];
    [cell setSImage:image];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSDictionary *item = [_tableData objectAtIndex:indexPath.row];
    MMBookInstroVC *bookInstro = [[MMBookInstroVC alloc] init];
    bookInstro.bookInfo = item;
    
    UINavigationController *bookInstroView = [[UINavigationController alloc] initWithRootViewController:bookInstro];
    bookInstroView.transitioningDelegate = self;
    
    [self presentViewController:bookInstroView animated:YES completion:^{}];
    
}

#pragma mark - 动画效果 -
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    MMPresentingAnimator *a = [[MMPresentingAnimator alloc] init];
    a.targetEdge = UIRectEdgeRight;
    return a;
}

@end
