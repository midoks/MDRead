//
//  MMBookAuthorCell.m
//  MDRead
//
//  Created by midoks on 16/8/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookAuthorCell.h"
#import "MMCommon.h"
#import "MMNovelApi.h"

@interface MMBookAuthorCell() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id tableData;

@end

@implementation MMBookAuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(id)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"MMBookAuthorCell";
    MMBookAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MMBookAuthorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initTableCellView];
        [self initTableVIewList];
        [self initAuthorListData];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initTableCellView
{
    UILabel *sign = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 3, 20)];
    sign.backgroundColor = [UIColor grayColor];
    [self addSubview:sign];
    
    _sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
    _sectionTitle.text =  @"SectionTitle";
    _sectionTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_sectionTitle];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, MDDeviceW, 0.5)];
    line.layer.opacity = 0.3;
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}

-(void)initTableVIewList
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, MDDeviceW, 44*2) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
}

-(NSInteger)authorHeight
{
    return 25 + 44*2;
}

-(void)setData:(id)data
{
    _tableData = data;
}

-(void)reload
{
    [self.tableView reloadData];
}

-(void)initAuthorListData
{
    [[MMNovelApi shareInstance] AuthorList:^(id _Nonnull responseObject) {
        
        self.tableData = responseObject;
        [self.tableView reloadData];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%d:%@", ret_code, ret_msg]];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"test";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    NSDictionary *dict = [_tableData objectAtIndex:indexPath.row];
    //NSLog(@"%@", dict);
    cell.textLabel.text = [NSString stringWithFormat:@"《%@》", [dict objectForKey:@"book_name"]];
    
    if (indexPath.row > 0){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, MDDeviceW - 10, 0.5)];
        line.layer.opacity = 0.3;
        line.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:line];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}




@end
