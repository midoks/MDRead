//
//  MMReadSettingVC.m
//  MDRead
//
//  Created by midoks on 16/8/11.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMReadSettingVC.h"

#import "MMSuggestVC.h"

@interface MMReadSettingVC() <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MMReadSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"阅读设置"];
    
    [self initTableView];
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
        return 2;
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
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"10章";
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"20章";
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"50章";
        }
        
    } else if (indexPath.section == 2){
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"切换来源";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"意见反馈";
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
            NSLog(@"切换来源");
        } else if(indexPath.row == 1){
            
            MMSuggestVC *sug = [[MMSuggestVC alloc] init];
            [self.navigationController pushViewController:sug animated:YES];
        }
    }
    
}

@end
