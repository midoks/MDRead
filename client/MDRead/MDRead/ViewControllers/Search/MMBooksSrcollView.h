//
//  MMBooksScollView.h
//  MDRead
//
//  Created by midoks on 16/6/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MMBooksSrcollView : UIView

@property (nonatomic, strong) UILabel *sectionTitle;
-(void)initViewData:(NSMutableDictionary *)data;

-(void)itemClick:(mdItemClick)block;

@end
