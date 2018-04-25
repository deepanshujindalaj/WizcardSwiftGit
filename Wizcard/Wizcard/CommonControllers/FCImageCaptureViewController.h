//
//  FCImageCaptureViewController.h
//  Wizcard
//
//  Created by Akash Jindal on 25/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

#ifndef FCImageCaptureViewController_h
#define FCImageCaptureViewController_h


#endif /* FCImageCaptureViewController_h */

typedef enum FlashMode {
    FlashOff = 0,
    FlashOn,
    FlashAuto
} FlashMode;


#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@class FCImageCaptureViewController;

@protocol FCImageCaptureViewControllerDelegate
@required

- (void)imageCaptureControllerCancelledCapture:(FCImageCaptureViewController *)controller;
- (void)imageCaptureController:(FCImageCaptureViewController *)controller
                 capturedImage:(UIImage *)image;

@end

@interface FCImageCaptureViewController : UIViewController
@property (nonatomic) Boolean onlyDisplayTheImagePicker;
@property (nonatomic) Boolean isSelfPicture;
@property (nonatomic) id <FCImageCaptureViewControllerDelegate> delegate;
@end
