//
//  BaseVC.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "BaseVC.h"

@implementation BaseVC
@synthesize navigationTitle = _navigationTitle;

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"%@ init", NSStringFromClass([self class]));
        self.navigationTitle = @"";
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [self onDestroy];
}

- (void)removeFromParentViewController {
    [super removeFromParentViewController];
    [self onDestroy];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    RSD_RegisterNotification(self, @selector(onApplicationDidBecomeActive), UIApplicationDidBecomeActiveNotification, nil);
    RSD_RegisterNotification(self, @selector(onApplicationWillResignActive), UIApplicationWillResignActiveNotification, nil);
    RSD_RegisterNotification(self, @selector(onApplicationWillEnterForeground), UIApplicationWillEnterForegroundNotification, nil);
    RSD_RegisterNotification(self, @selector(onApplicationDidEnterBackground), UIApplicationDidEnterBackgroundNotification, nil);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationItem setTitle:self.navigationTitle];

    UIImage *backImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:backImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 9)];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(onNavigationBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 44)];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(viewWillAppear:)])
        [self.viewModel viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(viewDidAppear:)])
        [self.viewModel viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(viewWillDisappear:)])
        [self.viewModel viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(viewDidDisappear:)])
        [self.viewModel viewDidDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        if (self.viewModel && [self.viewModel respondsToSelector:@selector(onViewControllerDestroy)])
            [self.viewModel onViewControllerDestroy];
        self.viewModel = nil;
    }
}

#pragma mark - Properties
- (void)setViewModel:(BaseViewModel *)aViewModel {
    _viewModel = aViewModel;
    if (aViewModel.view)
        [self.view addSubview:aViewModel.view];
}
- (void)setNavigationTitle:(NSString *)aNavigationTitle {
    _navigationTitle = aNavigationTitle;
    self.navigationController.navigationBar.topItem.title = aNavigationTitle;
}

#pragma mark - VCEventCallback
- (void)onDestroy {
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onViewControllerDestroy)])
        [self.viewModel onViewControllerDestroy];
    self.viewModel = nil;
    
    RSD_UnregisterNotification(self);
}

- (void)onNavigationBackButtonClick:(UIButton *)aButton {
    
    [aButton setUserInteractionEnabled:NO];
    
    BOOL allowBaseControl = YES;
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onNavigationBackButtonClick)])
        allowBaseControl = [self.viewModel onNavigationBackButtonClick];
    
    if (allowBaseControl) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        __weak UIButton *weakButton = aButton;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            __strong UIButton *strongButton = weakButton;
            if (strongButton)
                [strongButton setUserInteractionEnabled:NO];
        });
        
    }
}

- (void)onApplicationWillEnterForeground {
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onApplicationWillEnterForeground)])
        [self.viewModel onApplicationWillEnterForeground];
}

- (void)onApplicationDidBecomeActive {
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onApplicationDidBecomeActive)])
        [self.viewModel onApplicationDidBecomeActive];
}

- (void)onApplicationWillResignActive {
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onApplicationWillResignActive)])
        [self.viewModel onApplicationWillResignActive];
}

- (void)onApplicationDidEnterBackground {
    if (self.viewModel && [self.viewModel respondsToSelector:@selector(onApplicationDidEnterBackground)])
        [self.viewModel onApplicationDidEnterBackground];
}

@end
