//
//  CYQREncodeViewController.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQREncodeViewController.h"
#import "CYQREncodeView.h"
#import "CYQREncodeViewModel.h"

@interface CYQREncodeViewController ()

@end

@implementation CYQREncodeViewController

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect;
    rect = CGRectMake(0,
                      64,
                      self.view.frame.size.width,
                      self.view.frame.size.height - 64);
    CYQREncodeView *view = [[CYQREncodeView alloc] initWithFrame:rect];
    [self setViewModel:[[CYQREncodeViewModel alloc] initWithVC:self view:view]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)navigationTitle {
    return @"ENCODE";
}

@end
