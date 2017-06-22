//
//  MMBookRollTableViewCell.m
//  MDRead
//
//  Created by midoks on 16/6/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooksRollTableViewCell.h"

#import "MMNovelApi.h"
#import "MMCommon.h"
#import "MMBooksSrcollView.h"

@interface MMBooksRollTableViewCell() <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *roll;
@property(nonatomic, strong) UIPageControl *pageIndicator;

@property(nonatomic, strong) id list;
@property(nonatomic, copy) mdItemClick itemClickBlock;


@end

@implementation MMBooksRollTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(id)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"MMBookRollTableViewCell";
    
    MMBooksRollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MMBooksRollTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initTableCellView];
        [self initScrollView];
        [self initPageIndicator];
        [self initRankData];
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

-(void)initScrollView
{
    
    NSInteger rollH = [self rollHeight] - 25 - 20;
    
    _roll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 25, MD_DW, rollH)];
    
    _roll.pagingEnabled = YES;
    _roll.scrollEnabled = YES;
    _roll.showsHorizontalScrollIndicator = NO;
    _roll.delegate = self;
    _roll.contentSize = CGSizeMake(MD_DW * 3, rollH);
    //_roll.backgroundColor = [UIColor blueColor];
    
    [self addSubview:_roll];
    
    _pages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i<3; i++) {
        
        MMBooksSrcollView *rollView = [[MMBooksSrcollView alloc] initWithFrame:CGRectMake(MD_DW * i, 0, MD_DW, rollH)];
        rollView.tag = i;
        
        [_pages addObject:rollView];
        [_roll addSubview:rollView];
    }
    [_roll scrollRectToVisible:CGRectMake(MD_DW, 0, MD_DW, rollH) animated:NO];
}

-(void)setClickBlock:(mdItemClick)block
{
    _itemClickBlock = block;
    _currentPage = [_pages objectAtIndex:1];
    [_currentPage itemClick:block];
}

-(void)initPageIndicator
{
    NSInteger rollH = [self rollHeight];
    _pageIndicator = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rollH - 20, self.frame.size.width, 20)];
    _pageIndicator.numberOfPages = 3;
    _pageIndicator.hidesForSinglePage = YES;
    _pageIndicator.pageIndicatorTintColor = [UIColor grayColor];
    _pageIndicator.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [self addSubview:_pageIndicator];
}

-(void)initRankData
{
    [[MMNovelApi shareInstance] BangList:^(id responseObject) {
        //MDLog(@"%@", responseObject);
        _list = responseObject;
        _pageIndicator.numberOfPages = [_list count];
        
        [self goRollPage:@"init"];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:[NSString stringWithFormat:@"%@", ret_msg]];
    }];
}

-(void)goRollPage:(NSString *)op
{
    NSUInteger c = [_list count]-1;
    NSInteger pos = 0;
    
    MMBooksSrcollView *view_left = [_pages objectAtIndex:0];
    MMBooksSrcollView *view_center = [_pages objectAtIndex:1];
    MMBooksSrcollView *view_right = [_pages objectAtIndex:2];
    
    if(!_list){
        [MMCommon showMessage:@"没有数据"];
        return;
    }
    
    if ([op isEqualToString:@"++"]) {
        pos = _pageIndicator.currentPage + 1;
        if (pos > c) {
            pos = 0;
        }
        
        NSInteger prefix_v = (c-1+pos)%c;
        NSInteger suffix_v = (pos+1)%[_list count];
        
        //MDLog(@"p:%ld,c:%ld,s:%ld", (long)prefix_v, (long)pos, (long)suffix_v);

        view_left.sectionTitle.text = [[_list objectAtIndex:prefix_v] objectForKey:@"title"];
        [view_left initViewData:[[_list objectAtIndex:prefix_v] objectForKey:@"data"]];
        
        view_center.sectionTitle.text = [[_list objectAtIndex:pos] objectForKey:@"title"];
        [view_center initViewData:[[_list objectAtIndex:pos] objectForKey:@"data"]];
        
        view_right.sectionTitle.text = [[_list objectAtIndex:suffix_v] objectForKey:@"title"];
        [view_right initViewData:[[_list objectAtIndex:suffix_v] objectForKey:@"data"]];

        
    } else if([op isEqualToString:@"--"]){
        
        pos = _pageIndicator.currentPage - 1;
        if (pos < 0) {
            pos = c;
        }
        
        NSInteger prefix_v = (c+pos) % [_list count];
        NSInteger suffix_v = (pos+1) % [_list count];
        
        //MDLog(@"p:%ld,c:%ld,s:%ld", (long)prefix_v, (long)pos, (long)suffix_v);
        
        view_left.sectionTitle.text = [[_list objectAtIndex:prefix_v] objectForKey:@"title"];
        [view_left initViewData:[[_list objectAtIndex:prefix_v] objectForKey:@"data"]];
        
        view_center.sectionTitle.text = [[_list objectAtIndex:pos] objectForKey:@"title"];
        [view_center initViewData:[[_list objectAtIndex:pos] objectForKey:@"data"]];
        
        view_right.sectionTitle.text = [[_list objectAtIndex:suffix_v] objectForKey:@"title"];
        [view_right initViewData:[[_list objectAtIndex:suffix_v] objectForKey:@"data"]];
        
    } else if([op isEqualToString:@"init"]) {
    
        view_left.sectionTitle.text = [[_list objectAtIndex:c] objectForKey:@"title"];
        [view_left initViewData:[[_list objectAtIndex:c] objectForKey:@"data"]];
        
        view_center.sectionTitle.text = [[_list objectAtIndex:pos] objectForKey:@"title"];
        [view_center initViewData:[[_list objectAtIndex:pos] objectForKey:@"data"]];
        
        view_right.sectionTitle.text = [[_list objectAtIndex:pos+1] objectForKey:@"title"];
        [view_right initViewData:[[_list objectAtIndex:pos+1] objectForKey:@"data"]];
    }

    _pageIndicator.currentPage = pos;
    //MDLog(@"pos:%d", pos);
    _currentPage = _pages[pos%3];
    [_currentPage itemClick:self.itemClickBlock];
}

-(NSInteger)rollHeight
{
    CGFloat imageW = (MD_DW-40)/4.0;
    CGFloat imageH = (imageW/4)*5 + 30;
    return 25 + imageH + 20 + 20 + 10;
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"begin");
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    
    if (index == 1){
    } else if (index > 1 ) {
        [self goRollPage:@"++"];
    } else if (index < 1 ){
        [self goRollPage:@"--"];
    }
    
    NSInteger rollH = [self rollHeight] - 25 - 20;
    //永远指向第1页
    [_roll scrollRectToVisible:CGRectMake(MD_DW, 0, MD_DW, rollH) animated:NO];
}


@end
