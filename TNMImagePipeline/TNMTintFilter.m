//
//  TNMTintFilter.m
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "TNMTintFilter.h"
#import "TNMUIImageEffects.h"

@implementation TNMTintFilter

- (UIImage *)process {
    UIImage *img = self.imageInput.firstObject;
    UIGraphicsBeginImageContext(img.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    [self.tintColor setFill];
    CGContextFillRect(context, rect);

    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, img.CGImage);

    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return coloredImage;
}

@end
