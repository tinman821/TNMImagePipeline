//
//  ViewController.m
//  TNMImagePipelineDemo
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <TNMImagePipeline/TNMImagePipeline.h>
#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImage *image;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (IBAction)didPresentPicturePicker:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (IBAction)didRunPipeline:(id)sender {
    TNMNormalizeOrientationFilter *orientationFilter = [TNMNormalizeOrientationFilter new];
    TNMBlurFilter *blurFilter = [TNMBlurFilter new];
    blurFilter.blurRadius = 30.0f;
    TNMTintFilter *redTintFilter = [TNMTintFilter new];
    redTintFilter.tintColor = [UIColor redColor];

    TNMImagePipeline *pipeline = [TNMImagePipeline new];
    [pipeline addFilter:orientationFilter label:@"orientation" dependencies:nil];
    [pipeline addFilter:blurFilter label:@"blur" dependencies:@[@"orientation"]];
    [pipeline addFilter:redTintFilter label:@"redTint" dependencies:@[@"blur"]];

    NSError *error;
    self.image = [pipeline runPipeline:self.image error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (BOOL)startCameraControllerFromViewController:(UIViewController*) controller
                                  usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.modalPresentationStyle = UIModalPresentationOverFullScreen;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

    // Displays a control that allows the user to choose picture.
    cameraUI.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;

    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        self.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
