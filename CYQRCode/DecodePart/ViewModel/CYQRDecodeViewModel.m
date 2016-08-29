//
//  CYQRDecodeViewModel.m
//  CYQRCode
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "CYQRDecodeViewModel.h"
#import "CYQRDecodeView.h"

typedef void(^animateCompleted)(BOOL isCompleted);

@interface CYQRDecodeViewModel () {
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    
    BOOL hasEnterOnce;
}

@end

@implementation CYQRDecodeViewModel

#pragma mark - Override
- (void)onInitVariables {
    [super onInitVariables];
    
    hasEnterOnce = NO;
    captureSession = nil;
}
- (void)onSetupView:(UIView *)aView {
    [super onSetupView:aView];
    
    [self startScanQRcode];
}
- (void)destroy {
    [super destroy];
    captureSession = nil;
    videoPreviewLayer = nil;
}

#pragma mark - Private Functions
- (void)startAnimate {
    CYQRDecodeView *view = (CYQRDecodeView *)[self view];
    
    [UIView animateWithDuration:2.0 animations:^{
        CGRect lineRect = [view catchLineView].frame;
        lineRect.origin.y += [view catchImageView].frame.size.height - 60;
        [[view catchLineView] setFrame:lineRect];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            CGRect lineRect = [view catchLineView].frame;
            lineRect.origin.y -= [view catchImageView].frame.size.height - 60;
            [[view catchLineView] setFrame:lineRect];
        } completion:^(BOOL finished) {
            [self startAnimate];
        }];
    }];
}
- (void)stopAnimate {
    CYQRDecodeView *view = (CYQRDecodeView *)[self view];
    [[view catchLineView] setHidden:YES];
}
- (void)startScanQRcode {
    NSError *error;
    
    CYQRDecodeView *view = (CYQRDecodeView *)[self view];
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    captureDevice = nil;
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }]];
        [[self vc] presentViewController:alert animated:true completion:nil];
    }
    
    // Initialize the captureSession object.
    captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    CGRect catchViewRect = [view catchImageView].frame;
    catchViewRect.origin.y += view.frame.origin.y;
    
#warning (x, y, w, h) is Horizontal Size and view.catchImageView's scale (📱 -> turn left 90 degree)
    float x = catchViewRect.origin.y / [[self vc] view].frame.size.height;
    float y = 1 - ((CGRectGetMaxX(catchViewRect)) / [[self vc] view].frame.size.width);
    float w = catchViewRect.size.height / [[self vc] view].frame.size.height;
    float H = catchViewRect.size.width / [[self vc] view].frame.size.width;
    
    captureMetadataOutput.rectOfInterest = CGRectMake(x, y, w, H);
    [captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:view.layer.bounds];
    [view.layer addSublayer:videoPreviewLayer];
    
    [view bringSubviewToFront:[view maskView]];
    [view bringSubviewToFront:[view catchLineView]];
    [view bringSubviewToFront:[view catchImageView]];
    
    [self startAnimate];
    
    // Start video capture.
    [captureSession startRunning];
}
- (void)stopReading {
    // Stop video capture and make the capture session object nil.
    [captureSession stopRunning];
    captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [videoPreviewLayer removeFromSuperlayer];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    @autoreleasepool {
        if (!hasEnterOnce) {
            hasEnterOnce = YES;
            
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if (metadataObjects != nil && [metadataObjects count] > 0) {
                AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
                if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                    NSLog(@"[metadataObj stringValue]:%@", [metadataObj stringValue]);
//                    NSData *data = [[metadataObj stringValue] dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimate];

                        // handle string
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"DECODE STRING" message:[metadataObj stringValue] preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[[self vc] navigationController] popViewControllerAnimated:YES];
                        }]];
                        [[self vc] presentViewController:alert animated:true completion:nil];
                        
                        [self stopReading];
                    });
                }
            }
        }
    }
}


@end
