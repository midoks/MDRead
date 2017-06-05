//
//  MMBooksTableViewCell.m
//  MDRead
//
//  Created by midoks on 16/6/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooksTableViewCell.h"
#import "MMBookCell.h"

#import "MMCommon.h"
#import "MMNovelApi.h"

#import "UIImageView+WebCache.h"

#import "MMBookInstroVC.h"

static NSString *collectViewIdentifier = @"collectViewIdentifier";

@interface MMBooksTableViewCell() <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectView;

@property(nonatomic, strong) id  _Nullable dataList;

@property(nonatomic, copy) mdItemClick itemClickBlock;

@end

@implementation MMBooksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(id)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"MMBooksTableViewCell";
    
    MMBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MMBooksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        [self initTableCellView];
        [self initBookList];
        _numRows = 2;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initTableCellView
{
    UILabel *sign = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 3, 20)];
    //sign.backgroundColor = [UIColor colorWithRed:0 green:125 blue:218 alpha:1];
    sign.backgroundColor = [UIColor grayColor];
    [self addSubview:sign];
    
    _sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
    _sectionTitle.text =  @"SectionTitle";
    _sectionTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_sectionTitle];
}

-(void)initBookList
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 25, MD_DW - 20, 0) collectionViewLayout:_flowLayout];
    
    _collectView.delegate = self;
    _collectView.dataSource = self;
    
    //w:h = 4:5
    CGFloat imageW = (MD_DW-40)/4.0;
    CGFloat imageH = (imageW/4)*5 + 30;
    
    
    _flowLayout.itemSize = CGSizeMake(imageW, imageH);
    _flowLayout.minimumLineSpacing = 0;//定义每个UICollectionView 纵向的间距
    _flowLayout.minimumInteritemSpacing = 0;//定义每个UICollectionView 的边距距
    _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);//上左下右
    
    _collectView.backgroundColor = [UIColor whiteColor];
    
    _collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [_collectView registerClass:[MMBookCell class] forCellWithReuseIdentifier:collectViewIdentifier];
    
    _collectView.scrollEnabled = NO;
    
    [self addSubview:_collectView];
}

-(void)initRecommendData:(void (^)())success
{
    _numRows = 2;
    [[MMNovelApi shareInstance] recommend:^(id responseObject) {
        //MDLog(@"%@", responseObject);
        _dataList = responseObject;
        [self reloadData];
        success();
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%@", ret_msg]];
    }];
}

-(NSInteger)recommendHeight
{
    CGFloat imageW = (MD_DW-40)/4.0;
    CGFloat imageH = (imageW/4)*5 + 30;
    
    return 25 + imageH*2 + 10 + 5;
}

-(void)initRandData:(void (^)())success
{
    _numRows = 1;
    [[MMNovelApi shareInstance] rand:^(id responseObject) {
        _dataList = responseObject;
        [self reloadData];
        success();
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%@", ret_msg]];
    }];
}

-(NSInteger)randHeight
{
    CGFloat imageW = (MD_DW-40)/4.0;
    CGFloat imageH = (imageW/4)*5 + 30;
    return 25 + imageH + 5 + 5;
}

-(void)reloadData
{
    [_collectView reloadData];
}

#pragma mark - UICollectionView delegate && dataSource -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _numRows;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectViewIdentifier forIndexPath:indexPath];
    
    NSDictionary *tmp = [_dataList objectAtIndex:(indexPath.section * 4 + indexPath.row)];
    
    if (tmp) {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:[tmp objectForKey:@"image"]]
                              placeholderImage:[UIImage imageNamed:@"books_test"]];
        cell.bookName.text = [tmp objectForKey:@"name"];
    } else {
        cell.bookImageView.image = [UIImage imageNamed:@"books_test"];
        cell.bookName.text = @"--加载中--";
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmp = [_dataList objectAtIndex:(indexPath.section * 4 + indexPath.row)];
    if (_itemClickBlock){
        _itemClickBlock(tmp);
    }
}

-(void)itemClick:(mdItemClick)block
{
    self.itemClickBlock = block;
}

@end
