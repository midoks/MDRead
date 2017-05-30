//
//  MMBookListVC.m
//  MDRead
//
//  Created by midoks on 2016/11/26.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookListVC.h"
#import "MMNovelApi.h"
#import "MMReadModel.h"


@interface MMBookListVC () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chapterList;

@end

@implementation MMBookListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"目录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MD_W, MD_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    MMReadModel *s = [[MMReadModel shareInstance] readModel];
    MDLog(@"%@", s);
    
    //MDLog(@"%@", self.bookInfo);
    [[MMNovelApi shareInstance] BookList:[_bookInfo objectForKey:@"bid"] source_id:[_bookInfo objectForKeyedSubscript:@"sid"] success:^(id responseObject) {
        //MDLog(@"%@", responseObject);
        _chapterList = [responseObject objectForKey:@"data"];
        [_tableView reloadData];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        MDLog(@"%d:%@", ret_code, ret_msg);
    }];
    
}


-(void)cancelButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chapterList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *info = [_chapterList objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
