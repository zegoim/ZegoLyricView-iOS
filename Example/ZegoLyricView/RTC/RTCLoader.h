//
//  RTCLoader.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZegoExpressEngine/ZegoExpressEngine.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RTCEventListener <NSObject>

- (void)onRTCLoadComplete;

@end

@interface RTCLoader : NSObject

@property (nonatomic, weak) id<RTCEventListener> listener;

- (void)loadRTC;
- (ZegoCopyrightedMusic *)getCopyrightedMusicInstance;
- (ZegoMediaPlayer *)getMediaPlayerInstance;

@end

NS_ASSUME_NONNULL_END
