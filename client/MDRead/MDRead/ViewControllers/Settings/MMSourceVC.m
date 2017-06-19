//
//  MMSourceVC.m
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSourceVC.h"

@interface MMSourceVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MMSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - 添加来源 -
-(void)addSource:(UIButton *)btn
{


    
}


#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"来源(最多设置5个)";
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
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
