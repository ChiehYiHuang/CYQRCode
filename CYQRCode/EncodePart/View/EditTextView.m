//
//  EditTextView.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "EditTextView.h"

@interface EditTextView () {
    OnButtonClick _onButtonOKClick;
}

@end

@implementation EditTextView

#pragma mark - Override
- (void)loadView:(CGRect)frame {
    [super loadView:frame];
    
    [self setBackgroundColor:[UIColor clearColor]];

    CGRect rect;
    UIImageView *imageView;
    UIView *uiView;
    UITextField *textField;
    UIButton *button;
    
    // mask view
    rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView setAlpha:0.5f];
    [self addSubview:imageView];
    _maskImageView = imageView;
    imageView = nil;
    
    // base view
    rect = CGRectMake(0, 0, 300, 150);
    uiView = [[UIView alloc] initWithFrame:rect];
    [uiView setBackgroundColor:[UIColor whiteColor]];
    [[uiView layer] setCornerRadius:10];
    [[uiView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[uiView layer] setBorderWidth:2];
    [self addShadowIntoView:uiView
                shadowColor:[[UIColor whiteColor] CGColor]
                     offset:CGSizeMake(0.5f, 0.5f)
                     radius:0.5f
                    opacity:0.8];
    [self addSubview:uiView];
    
    // edit text field
    rect = CGRectMake(INTERVAL * 4, INTERVAL * 2, uiView.frame.size.width - 8 * INTERVAL, 50);
    textField = [[UITextField alloc] initWithFrame:rect];
    [[textField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[textField layer] setBorderWidth:1];
    [textField setFont:[UIFont boldSystemFontOfSize:22.0f]];
    [textField setTextColor:[UIColor blackColor]];
    [uiView addSubview:textField];
    _typeTextField = textField;
    textField = nil;
    
    // confirm button
    rect = CGRectMake(_typeTextField.frame.origin.x, CGRectGetMaxY(_typeTextField.frame) + INTERVAL * 2, 100, 50);
    button = [[UIButton alloc] initWithFrame:rect];
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:20.0f]];
    [[button layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[button layer] setBorderWidth:1];
    [button setCenter:CGPointMake(uiView.center.x, button.center.y)];
    [button addTarget:self action:@selector(onButtonFinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [uiView addSubview:button];
    _finishButton = button;
    button = nil;
 
    CGRect baseViewRect = uiView.frame;
    baseViewRect.size.height = CGRectGetMaxY(_finishButton.frame) + _typeTextField.frame.origin.y;
    baseViewRect.origin.x = (frame.size.width - baseViewRect.size.width) / 2;
    baseViewRect.origin.y = (frame.size.height - baseViewRect.size.height) / 2;
    [uiView setFrame:baseViewRect];
}

#pragma mark - Public functions
- (void)setOnButtonFinishClick:(OnButtonClick)aBlock {
    _onButtonOKClick = aBlock;
}

#pragma mark - Events Functions
- (void)onButtonFinishClick:(UIButton *)aButton {
    if (_onButtonOKClick)
        _onButtonOKClick(self);
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
