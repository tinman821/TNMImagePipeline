# TNMImagePipeline

##Overview
TNMImagePipeline is a framework for chaining together filters for image processing in a pipeline.  Filters can have dependencies on other filters in arbitrary order.  The pipeline will resolve the dependencies and try to optimize the image processing.

TNMImagePipeline comes with a blur, orientation normalization, and tint filter.  Additional filters can be added by subclassing TNMImageFilter.

##Usage
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
    UIImage *imageOutput = [pipeline runPipeline:imageInput error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }`
