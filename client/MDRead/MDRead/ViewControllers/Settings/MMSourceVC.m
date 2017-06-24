//
//  MMSourceVC.m
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSourceVC.h"
#import "MMSourceModel.h"
#import "MMSourceListModel.h"
#import "MMScanVC.h"
#import "MMMakeQrcodeVC.h"
#import "MMCommon.h"

@interface MMSourceVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) MMSourceListModel *slist;
@property(nonatomic, assign) NSInteger selectedRow;

@end

@implementation MMSourceVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tableView){
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    _slist = [MMSourceListModel shareInstance];
}

#pragma mark - 添加来源 -
-(void)addSource:(UIButton *)btn
{
    if ([_slist.list count]>=5){
        [MMCommon showMessage:@"来源已经有5个"];
        return;
    }
    
    MMScanVC *v = [[MMScanVC alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger c = _slist.list.count;
    if ( c < 1 ){
        return 1;
    }
    return c;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"来源(最多设置5个)";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSUInteger c = _slist.list.count;
    if ( c < 1 ){
        cell.textLabel.text = @"暂无来源";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    if(indexPath.section == 0){
        
        MMSourceModel *s = [_slist.list objectAtIndex:indexPath.row];
        cell.textLabel.text =  s.title;
        if ( s.selected ){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (_slist.list.count > 0){
        
        _selectedRow = indexPath.row;
     
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"来源管理"
                                                                                 message:@"谨慎操作"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        //来源切换
        UIAlertAction *changeSelected = [UIAlertAction actionWithTitle:@"切换为当前" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self changeSelectedSource];
        }];
        [alertController addAction:changeSelected];
        
        //分享
        UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self shareSource];
        }];
        [alertController addAction:share];
        
        //删除
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self deleteSource];
        }];
        [alertController addAction:delete];
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 删除来源 -
-(void)deleteSource
{
    [_slist.list removeObjectAtIndex:_selectedRow];
    [_slist save];
    [_tableView reloadData];
}

#pragma mark - 分享来源 -
-(void)shareSource
{
    MMSourceModel *s = [_slist.list objectAtIndex:_selectedRow];
    
    MMMakeQrcodeVC *mqrcode = [[MMMakeQrcodeVC alloc] init];
    mqrcode.title = @"分享二维码";
    mqrcode.qrcodeStr = s.website;
    [self.navigationController pushViewController:mqrcode animated:YES];
}

#pragma mark - 切换为当前 -
-(void)changeSelectedSource
{
    [_slist setCurrent:_selectedRow];
    [_tableView reloadData];
}


@end
