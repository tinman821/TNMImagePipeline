//
//  TNMNormalizeOrientationFilter.m
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "TNMNormalizeOrientationFilter.h"

@implementation TNMNormalizeOrientationFilter

- (UIImage *)process {
    UIImage *image = self.imageInput.firstObject;
    if (image.imageOrientation == UIImageOrientationUp) return image;

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
