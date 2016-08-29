//
//  CYQREncodeView.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQREncodeView.h"

@implementation CYQREncodeView

#pragma mark - Override
- (void)loadView:(CGRect)frame {
    [super loadView:frame];
    
    CGRect rect;
    UIView *uiView;
    UILabel *label;
    UIImageView *imageView;
    
    // base white View
    rect = CGRectMake(INTERVAL * 5, INTERVAL * 20, frame.size.width, 500);
    rect.size.width -= 2 * rect.origin.x;
    rect.size.height -= rect.origin.y + rect.origin.x;
    uiView = [[UIView alloc] initWithFrame:rect];
    [uiView setBackgroundColor:[UIColor whiteColor]];
    [[uiView layer] setCornerRadius:20];
    [self addSubview:uiView];
    _baseView = uiView;
    uiView = nil;
    
    // headImageView
    rect = CGRectMake(INTERVAL * 5, INTERVAL * 5, 60, 60);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [[imageView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[imageView layer] setBorderWidth:1];
    [imageView setClipsToBounds:YES];
    [_baseView addSubview:imageView];
    _headImageView = imageView;
    imageView = nil;
    
    // nameLabel
    rect = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 2 * INTERVAL,
                      _headImageView.frame.origin.y,
                      _baseView.frame.size.width - _headImageView.frame.origin.y * 2 - _headImageView.frame.size.width,
                      20);
    label = [[UILabel alloc] initWithFrame:rect];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setCenter:CGPointMake(label.center.x, _headImageView.center.y)];
    [_baseView addSubview:label];
    _nameLabel = label;
    label = nil;
    
    // QRCode ImageView
    rect = CGRectMake(_headImageView.frame.origin.x,
                      _headImageView.frame.origin.y * 1.5 + _headImageView.frame.size.height,
                      _baseView.frame.size.width,
                      0);
    rect.size.width -= rect.origin.x * 2;
    rect.size.height = rect.size.width;
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [self addShadowIntoView:imageView
                shadowColor:[[UIColor blackColor] CGColor]
                     offset:CGSizeMake(0, 0.5f)
                     radius:1
                    opacity:0.3];
    [_baseView addSubview:imageView];
    _qrCodeImageView = imageView;
    imageView = nil;
    
    // the image at QRCode ImageView center
    rect = CGRectMake(0, 0, 40, 40);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setCenter:_qrCodeImageView.center];
    [[imageView layer] setCornerRadius:rect.size.width / 2];
    [imageView setClipsToBounds:YES];
    [_baseView addSubview:imageView];
    _qrCodeCenterImageView = imageView;
    imageView = nil;
    
    // adjust baseView's height
    rect = _baseView.frame;
    rect.size.height = _qrCodeImageView.frame.origin.y + _qrCodeImageView.frame.size.height + _headImageView.frame.origin.y;
    [_baseView setFrame:rect];
}

#pragma mark - Private Functions
- (void)addShadowIntoView:(UIView *)aView shadowColor:(CGColorRef)aColor offset:(CGSize)aOffset radius:(float)aRadius opacity:(float)aOpacity {
    [aView.layer setShadowColor:aColor];
    [aView.layer setShadowOffset:aOffset];
    [aView.layer setShadowRadius:aRadius];
    [aView.layer setShadowOpacity:aOpacity];
    [aView.layer setMasksToBounds:NO];
    [aView.layer setShouldRasterize:YES];
}

@end
