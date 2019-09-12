      //
//  SXCamera.h
//  SXVideoEnging
//
//  Created by Yin Xie on 2019/4/15.
//  Copyright © 2019 Zhiqiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SXCameraSize480,
    SXCameraSize720,
    SXCameraSize1080,
} SXCameraSize;

typedef enum : NSUInteger {
    SXCameraFrameRate15,
    SXCameraFrameRate20,
    SXCameraFrameRate25,
    SXCameraFrameRate30
} SXCameraFrameRate;

typedef enum : NSUInteger {
    SXCameraPositionFront,
    SXCameraPositionBack,
} SXCameraPosition;

typedef enum : NSUInteger {
    SXCameraSourceTypeVideoOnly,
    SXCameraSourceTypeAudioAndVideo,
} SXCameraSourceType;

@interface SXCamera : NSObject

@property (nonatomic, assign, readonly) SXCameraSize size;
@property (nonatomic, assign, readonly) SXCameraFrameRate frameRate;
@property (nonatomic, assign, readonly) SXCameraSourceType type;
@property (nonatomic, assign)           SXCameraPosition position;

- (instancetype)initWithSize:(SXCameraSize)size
                   frameRate:(SXCameraFrameRate)frameRate
                    position:(SXCameraPosition)position
                        type:(SXCameraSourceType)type;

- (void)start;

- (void)stop;

- (void)focusAt:(CGPoint)point;

- (void)enableTorch:(BOOL)enable;


@end

NS_ASSUME_NONNULL_END
