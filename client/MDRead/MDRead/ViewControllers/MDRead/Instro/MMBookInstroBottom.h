//
//  MMBookInstroBottom.h
//  MDRead
//
//  Created by midoks on 16/8/23.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _MMInstroItem{
    MMInstroItemAdd,
    MMInstroItemRead,
    MMInstroItemUnKnow
} MMInstroItem;

typedef void (^MMInstroClick)(MMInstroItem state);

@interface MMBookInstroBottom : UIView

-(void)btnClick:(MMInstroClick)block;

@end
