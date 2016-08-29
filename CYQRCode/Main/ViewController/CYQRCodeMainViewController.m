//
//  CYQRCodeMainViewController.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRCodeMainViewController.h"
#import "CYQRCodeMainView.h"
#import "CYQRCodeMainViewModel.h"

@implementation CYQRCodeMainViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];

    CYQRCodeMainView *view = [[CYQRCodeMainView alloc] initWithFrame:[[self view] frame]];
    [self setViewModel:[[CYQRCodeMainViewModel alloc] initWithVC:self view:view]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}
- (NSString *)navigationTitle {
    return @"CYQRCode";
}

@end
