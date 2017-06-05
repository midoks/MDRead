//
//  MMBookInstroViewController.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroVC.h"
#import "MMBookInstroCell.h"
#import "MMBooksTableViewCell.h"
#import "MMBookInstroBottom.h"
#import "MMBooklookVC.h"
#import "MMBookListVC.h"
#import "MMNovelApi.h"
#import "MMCommon.h"

#import "MMPresentingAnimator.h"
#import "UIImageView+WebCache.h"


@interface MMBookInstroVC () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bookInfoList;

@end

@implementation MMBookInstroVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTableView];
    [self initHeadView];
    [self initFooterView];
    
    [self reloadBookInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MD_DW, MD_DH - 54) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
}

-(void)initHeadView
{
    _head = [[MMBookInstroHead alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.tableHeaderView = _head;
    
    [_head btnClick:^(MMBookHeadItem state) {
        //MDLog(@"btn:%d", state);
        MMBookListVC *vc = [[MMBookListVC alloc] init];
        vc.bookInfo = self.bookInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [_head.bImage sd_setImageWithURL:[NSURL URLWithString:[_bookInfo objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"books_test"]];
    _head.bTitle.text = [_bookInfo objectForKey:@"name"];
    _head.bDesc.text = [_bookInfo objectForKey:@"desc"];
    _head.bAuthor.text = [_bookInfo objectForKey:@"author"];
}

-(void)initFooterView
{
    MMBookInstroBottom *footer = [[MMBookInstroBottom alloc] initWithFrame:CGRectMake(0, MD_DH - 54, MD_DW, 54)];
    [footer btnClick:^(MMInstroItem state) {
        
        if (state == MMInstroItemAdd) {
            //NSLog(@"添加书籍");
        } else if (state == MMInstroItemRead) {
            //NSLog(@"开始阅读");
            
            MMBooklookVC *vc = [[MMBooklookVC alloc] init];
            vc.bookInfo = self.bookInfo;
            UINavigationController *bookInstroView = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:bookInstroView animated:YES completion:^{
                
            }];
        }
    }];
    [self.view addSubview:footer];
}

-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - 加载书籍信息 -
-(void)reloadBookInfo
{
    [[MMNovelApi shareInstance] BookInfo:[_bookInfo objectForKey:@"bid"] source_id:[_bookInfo objectForKey:@"sid"] success:^(id responseObject) {
        _bookInfoList = [responseObject objectForKey:@"data"];
        [_tableView reloadData];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:ret_msg];
    }];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookInfoList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSDictionary *info = [_bookInfoList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [info objectForKey:@"name"];
    cell.detailTextLabel.text = [info objectForKey:@"value"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
