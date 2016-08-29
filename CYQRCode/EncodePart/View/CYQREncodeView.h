//
//  CYQREncodeView.h
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "BaseView.h"

@interface CYQREncodeView : BaseView

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UIImageView *qrCodeCenterImageView;

@end
