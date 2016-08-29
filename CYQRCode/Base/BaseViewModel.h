//
//  BaseViewModel.h
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelLifeCycle <NSObject>

@optional
- (void)onViewControllerDestroy;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (BOOL)onNavigationBackButtonClick;
- (void)onApplicationWillEnterForeground;
- (void)onApplicationDidBecomeActive;
- (void)onApplicationWillResignActive;
- (void)onApplicationDidEnterBackground;

@end
@interface BaseViewModel : NSObject<BaseViewModelLifeCycle>

@property (nonatomic, strong) NSMutableArray *lifeCycleItems;
@property (nonatomic, weak, readonly) UIViewController *vc;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, readonly) CGRect orginalViewRect;

- (id)initWithVC:(UIViewController *)aVC view:(UIView *)aView;
- (void)destroy;
- (void)onInitVariables;
- (void)onSetupView:(UIView *)aView;
- (void)addLifeCycleItem:(id<BaseViewModelLifeCycle>)aLifeCycleItem;
- (void)removeLifeCycleItem:(id<BaseViewModelLifeCycle>)aLifeCycleItem;
- (void)removeAllLifeCycleItem;

@end
