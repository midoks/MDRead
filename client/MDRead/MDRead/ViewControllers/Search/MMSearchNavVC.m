//
//  MMSearchNavViewController.m
//  MDRead
//
//  Created by midoks on 16/6/22.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSearchNavVC.h"
#import "MMNovelApi.h"
#import "MMCommon.h"

@interface MMSearchNavVC () <UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>

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
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"%@", searchBar.text);
    [[MMNovelApi shareInstance] Search:searchBar.text success:^(id _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
   
        _tableData = responseObject;
        [_tableView reloadData];
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%d:%@", ret_code, ret_msg]];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [[_tableData objectAtIndex:indexPath.row] objectForKey:@"book_name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
