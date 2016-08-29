//
//  CYQRDecodeView.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRDecodeView.h"

#define ALPHA 0.7f

@implementation CYQRDecodeView

#pragma mark - Override
- (void)loadView:(CGRect)frame {
    [super loadView:frame];
    
    CGRect rect;
    UIImageView *imageView;
    UIView *uiView;
    
    // center catch QRCode imageView
    rect = CGRectMake(0, 0, 300, 300);
    rect.origin.x = (frame.size.width - rect.size.width) / 2;
    rect.origin.y = (frame.size.height - rect.size.height) / 2;
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:[UIImage imageNamed:@"scan.png"]];
    [self addSubview:imageView];
    _catchImageView = imageView;
    imageView = nil;
    
    // the line in catch QRCode imageView (for animate)
    rect.origin.y += 23.5;
    rect.size.height = 15;
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:[UIImage imageNamed:@"scanLine.png"]];
    [self addSubview:imageView];
    _catchLineView = imageView;
    imageView = nil;
    
    
    // the mask part
    rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    uiView = [[UIView alloc] initWithFrame:rect];
    [uiView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:uiView];
    _maskView = uiView;
    uiView = nil;
    
    rect = CGRectMake(0, 0, frame.size.width, _catchImageView.frame.origin.y);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setAlpha:ALPHA];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [_maskView addSubview:imageView];
    
    rect = CGRectMake(0, _catchImageView.frame.origin.y, _catchImageView.frame.origin.x, 0);
    rect.size.height = frame.size.height - rect.origin.y;
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setAlpha:ALPHA];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [_maskView addSubview:imageView];
    
    rect = CGRectMake(_catchImageView.frame.origin.x + _catchImageView.frame.size.width,
                      _catchImageView.frame.origin.y,
                      imageView.frame.size.width,
                      imageView.frame.size.height);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setAlpha:ALPHA];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [_maskView addSubview:imageView];
    
    rect = CGRectMake(_catchImageView.frame.origin.x,
                      _catchImageView.frame.origin.y + _catchImageView.frame.size.height,
                      _catchImageView.frame.size.width,
                      _catchImageView.frame.origin.y);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setAlpha:ALPHA];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [_maskView addSubview:imageView];
}

@end
