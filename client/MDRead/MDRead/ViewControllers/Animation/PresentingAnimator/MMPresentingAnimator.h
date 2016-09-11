//
//  MMPresentingAnimator.h
//  MDRead
//
//  Created by midoks on 16/9/10.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMPresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end
