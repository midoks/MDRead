//
//  MMReadSettingVC.m
//  MDRead
//
//  Created by midoks on 16/8/11.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMReadSettingVC.h"

#import "MMFeedBackVC.h"
#import "MMSourceVC.h"
#import "MMSourceModel.h"
#import "MMSourceListModel.h"
#import "MMNovelApi.h"
#import "MMPingVC.h"

@interface MMReadSettingVC() <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MMSourceListModel *list;

@end

@implementation MMReadSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"阅读设置"];
    
    [self initTableView];
    
    _list = [MMSourceListModel shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if (section == 1){
        return 4;
    } else if (section == 2){
        BOOL s = [[MMNovelApi shareInstance] isExistFeedBack];
        if (s){
            return 3;
        }
        return 1;
    }
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"翻页方式";
    } else if(section == 1){
        return @"预读设置";
    }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    if(indexPath.section == 0){
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"左右翻页";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"层叠翻页";
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"上下翻页";
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"仿真翻页";
        }
        
    } else if(indexPath.section == 1){
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"不预读";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"10章";
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"20章";
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"50章";
        }
        
    } else if (indexPath.section == 2){
        
        if(indexPath.row == 0){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            if (_list.list.count > 0) {
                MMSourceModel *s = [_list getCurrent];
                cell.detailTextLabel.text = s.title;
            }
            cell.textLabel.text = @"切换来源";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2){
            
            cell.textLabel.text = @"接口诊断";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    if( indexPath.section == 2){
        
        if(indexPath.row == 0){
            
            MMSourceVC *source = [[MMSourceVC alloc] init];
            source.title = @"切换来源";
            [self.navigationController pushViewController:source animated:YES];
        } else if(indexPath.row == 1){
            
            MMFeedBackVC *feedback = [[MMFeedBackVC alloc] init];
            feedback.title = @"意见反馈";
            [self.navigationController pushViewController:feedback animated:YES];
        } else if (indexPath.row == 2){
            
            MMPingVC *ping = [[MMPingVC alloc] init];
            
            MMSourceModel *s = [_list getCurrent];
            ping.apiUrl = s.website;
            
            ping.title = @"接口诊断";
            [self.navigationController pushViewController:ping animated:YES];
        }
    }
}

@end
