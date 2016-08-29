//
//  BaseVC.h
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewModel.h"

@protocol VCEventCallback <NSObject>
- (void)onDestroy;
- (void)onNavigationBackButtonClick:(UIButton *)aButton;

@optional
- (void)onApplicationWillEnterForeground;
- (void)onApplicationDidBecomeActive;
- (void)onApplicationWillResignActive;
- (void)onApplicationDidEnterBackground;

@property (nonatomic, strong) NSString *navigationTitle;
@end

@interface BaseVC : UIViewController<VCEventCallback, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BaseViewModel *viewModel;

@end
