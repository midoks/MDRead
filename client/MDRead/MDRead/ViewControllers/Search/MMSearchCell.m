//
//  MMSearchCell.m
//  MDRead
//
//  Created by midoks on 2017/1/6.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSearchCell.h"
#import "UIImageView+WebCache.h"

@interface MMSearchCell()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIImageView *image;


@end

@implementation MMSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initTitle];
        [self initDesc];
        [self initIconImage];
    }
    return self;
}

-(CGFloat)cellHeight
{
    return 100;
}

-(void)initTitle
{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,  150, 30)];
    _title.backgroundColor = [UIColor grayColor];
    _title.alpha = 0.3;
    _title.font = [UIFont systemFontOfSize:14];
    [self addSubview:_title];
}

-(void)setSTitle:(NSString *)title{
    
    _title.backgroundColor = [UIColor clearColor];
    _title.alpha = 1;
    _title.text = title;
}

-(void)initDesc
{
    _desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 50)];
    _desc.backgroundColor = [UIColor grayColor];
    _desc.alpha = 0.3;
    _desc.numberOfLines = 0;
    _desc.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_desc];
}

-(void)setSDesc:(NSString *)desc{
    
    _desc.backgroundColor = [UIColor clearColor];
    _desc.alpha = 1;
    _desc.text = desc;
}

-(void)initIconImage
{
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(300, 5, 60, 85)];
    _image.backgroundColor = [UIColor grayColor];
    _image.layer.cornerRadius = 3;
    _image.alpha = 0.3;
    
    [self addSubview:_image];
}

-(void)setSImage:(NSString *)imageUrl
{
    _image.alpha = 1;
    _image.backgroundColor = [UIColor clearColor];
    [_image sd_setImageWithURL:[[NSURL alloc] initWithString:imageUrl]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //MDLog(@"%f", MD_FW - 10 - 60);
    _title.frame = CGRectMake(10, 5,  MD_FW - 10 - 60 - 20, 30);
    _desc.frame = CGRectMake(10, 40, MD_FW - 10 - 60 - 20, 50);
    _image.frame =  CGRectMake(MD_FW - 10 - 60, 5, 60, 85);
}

@end
