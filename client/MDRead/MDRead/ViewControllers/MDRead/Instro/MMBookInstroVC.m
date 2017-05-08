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

#import "MMCommon.h"


@interface MMBookInstroVC () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MMBooksTableViewCell *rand;
@property (nonatomic, assign) Boolean randStatus;


//@property (nonatomic, strong) MMBookInstroTextCell *bookDesc;

@end

@implementation MMBookInstroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initHeadView];
    [self initFooterView];
    [self initRand];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.navigationController.delegate = self;
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
}

-(void)initFooterView
{
    MMBookInstroBottom *footer = [[MMBookInstroBottom alloc] initWithFrame:CGRectMake(0, MD_DH - 54, MD_DW, 54)];
    [footer buttonClick:^(MMInstroItem state) {
        
        if (state == MMInstroItemAdd) {
            //            NSLog(@"添加书籍");
        } else if (state == MMInstroItemRead) {
            //            NSLog(@"开始阅读");
            
            MMBooklookVC *vc = [[MMBooklookVC alloc] init];
            UINavigationController *bookInstroView = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:bookInstroView animated:YES completion:^{
            }];
        }
    }];
    [self.view addSubview:footer];
}

-(void)initRand
{
    _rand = [MMBooksTableViewCell cellWithTableView:_tableView];
    _rand.selectionStyle = UITableViewCellSelectionStyleNone;
    _rand.sectionTitle.text = @"随机";
    _randStatus = NO;
    [_rand initRandData:^{
        MDLog(@"-- rand ok --");
        self.randStatus = YES;
    }];
}

-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0){
            return [_rand randHeight];
        }
        
    }
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return _rand;
        } else if(indexPath.row == 1){
            UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            c.textLabel.text = @"换一换";
            c.textLabel.font = [UIFont systemFontOfSize:12];
            c.textLabel.textAlignment = NSTextAlignmentCenter;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_DW, 0.5)];
            line.layer.opacity = 0.3;
            line.backgroundColor = [UIColor grayColor];
            [c.contentView addSubview:line];
            return c;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == 1){
        if (indexPath.row == 1) {
            if (!_randStatus) {
                [MMCommon showMessage:@"正在请求中!"];
                return;
            }
            self.randStatus = NO;
            [_rand initRandData:^{
                self.randStatus = YES;
            }];
        }
    }
}

@end
