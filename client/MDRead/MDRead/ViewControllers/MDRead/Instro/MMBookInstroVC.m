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
#import "MMBookAuthorCell.h"
#import "MMBookInstroHead.h"
#import "MMBookInstroBottom.h"
#import "MMBookInstroTextCell.h"

#import "MMBooklookVC.h"

#import "MMCommon.h"


@interface MMBookInstroVC () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MMBooksTableViewCell *rand;
@property (nonatomic, assign) Boolean randStatus;

@property (nonatomic, strong) MMBookAuthorCell *authorList;
@property (nonatomic, strong) MMBookInstroTextCell *bookDesc;

@end

@implementation MMBookInstroVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTableView];
    [self initHeadView];
    [self initFooterView];
    [self initRand];
    [self initAuthorList];
    [self initBookDesc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MDDeviceW, MDDeviceH - 50) style:UITableViewStyleGrouped];
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
    MMBookInstroHead *head = [[MMBookInstroHead alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.tableHeaderView = head;
}

-(void)initFooterView
{
    MMBookInstroBottom *footer = [[MMBookInstroBottom alloc] initWithFrame:CGRectMake(0, MDDeviceH - 50, MDDeviceW, 50)];
    footer.backgroundColor = [UIColor whiteColor];
    
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
        self.randStatus = YES;
    }];
}

-(void)initAuthorList
{
    _authorList = [MMBookAuthorCell cellWithTableView:_tableView];
    _authorList.sectionTitle.text = @"作者的其它作品";
}


-(void)initBookDesc
{
    _bookDesc = [[MMBookInstroTextCell alloc] init];
//    _bookDesc.textLabel.text = @"一场穿越时空的爱恋，一场惊心动魄的爱情剧。原本是繁华都市的女生，却因一脚踏空而穿越了时空的隧道。她带着对清史的洞悉进入风云诡变的宫廷。她知道自己不该卷入这场九王夺嫡的争斗中，可心不由己，因为这里有她所爱的，也有爱着她的……\n《步步惊心》情节跌宕起伏、扣人心弦，步步惊心是一本情节与文笔俱佳的都市言情,各位书友要是觉得步步惊心全文阅读还不错的话请不要忘记向您QQ群和微博里的朋友推荐哦！";
    
    [_bookDesc setDesc: @"一场穿越时空的爱恋，一场惊心动魄的爱情剧。原本是繁华都市的女生，却因一脚踏空而穿越了时空的隧道。她带着对清史的洞悉进入风云诡变的宫廷。她知道自己不该卷入这场九王夺嫡的争斗中，可心不由己，因为这里有她所爱的，也有爱着她的……\n《步步惊心》情节跌宕起伏、扣人心弦，步步惊心是一本情节与文笔俱佳的都市言情,各位书友要是觉得步步惊心全文阅读还不错的话请不要忘记向您QQ群和微博里的朋友推荐哦！"];
    
}

-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    NSInteger c = 2;
    c += 1;
    return c;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1){
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            return [_bookDesc getDescSize];
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0){
            return [_rand randHeight];
        }
    } else if(indexPath.section == 2){
        if (indexPath.row == 0){
            return [_authorList authorHeight];
        }
    }
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0){
            return _bookDesc;
        } else if(indexPath.row == 1){
            MMBookInstroCell *cell = [MMBookInstroCell cellWithTableView:_tableView];
            cell.icon.image = [UIImage imageNamed:@"md_chapter_new"];
            cell.title.text = @"最新";
            cell.desc.text = @"第2560章 大结局!";
            cell.status.text = @"连载中";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else if (indexPath.row == 2){
            MMBookInstroCell *cell = [MMBookInstroCell cellWithTableView:_tableView];
            cell.icon.image = [UIImage imageNamed:@"md_dir_list"];
            cell.title.text = @"目录";
            cell.desc.text = @"共1005章";
            cell.enableStatus = FALSE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return _rand;
        } else if(indexPath.row == 1){
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
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return _authorList;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"test";
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
