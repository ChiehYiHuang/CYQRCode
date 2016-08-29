//
//  CYQRCodeMainViewModel.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRCodeMainViewModel.h"
#import "CYQRCodeMainView.h"

#import "CYQRDecodeViewController.h"
#import "CYQREncodeViewController.h"

@implementation CYQRCodeMainViewModel

#pragma mark - Override
- (void)onInitVariables {
    [super onInitVariables];
}
- (void)onSetupView:(UIView *)aView {
    [super onSetupView:aView];
    
    CYQRCodeMainView *view = (CYQRCodeMainView *)[self view];
    [[view encodeButton] addTarget:self action:@selector(onEncodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[view decodeButton] addTarget:self action:@selector(onDecodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Events Functions
- (void)onEncodeButtonClick:(UIButton *)aButton {
    CYQREncodeViewController *vc = [[CYQREncodeViewController alloc] init];
    [[[self vc] navigationController] pushViewController:vc animated:YES];
}
- (void)onDecodeButtonClick:(UIButton *)aButton {
    CYQRDecodeViewController *vc = [[CYQRDecodeViewController alloc] init];
    [[[self vc] navigationController] pushViewController:vc animated:YES];
}

@end
