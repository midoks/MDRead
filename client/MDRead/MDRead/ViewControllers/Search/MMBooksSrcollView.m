//
//  MMBooksScollView.m
//  MDRead
//
//  Created by midoks on 16/6/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooksSrcollView.h"

#import "MMBookCell.h"
#import "MMCommon.h"

#import "UIImageView+WebCache.h"


static NSString *collectViewIdentifier = @"MMBooksSrcollView_collectViewIdentifier";

@interface MMBooksSrcollView() <UICollectionViewDataSource , UICollectionViewDelegate>


@property(nonatomic, strong) UICollectionView *collectView;
@property(nonatomic, strong) NSMutableArray *collectData;

@end

@implementation MMBooksSrcollView


-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]){

        [self initTitle];
        [self initView];
    }
    return self;
}


-(void)initTitle
{
    _sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 20)];
    _sectionTitle.text = @"-- 榜单 --";
    _sectionTitle.textAlignment = NSTextAlignmentCenter;
    _sectionTitle.font = [UIFont systemFontOfSize:12];
    _sectionTitle.textColor = [UIColor orangeColor];
    
    [self addSubview:_sectionTitle];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(10+5, 10, 90, 1)];
    leftLine.layer.opacity = 0.3;
    leftLine.backgroundColor = [UIColor grayColor];
    [self addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-10-90-5, 10, 90, 1)];
    rightLine.layer.opacity = 0.3;
    rightLine.backgroundColor = [UIColor grayColor];
    [self addSubview:rightLine];
}

-(void)initView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, self.frame.size.height - 20) collectionViewLayout:flowLayout];
    
    _collectView.delegate = self;
    _collectView.dataSource = self;
    
    CGFloat imageW = (MD_DW-40)/4.0;
    CGFloat imageH = (imageW/4)*5 + 30;
    
    flowLayout.itemSize = CGSizeMake(imageW, imageH);
    flowLayout.minimumLineSpacing = 3;//定义每个UICollectionView 纵向的间距
    flowLayout.minimumInteritemSpacing = 0;//定义每个UICollectionView 的边距距
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);//上左下右
    
   
    _collectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectView registerClass:[MMBookCell class] forCellWithReuseIdentifier:collectViewIdentifier];

    _collectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectView];
}


-(void)initViewData:(NSMutableArray *)data
{
    _collectData = data;
    [_collectView reloadData];
}

#pragma mark - UICollectionView delegate && dataSource -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectViewIdentifier forIndexPath:indexPath];
    
    NSDictionary *tmp = [_collectData objectAtIndex:indexPath.row];
    
    if (tmp) {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:[tmp objectForKey:@"book_image"]]
                              placeholderImage:[UIImage imageNamed:@"books_test"]];
        cell.bookName.text = [tmp objectForKey:@"book_name"];
    } else {
        cell.bookImageView.image = [UIImage imageNamed:@"books_test"];
        cell.bookName.text = @"--加载中--";
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", indexPath);
}

@end
