//
//  MMSettingsViewController.m
//  MDRead
//
//  Created by midoks on 16/6/19.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSettingsVC.h"

#import "MMReadSettingVC.h"
#import "MMAboutVC.h"


#import <MessageUI/MFMailComposeViewController.h>

@interface MMSettingsVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MMSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    
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
        return 1;
    } else if (section == 1){
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    if(indexPath.section == 0){
        
        if (indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"md_s_booksetting"];
            cell.textLabel.text = @"阅读设置";
        }
        
    } else if(indexPath.section == 1){
        
        if (indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"md_s_zan"];//md_s_zan
            cell.textLabel.text = @"好评支持一下";
        } else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"md_s_advise"];
            cell.textLabel.text = @"APP意见反馈";
        }
        
    } else {
        
        cell.imageView.image = [UIImage imageNamed:@"md_s_about"];
        cell.textLabel.text = @"关于";
    }
    
    //cell.textLabel.text = [indexData objectForKey:@"bookname"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0) {
        
        MMReadSettingVC *read = [[MMReadSettingVC alloc] init];
        read.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:read animated:TRUE];
        
    } else if (indexPath.section == 1){
        if (indexPath.row == 0){
            
            [self goAppScore];
            
        } else if (indexPath.row == 1) {
            [self goSuggect];
            //            MMSuggestVC *sug = [[MMSuggestVC alloc] init];
            //            [self.navigationController pushViewController:sug animated:TRUE];
        }
    } else {
        MMAboutVC *about = [[MMAboutVC alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:TRUE];
    }
    
}

#pragma mark - 去评分 -
-(void)goAppScore
{
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", 1059963031];
    NSURL *goUrl = [[NSURL alloc] initWithString:url];
    [[UIApplication sharedApplication] openURL:goUrl];
}

#pragma mark - MFMailComposeViewControllerDelegate -
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
        
        } else if (result == MFMailComposeResultCancelled){
            NSLog(@"mail send fail");
            //[self showAlert:@"提示" msg:@"你已经取消反馈了!!!"];
        }
    }];
}

#pragma mark 意见反馈
-(void)goSuggect
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    
    if (mail.isBeingPresented) {
        
        [mail setToRecipients:[NSArray arrayWithObject:@"midoks@163.com"]];
        [mail setSubject:@"阅读APP-意见反馈"];
        [mail setMessageBody:@"" isHTML:NO];
        [self presentViewController:mail animated:YES completion:^{}];
    } else {
        //NSLog(@"mail test");
    }
    
}








@end
