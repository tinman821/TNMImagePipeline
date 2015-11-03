//
//  TNMImagePipeline.h
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/2/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TNMImagePipeline/TNMImageFilter.h>
#import <TNMImagePipeline/TNMBlurFilter.h>
#import <TNMImagePipeline/TNMTintFilter.h>
#import <TNMImagePipeline/TNMNormalizeOrientationFilter.h>
#import <TNMImagePipeline/TNMError.h>

//! Project version number for TNMImagePipeline.
FOUNDATION_EXPORT double TNMImagePipelineVersionNumber;

//! Project version string for TNMImagePipeline.
FOUNDATION_EXPORT const unsigned char TNMImagePipelineVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface TNMImagePipeline : NSObject

- (NSString *)addFilter:(TNMImageFilter *)filter
                  label:(nullable NSString *)label
           dependencies:(nullable NSArray <NSString *> *)dependencies;

- (UIImage *)runPipeline:(UIImage *)image
                   error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END