//
//  BlurFilter.m
//  TNMImagePipelineDemo
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "TNMBlurFilter.h"
#import "TNMUIImageEffects.h"

@implementation TNMBlurFilter

- (UIImage *)process {
    UIImage *input = self.imageInput.firstObject;
    return [TNMUIImageEffects imageByApplyingBlurToImage:input
                                           withRadius:self.blurRadius
                                            tintColor:nil
                                saturationDeltaFactor:1.0f
                                            maskImage:nil];
}

@end