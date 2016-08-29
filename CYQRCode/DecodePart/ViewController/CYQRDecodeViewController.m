//
//  CYQRDecodeViewController.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRDecodeViewController.h"
#import "CYQRDecodeView.h"
#import "CYQRDecodeViewModel.h"

@interface CYQRDecodeViewController ()

@end

@implementation CYQRDecodeViewController

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect;
    rect = CGRectMake(0,
                      64,
                      self.view.frame.size.width,
                      self.view.frame.size.height - 64);
    CYQRDecodeView *view = [[CYQRDecodeView alloc] initWithFrame:rect];
    [self setViewModel:[[CYQRDecodeViewModel alloc] initWithVC:self view:view]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)navigationTitle {
    return @"DECODE";
}

@end
