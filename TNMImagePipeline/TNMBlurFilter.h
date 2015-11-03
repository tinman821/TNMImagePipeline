//
//  BlurFilter.h
//  TNMImagePipelineDemo
//
//  Created by Tran, Tin on 11/3/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <TNMImagePipeline/TNMImagePipeline.h>

@interface TNMBlurFilter : TNMImageFilter

@property (nonatomic) CGFloat blurRadius;

@end