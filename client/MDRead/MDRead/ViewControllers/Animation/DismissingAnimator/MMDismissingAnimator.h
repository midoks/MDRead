//
//  MMDismissingAnimator.h
//  MDRead
//
//  Created by midoks on 16/9/10.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MMDismissingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end
