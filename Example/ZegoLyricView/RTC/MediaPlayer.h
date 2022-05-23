//
//  MediaPlayer.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCLoader.h"
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MediaPlayerListener <NSObject>

//- (void)onMediaPlayerProgressUpdate:(unsigned long long)progress;
- (void)onMediaPlayerSimulatedProgressUpdate:(unsigned long long)progress;

@end

@interface MediaPlayer : NSObject

@property (nonatomic, weak) id<MediaPlayerListener> listener;

- (instancetype)initWithRTCLoader:(RTCLoader *)rtcLoader;

- (void)play:(Song *)song;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
