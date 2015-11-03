//
//  TNMImagePipeline.m
//  TNMImagePipeline
//
//  Created by Tran, Tin on 11/2/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "TNMImagePipeline.h"
#import "TNMImageFilter.h"

@interface TNMNode : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic) TNMImageFilter *filter;
@property (nonatomic) NSInteger referenceCount;

+ (instancetype)nodeWithFilter:(TNMImageFilter *)filter
                         label:(NSString *)label;

@end

@implementation TNMNode

+ (instancetype)nodeWithFilter:(TNMImageFilter *)filter
                         label:(NSString *)label {
    TNMNode *node = [TNMNode new];
    node.filter = filter;
    node.label = label;
    node.referenceCount = 1;
    return node;
}

@end

@interface TNMImagePipeline ()

@property (nonatomic) NSMutableSet<NSString *> *nodeInProgress;
@property (nonatomic) NSMutableDictionary<NSString *, TNMNode *> *nodes;
@property (nonatomic) NSMutableDictionary<NSString *, UIImage *> *outputCache;
@property (nonatomic) NSMutableDictionary<NSString *, NSArray<NSString *> *> *graph;
@property (nonatomic) TNMNode *lastNode;

@end

@implementation TNMImagePipeline

- (instancetype)init {
    if (self = [super init]) {
        self.nodes = [NSMutableDictionary new];
        self.graph = [NSMutableDictionary new];
        self.outputCache = [NSMutableDictionary new];
        self.nodeInProgress = [NSMutableSet new];
    }
    return self;
}

- (NSString *)addFilter:(TNMImageFilter *)filter
                  label:(NSString *)label
           dependencies:(NSArray <NSString *> *)dependencies {

    if (!label) {
        label = [[NSUUID UUID] UUIDString];
    }

    TNMNode *node = [TNMNode nodeWithFilter:filter label:label];
    self.nodes[label] = node;
    self.lastNode = node;

    for (NSString *dependencyLabel in dependencies) {
        TNMNode *dependencyNode = self.nodes[dependencyLabel];
        dependencyNode.referenceCount++;
    }

    self.graph[node.label] = dependencies;
    return label;
}

- (UIImage *)runPipeline:(UIImage *)image
                   error:(NSError *__autoreleasing *)error {
    return [self processNode:self.lastNode
                    forImage:image
                       error:error];
}

#pragma mark - Private methods

- (UIImage *)processNode:(TNMNode *)node
                forImage:(UIImage *)image
                   error:(NSError *__autoreleasing *)error {
    if ([self.nodeInProgress containsObject:node.label]) {
        if (error) {
            *error = [NSError errorWithDomain:ImagePipelineErrorDomain
                                         code:ImagePipelineErrorCodeCycleDetected
                                     userInfo:@{ ImagePipelineFilterLabelKey : node.label,
                                                 ImagePipelineImageKey : image}];
        }
        return nil;
    }
    if (!self.outputCache[node.label]) {
        NSArray<NSString *> *dependencies = self.graph[node.label];
        if (!dependencies) {
            node.filter.imageInput = @[ image ];
        } else {
            [self.nodeInProgress addObject:node.label];
            NSMutableArray<UIImage *> *inputArray = [NSMutableArray new];
            for (NSString *dependencyLabel in dependencies) {
                NSError *localError = nil;
                UIImage *result = [self processNode:self.nodes[dependencyLabel]
                                           forImage:image
                                              error:&localError];
                if (result) {
                    [inputArray addObject:result];
                } else if (error) {
                    if (localError) {
                        *error = localError;
                    } else {
                        *error = [NSError errorWithDomain:ImagePipelineErrorDomain
                                                     code:ImagePipelineErrorCodeNilFilterOutput
                                                 userInfo:@{ ImagePipelineFilterLabelKey : dependencyLabel,
                                                             ImagePipelineImageKey : image }];
                    }
                    return nil;
                } else {
                    return nil;
                }
            }
            [self.nodeInProgress removeObject:node.label];
            node.filter.imageInput = inputArray;
        }
        self.outputCache[node.label] = [node.filter process];
    }
    UIImage *output = self.outputCache[node.label];
    [self cleanOutputCacheForNode:node];
    return output;
}

- (void)cleanOutputCacheForNode:(TNMNode *)node {
    node.referenceCount--;
    if (node.referenceCount == 0) {
        [self.outputCache removeObjectForKey:node.label];
    }
}

@end