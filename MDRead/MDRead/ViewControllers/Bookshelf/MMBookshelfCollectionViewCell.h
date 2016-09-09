//
//  MMBookshelfCollectionViewCell.h
//  MDRead
//
//  Created by midoks on 16/6/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBookshelfCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong) UIImageView *bookImageView;
@property(nonatomic, strong) UILabel *bookName;
@property(nonatomic, strong) UILabel *bookStatus;
@property(nonatomic, strong) UILabel *bookReadStatus;

@end
