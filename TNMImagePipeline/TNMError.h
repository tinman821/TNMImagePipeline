//
//  TNMError.h
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

@import Foundation;

extern NSString * const ImagePipelineErrorDomain;
extern NSString * const ImagePipelineFilterLabelKey;
extern NSString * const ImagePipelineImageKey;

typedef NS_ENUM(NSInteger, ImagePipelineErrorCode) {
    ImagePipelineErrorCodeUnknown,
    ImagePipelineErrorCodeCycleDetected,
    ImagePipelineErrorCodeLabelUndefined,
    ImagePipelineErrorCodeNilFilterOutput,
    ImagePipelineErrorCodeNilImageInput
};