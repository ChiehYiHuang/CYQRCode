//
//  BaseViewModel.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (id)initWithVC:(UIViewController *)aVC view:(UIView *)aView {
    if (self = [super init]) {
        NSLog(@"%@ initWithVC:%@, view:%@", NSStringFromClass([self class]), NSStringFromClass([aVC class]), NSStringFromClass([aView class]));
        _vc = aVC;
        _view = aView;
        _orginalViewRect = _view.frame;
        _lifeCycleItems = [NSMutableArray array];
        [self onInitVariables];
        [self onSetupView:aView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [self destroy];
}

- (void)destroy {
    [self removeAllLifeCycleItem];
    
    _vc = nil;
    
    [_view removeFromSuperview];
    _view = nil;
}

- (void)onInitVariables {  }
- (void)onSetupView:(UIView *)aView {  }
- (void)addLifeCycleItem:(id<BaseViewModelLifeCycle>)aLifeCycleItem {
    [_lifeCycleItems addObject:aLifeCycleItem];
}
- (void)removeLifeCycleItem:(id<BaseViewModelLifeCycle>)aLifeCycleItem {
    [_lifeCycleItems removeObject:aLifeCycleItem];
}
- (void)removeAllLifeCycleItem {
    [_lifeCycleItems removeAllObjects];
    _lifeCycleItems = nil;
}

#pragma mark - BaseViewModelLifeCycle
- (void)viewWillAppear:(BOOL)animated {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(viewWillAppear:)])
            [item viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(viewDidAppear:)])
            [item viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(viewWillDisappear:)])
            [item viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(viewDidDisappear:)])
            [item viewDidDisappear:animated];
}
- (BOOL)onNavigationBackButtonClick {
    BOOL allowBaseVCControl = YES;
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onNavigationBackButtonClick)])
            if (![item onNavigationBackButtonClick])
                allowBaseVCControl = NO;
    return allowBaseVCControl;
}
- (void)onViewControllerDestroy {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onViewControllerDestroy)])
            [item onViewControllerDestroy];
    [self removeAllLifeCycleItem];
}

- (void)onApplicationWillResignActive {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onApplicationWillResignActive)])
            [item onApplicationWillResignActive];
}

- (void)onApplicationDidEnterBackground {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onApplicationDidEnterBackground)])
            [item onApplicationDidEnterBackground];
}

- (void)onApplicationWillEnterForeground {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onApplicationWillEnterForeground)])
            [item onApplicationWillEnterForeground];
}

- (void)onApplicationDidBecomeActive {
    for (id<BaseViewModelLifeCycle> item in _lifeCycleItems)
        if ([item respondsToSelector:@selector(onApplicationDidBecomeActive)])
            [item onApplicationDidBecomeActive];
}

@end
