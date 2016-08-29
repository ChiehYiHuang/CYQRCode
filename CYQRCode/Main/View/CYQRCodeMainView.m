//
//  CYQRCodeMainView.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRCodeMainView.h"

@implementation CYQRCodeMainView

#pragma mark - Override
- (void)loadView:(CGRect)frame {
    [super loadView:frame];
    
    CGRect rect;
    UIButton *button;
    
    rect = CGRectMake(0, 0, 100, 100);
    
    for (int i = 0; i < 2; i++) {
        button = [[UIButton alloc] initWithFrame:rect];
        [[button titleLabel] setTextColor:[UIColor whiteColor]];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
        [[button layer] setBorderWidth:2];
        [[button layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [self addSubview:button];
        switch (i) {
            case 0: {
                _encodeButton = button;
                [_encodeButton setTitle:@"ENCODE" forState:UIControlStateNormal];
                [_encodeButton setCenter:CGPointMake(self.center.x,
                                                     frame.size.height / 3)];
                break; }
            case 1: {
                _decodeButton = button;
                [_decodeButton setTitle:@"DECODE" forState:UIControlStateNormal];
                [_decodeButton setCenter:CGPointMake(self.center.x,
                                                     frame.size.height / 3 * 2)];
                break; }
            default:
                break;
        }
        button = nil;
    }
}

@end
