//
//  EditTextView.h
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "BaseView.h"

typedef void (^OnButtonClick)(UIView *aView);

@interface EditTextView : BaseView

@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UITextField *typeTextField;
@property (nonatomic, strong) UIButton *finishButton;

- (void)setOnButtonFinishClick:(OnButtonClick)aBlock;

@end
