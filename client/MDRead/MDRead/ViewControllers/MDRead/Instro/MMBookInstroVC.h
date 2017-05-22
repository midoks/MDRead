//
//  MMBookInstroViewController.h
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMBookInstroTextCell.h"
#import "MMBookInstroHead.h"


@interface MMBookInstroVC : UIViewController {

    
}


@property (nonatomic, strong) NSDictionary *bookInfo;

@property (nonatomic, strong) MMBookInstroTextCell *bookDesc;
@property (nonatomic, strong) MMBookInstroHead *head;


@end
