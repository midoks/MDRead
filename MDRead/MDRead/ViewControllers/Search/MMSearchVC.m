//
//  FileViewController.m
//  MDRead
//
//  Created by midoks on 16/4/12.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSearchVC.h"

#import "MMCommon.h"
#import "MMNovelApi.h"
#import "MJRefresh.h"

#import "MMBookinstroVC.h"
#import "MMSearchNavVC.h"

#import "MMBooksTableViewCell.h"
#import "MMBooksRollTableViewCell.h"

@interface MMSearchVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) MMSearchNavVC *searchResult;

//UI
@property (nonatomic, strong) MMBooksTableViewCell *recommend;
@property (nonatomic, strong) MMBooksTableViewCell *rand;
@property (nonatomic, assign) Boolean randStatus;
@property (nonatomic, strong) MMBooksRollTableViewCell *rank;

@end

@implementation MMSearchVC


-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_search) {
        [_search removeFromSuperview];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController.view addSubview:_search];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initTableSearch];
}


-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initUI];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.recommend initRecommendData:^{
            [self.tableView.mj_header endRefreshing];
        }];
        
    }];
}

-(void)initTableSearch
{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                                            CGRectGetMinY(mainViewBounds) + 22,
                                                            mainViewBounds.size.width, 40)];
    
    _search.placeholder = @"书名、作者名、关键字";
    _search.delegate = self;
    
    [_search setSearchBarStyle:UISearchBarStyleMinimal];
    [self.navigationController.view addSubview:_search];
}

-(void)initUI
{
    [self initRecommend];
    [self initRank];
    [self initRand];
}

-(void)initRecommend
{
    _recommend = [MMBooksTableViewCell cellWithTableView:_tableView];
    _recommend.selectionStyle = UITableViewCellSelectionStyleNone;
    _recommend.sectionTitle.text = @"推荐";
    [_recommend initRecommendData:^{
    }];
    
    [_recommend itemClick:^{
        
        MMBookInstroVC *s = [[MMBookInstroVC alloc] init];
        UINavigationController *bookInstroView = [[UINavigationController alloc] initWithRootViewController:s];
        [self presentViewController:bookInstroView animated:YES completion:^{
            
        }];
    }];
}

-(void)initRank
{
    _rank = [MMBooksRollTableViewCell cellWithTableView:_tableView];
    _rank.selectionStyle = UITableViewCellSelectionStyleNone;
    _rank.sectionTitle.text = @"排行榜";
}

-(void)initRand
{
    _rand = [MMBooksTableViewCell cellWithTableView:_tableView];
    _rand.selectionStyle = UITableViewCellSelectionStyleNone;
    _rand.sectionTitle.text = @"随机";
    _randStatus = NO;
    [_rand initRandData:^{
        self.randStatus = YES;
    }];
}

#pragma mark - UISearchBarDelegate -
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchResult = [[MMSearchNavVC alloc] init];
    UINavigationController *ss = [[UINavigationController alloc] initWithRootViewController:_searchResult];
    [self presentViewController:ss animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2){
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return [_recommend recommendHeight];
    } else if(indexPath.section == 1) {
        return [_rank rollHeight];
    } else if (indexPath.section == 2){
        if(indexPath.row == 0){
            return [_rand randHeight];
        }
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0){
        return _recommend;
    } else if (indexPath.section == 1 ) {
        return _rank;
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0){
            return _rand;
        } else if(indexPath.row == 1) {
            UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            c.textLabel.text = @"换一换";
            c.textLabel.font = [UIFont systemFontOfSize:12];
            c.textLabel.textAlignment = NSTextAlignmentCenter;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MDDeviceW, 0.5)];
            line.layer.opacity = 0.3;
            line.backgroundColor = [UIColor grayColor];
            [c.contentView addSubview:line];
            return c;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == 2){
        if (indexPath.row == 1) {
            if (!_randStatus) {
                [MMCommon showMessage:@"正在请求中!"];
                return;
            }
            //NSLog(@"ddd:%hhd",_randStatus);
            self.randStatus = NO;
            [_rand initRandData:^{
                self.randStatus = YES;
            }];
        }
    }

}



@end
