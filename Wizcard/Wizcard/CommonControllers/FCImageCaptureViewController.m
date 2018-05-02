//
//  FCImageCaptureViewController.m
//  Wizcard
//
//  Created by Akash Jindal on 25/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCImageCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Rotation.h"
#import "UIImage+Sizing.h"

#define kKeyForMessage                          @"Message"
#define kKeyForServerError                      @"Oops!! Pardon us. It appears our servers are struggling to keep up. We are on it"
#define kKeyForErrorOccured                     @"Error occured please try again"
#define kKeyForOk                               @"OK"


@interface FCImageCaptureViewController () <UIAlertViewDelegate>
@property(nonatomic) BOOL deviceCanUseCamera;

@property(nonatomic) UIView *vImagePreview;
@property(nonatomic) UIView *camFocus;

@property(nonatomic) UIButton *flash;

@property(nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic) UIImagePickerController *imagePicker;

@property(nonatomic) UIImageView *cardOverlay;

@property(nonatomic) AVCaptureDevice *device;
@property(nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic) CGFloat lastRotation;

@property(nonatomic) int currentFlashChoice;

@end
@implementation FCImageCaptureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _deviceCanUseCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraCaptureModePhoto];
    
    if (self.onlyDisplayTheImagePicker){
        self.deviceCanUseCamera = !self.onlyDisplayTheImagePicker;
    }
    
    if (!_deviceCanUseCamera || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
    
    if (_deviceCanUseCamera){
        [self setupScreen];
        [self startAVCapture];
    }
    
    if (!self.isSelfPicture){
        [UIView animateWithDuration:1.5f animations:^{
            _cardOverlay.alpha = 0;
        }];
    }
    else{
        _cardOverlay.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupScreen {
    [[self.view subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj != _vImagePreview)
            [obj removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor =  RGB(109, 111, 114);
    
    
    NSLog(@"%@", [NSValue valueWithCGRect:[UIApplication sharedApplication].delegate.window.frame]);
    CGRect windowFrame = [UIApplication sharedApplication].delegate.window.frame;
    
    
    
    CGRect  captureRectFrame= CGRectMake(37.5, 20, windowFrame.size.width - 75, windowFrame.size.height - 140);
    
    CGRect captureButtonFrame = CGRectMake(((windowFrame.size.width / 2) - 40) , windowFrame.size.height - 100 , 80, 80);
    CGRect chooseButtonFrame = CGRectMake(268, windowFrame.size.height - 61 , 32, 25);
    CGRect flashButtonFrame = CGRectMake((captureButtonFrame.origin.x + 95), windowFrame.size.height - 70 , 40, 40);
    CGRect cancelButtonFrame = CGRectMake(20, windowFrame.size.height - 63 , 28, 28);
    
    CGRect topLeftBracketFrame = CGRectMake(0, 0, 45, 45);
    CGRect topRightBracketFrame = CGRectMake(windowFrame.size.width - 120 , 0, 45, 45);
    CGRect bottomLeftBracketFrame = CGRectMake(0, windowFrame.size.height - 170, 45, 45);
    CGRect bottomRightBracketFrame = CGRectMake(windowFrame.size.width - 120, windowFrame.size.height - 170, 45, 45);
    
    CGRect frameForCardOverlay = CGRectMake( 30 ,
                                            30 ,
                                            captureRectFrame.size.width - 60,
                                            captureRectFrame.size.height - 60);
    UIView *captureRect = [[UIView alloc] initWithFrame:captureRectFrame];
    UIButton *capture = [[UIButton alloc] initWithFrame:captureButtonFrame];
    UIButton *choose = [[UIButton alloc] initWithFrame:chooseButtonFrame];
    _flash = [[UIButton alloc] initWithFrame:flashButtonFrame];
    UIButton *cancel = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    
    if (!_vImagePreview) {
        _vImagePreview = [UIImageView new];
        [_vImagePreview setFrame:self.view.bounds];
        [self.view addSubview:_vImagePreview];
        _cardOverlay = [[UIImageView alloc] initWithFrame:frameForCardOverlay];
        _cardOverlay.image = [UIImage imageNamed:@"example-card"];
        [captureRect addSubview:_cardOverlay];
    }
    
    if (!self.isSelfPicture) {
        UIImageView *bracketTopLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bracket-top-left"]];
        [bracketTopLeft setFrame:topLeftBracketFrame];
        [captureRect addSubview:bracketTopLeft];
        
        UIImageView *bracketTopRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bracket-top-right"]];
        [bracketTopRight setFrame:topRightBracketFrame];
        [captureRect addSubview:bracketTopRight];
        
        UIImageView *bracketBottomLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bracket-bottom-left"]];
        [bracketBottomLeft setFrame:bottomLeftBracketFrame];
        [captureRect addSubview:bracketBottomLeft];
        
        UIImageView *bracketBottomRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bracket-bottom-right"]];
        [bracketBottomRight setFrame:bottomRightBracketFrame];
        [captureRect addSubview:bracketBottomRight];
    }
    
    [capture setImage:[UIImage imageNamed:@"button-camera"] forState:UIControlStateNormal];
    [capture addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (_currentFlashChoice) {
        case FlashOff:
            [_flash setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
            break;
        case FlashOn:
            [_flash setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
            break;
        case FlashAuto:
            [_flash setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    [_flash addTarget:self action:@selector(flashChoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancel setImage:[UIImage imageNamed:@"icon-close-camera"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [choose setImage:[UIImage imageNamed:@"gallery"] forState:UIControlStateNormal];
    [choose addTarget:self action:@selector(library:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:captureRect];
    [self.view addSubview:capture];
    [self.view addSubview:_flash];
    [self.view addSubview:cancel];
    [self.view addSubview:choose];
    
}

- (void)setFlashMode {
    NSError *deviceError;
    switch (_currentFlashChoice) {
        case FlashOff:
            if (_device.hasFlash) {
                [_device lockForConfiguration:&deviceError];
                _device.flashMode = AVCaptureFlashModeOff;
                [_device unlockForConfiguration];
            }
            break;
        case FlashOn:
            if (_device.hasFlash) {
                [_device lockForConfiguration:&deviceError];
                _device.flashMode = AVCaptureFlashModeOn;
                [_device unlockForConfiguration];
            }
            break;
        case FlashAuto:
            if (_device.hasFlash) {
                [_device lockForConfiguration:&deviceError];
                _device.flashMode = AVCaptureFlashModeAuto;
                [_device unlockForConfiguration];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Focusing Methods

- (void)focus:(CGPoint)aPoint; {
    if (_device != nil) {
        if ([_device isFocusPointOfInterestSupported] &&
            [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;  //TODO:  CGFloat
            CGFloat screenHeight = screenRect.size.height;
            CGFloat focus_x = aPoint.x / screenWidth;
            CGFloat focus_y = aPoint.y / screenHeight;
            if ([_device lockForConfiguration:nil]) {
                [_device setFocusPointOfInterest:CGPointMake((CGFloat) focus_x, (CGFloat) focus_y)];
                [_device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                    [_device setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                [_device unlockForConfiguration];
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.view.subviews containsObject:_imagePicker.view])
        return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self focus:touchPoint];
    
    if (_camFocus)
        [_camFocus removeFromSuperview];
    
    if ([[touch view] isKindOfClass:[UIView class]]) {
        _camFocus = [[UIView alloc] initWithFrame:CGRectMake(touchPoint.x - 40, touchPoint.y - 40, 80, 80)];
        [_camFocus setBackgroundColor:[UIColor clearColor]];
        [_camFocus.layer setBorderWidth:2.0];
        [_camFocus.layer setCornerRadius:4.0];
        [_camFocus.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        CABasicAnimation *selectionAnimation = [CABasicAnimation
                                                animationWithKeyPath:@"borderColor"];
        selectionAnimation.toValue = (id) RGB(109, 111, 114).CGColor;
        selectionAnimation.repeatCount = 8;
        [_camFocus.layer addAnimation:selectionAnimation
                               forKey:@"selectionAnimation"];
        
        [self.view addSubview:_camFocus];
        [_camFocus setNeedsDisplay];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.5];
        [_camFocus setAlpha:0.0];
        [UIView commitAnimations];
    }
}

- (void)startAVCapture {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    _captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.bounds = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:_captureVideoPreviewLayer];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [self setFlashMode];
    NSError *deviceError;
    
    if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [_device lockForConfiguration:&deviceError];
        _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        [_device unlockForConfiguration];
    }
    if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [_device lockForConfiguration:&deviceError];
        _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        [_device unlockForConfiguration];
    }
    if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        [_device lockForConfiguration:&deviceError];
        _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        [_device unlockForConfiguration];
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (!input) {
        [[[UIAlertView alloc] initWithTitle:kKeyForMessage message:@"Please give permission to access camera to use this feature." delegate:self cancelButtonTitle:kKeyForOk otherButtonTitles: nil] show];
    }
    else{
        [session addInput:input];
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [_stillImageOutput setOutputSettings:outputSettings];
        
        [session addOutput:_stillImageOutput];
        
        [session startRunning];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self cancel:nil];
}
- (IBAction)capture:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {break;}
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[[UIImage alloc] initWithData:imageData] fixOrientationOfImage];
        
        CGFloat deviceScale = image.size.width / 290;
        CGRect refRect = CGRectMake(30 * deviceScale, 10 * deviceScale, 290 * deviceScale, 417.5 * deviceScale);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, refRect);
        UIImage *finalPhoto = [[UIImage alloc] initWithCGImage:imageRef scale:1 orientation:image.imageOrientation];
        
        CGImageRelease(imageRef);
        
        image = [UIImage imageWithImage:finalPhoto scaledToSize:CGSizeMake(600, 1050)];
        
        if (!self.isSelfPicture) {
            if (_lastRotation == 0) {
                image = [image imageRotatedByDegrees:-90];
            } else {
                image = [image imageRotatedByDegrees:_lastRotation * -1];
            }
        }
        
        
        if (_delegate)
            [_delegate imageCaptureController:self capturedImage:image];
    }];
}

- (IBAction)cancel:(id)sender {
    [self.delegate imageCaptureControllerCancelledCapture:self];
}

- (IBAction)library:(id)sender {
    [self.view addSubview:_imagePicker.view];
}

- (IBAction)flashChoice:(id)sender {
    _currentFlashChoice++;
    if (_currentFlashChoice > 2)
        _currentFlashChoice = 0;
    [self setFlashMode];
    [self setupScreen];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if ((image.size.height < 240) & (image.size.width < 320)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Too Small" message:@"The selected image is too small to process.  Please select an image at least 320x240 in size." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth;
    CGFloat newHeight;
    
    
    UIImage *newImage;
    if (!self.isSelfPicture) {
        if (width > height) {
            newWidth = 800;
            newHeight = 800 / width * height;
        } else {
            newWidth = 800 / height * width;
            newHeight = 800;
        }
        
        newImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
        if (newHeight > newWidth)
            newImage = [newImage imageRotatedByDegrees:-90];
        
        newImage = [self resizeImage:image];
        
    }else{
        newImage = [self resizeImage:image];
    }
    
    
    NSLog(@"Scaled selected image to %fx%f", newImage.size.width, newImage.size.height);
    if (_delegate)
        [_delegate imageCaptureController:self capturedImage:newImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.1;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_delegate && (!_deviceCanUseCamera || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) {
        [_delegate imageCaptureControllerCancelledCapture:self];
        [self dismissViewControllerAnimated:YES completion:nil];
//        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        //        [_imagePicker.view removeFromSuperview];
    }
}

@end
