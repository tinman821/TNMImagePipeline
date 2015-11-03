//
//  TNMImageFilter.h
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/2/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

@import UIKit;

@interface TNMImageFilter : NSObject

@property (nonatomic) NSArray<UIImage *> *imageInput;

- (UIImage *)process;

@end