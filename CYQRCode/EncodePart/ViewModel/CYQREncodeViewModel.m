//
//  CYQREncodeViewModel.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQREncodeViewModel.h"
#import "CYQREncodeView.h"

#import "EditTextView.h"

@interface CYQREncodeViewModel () {
    NSString *_editText;
    EditTextView *_editTypeView;
}

@end

@implementation CYQREncodeViewModel

#pragma mark - Override
- (void)onInitVariables {
    [super onInitVariables];
    
    _editText = @"";
}
- (void)onSetupView:(UIView *)aView {
    [super onSetupView:aView];
    
    CYQREncodeView *view = (CYQREncodeView *)[self view];
    
    UIImage *personHeadImage = [UIImage imageNamed:@"Rebecca.JPG"];
    
    // Set HeadImageView Image
    [[view headImageView] setImage:personHeadImage];
    
    // Set NameLabel Text
    NSString *defaultString = @"蕾貝卡(ChiehYi Huang)";
    [[view nameLabel] setText:defaultString];
    
    _editText = defaultString;
    
    // create QRCode ImageView
    [self changeQRCodeImage];
    
    // Set QRcode Image's center image
    [[view qrCodeCenterImageView] setImage:personHeadImage];
    
    // add navigationBar right button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 9)];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(onEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setTitle:@"EDIT" forState:UIControlStateNormal];
    [[button titleLabel] setTextColor:[UIColor grayColor]];
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [[button layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[button layer] setBorderWidth:1];
    [self vc].navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - Events Functions
- (void)onEditButtonClick:(UIButton *)aButton {
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _editTypeView = [[EditTextView alloc] initWithFrame:rect];
    [[_editTypeView typeTextField] setText:_editText];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundClick:)];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [[_editTypeView maskImageView] addGestureRecognizer:tapGestureRecognizer];
    [[self view] addSubview:_editTypeView];
    
    [[_editTypeView typeTextField] becomeFirstResponder];
    
    __weak CYQREncodeViewModel *weakSelf = self;
    [_editTypeView setOnButtonFinishClick:^(UIView *aView) {
        __strong CYQREncodeViewModel *strongSelf = weakSelf;
        if (!strongSelf)
            return;
        
        _editText = [_editTypeView typeTextField].text;
        [strongSelf changeQRCodeImage];
        
        [aView removeFromSuperview];
    }];
}
- (void)onBackgroundClick:(UITapGestureRecognizer *)aTap {
    [[_editTypeView typeTextField] resignFirstResponder];
}

#pragma mark - Private Functions
- (void)changeQRCodeImage {
    CYQREncodeView *view = (CYQREncodeView *)[self view];

    // Set QRcode Image
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:_editText] withSize:[view qrCodeImageView].frame.size.width];
    
    // Set random color
    float randomRed = arc4random() % 255;
    float randomGreen = arc4random() % 255;
    float randomBlue = arc4random() % 255;
    
    
    // mix the color to make it deep
    UIColor *mix = [UIColor blackColor];
    
    const CGFloat *components = CGColorGetComponents(mix.CGColor);
//    NSLog(@"Red: %f", components[0]);
//    NSLog(@"Green: %f", components[1]);
//    NSLog(@"Blue: %f", components[2]);
    
    randomRed = (randomRed + components[0]) / 2;
    randomGreen = (randomGreen + components[1]) / 2;
    randomBlue = (randomBlue + components[2]) / 2;
    
    image = [self imageBlackToTransparent:image withRed:randomRed andGreen:randomGreen andBlue:randomBlue];
    
    [[view qrCodeImageView] setImage:image];
    
    image = nil;
}
// Input string to get a CIImage
- (CIImage *)createQRForString:(NSString *)aQRString {
    
    NSData *stringData = [aQRString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create Filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // Setting content and input Correction Level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return [qrFilter outputImage];
}
// CIImage to UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)aImage withSize:(CGFloat)aSize {
    
    CGRect extent = CGRectIntegral(aImage.extent);
    CGFloat scale = MIN(aSize / CGRectGetWidth(extent),
                        aSize / CGRectGetHeight(extent));
   
    // create bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:aImage fromRect:extent];
    context = nil;
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // turn bitmap to image
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void *)data);
}
/*
 * Turn image to the color what you want 
 * (aRed/aGreen/aBlue:0-255)
 */
- (UIImage *)imageBlackToTransparent:(UIImage *)aImage withRed:(CGFloat)aRed andGreen:(CGFloat)aGreen andBlue:(CGFloat)aBlue {
    const int imageWidth = aImage.size.width;
    const int imageHeight = aImage.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), aImage.CGImage);

    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        
        // turn color white to color clear
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            
            // change color to what you turn
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[3] = aRed;
            ptr[2] = aGreen;
            ptr[1] = aBlue;
        } else {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // scan to Image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

@end
