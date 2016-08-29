//
//  BaseView.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

#pragma mark - Initalized
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadView:frame];
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - Overrides
- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews)
        [view layoutSubviews];
}

#pragma mark - Public FuncTions
- (void)loadView:(CGRect)frame {
    
}

@end
