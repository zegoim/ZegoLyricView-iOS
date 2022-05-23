//
//  MediaPlayer.m
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import "MediaPlayer.h"
#import <YYKit/YYKit.h>

#define TIMER_INTERVAL 0.03

@interface MediaPlayer () <ZegoMediaPlayerEventHandler>

@property (nonatomic, strong) ZegoMediaPlayer *player;
@property (nonatomic, strong) YYTimer *timer;

@property (nonatomic, assign) unsigned long long realProgress;
@property (nonatomic, assign) unsigned long long lastSimuProgress;
@property (nonatomic, strong) NSDate *realProgressDate;
@property (nonatomic, assign) BOOL enableProgressUpdateEvent;

@end

@implementation MediaPlayer

- (instancetype)initWithRTCLoader:(RTCLoader *)rtcLoader {
  if (self = [super init]) {
    _player = [rtcLoader getMediaPlayerInstance];
    [_player setEventHandler:self];
  }
  return self;
}

- (void)play:(Song *)song {
  [self stop];
  [self.player loadCopyrightedMusicResourceWithPosition:song.resourceID startPosition:0 callback:^(int errorCode) {
    NSLog(@"[PLAYER] Play song: %@, error: %d", song.songID, errorCode);
    [self.player start];
  }];
}

- (void)stop {
  [self.player stop];
}

#pragma mark - Timer
- (void)timerAction {
  if (self.enableProgressUpdateEvent) {
    unsigned long long simulatedProgress = ({
      unsigned long long progress = 0;
      if (self.realProgressDate) {
        NSTimeInterval msSinceLastProgressUpdate = [[NSDate date] timeIntervalSinceDate:self.realProgressDate] * 1000;
        progress = self.realProgress + msSinceLastProgressUpdate;
      }
      progress;
    });
    
    // 打印相邻两次模拟时间的差值
    //    NSLog(@"[PLAYER] PROGRESS_DIFF: %llu", simulatedProgress - self.lastSimuProgress);
    //    self.lastSimuProgress = simulatedProgress;
    [self.listener onMediaPlayerSimulatedProgressUpdate:simulatedProgress];
  }
}

- (YYTimer *)timer {
  if (!_timer) {
    _timer = [YYTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerAction) repeats:YES];
  }
  return _timer;
}

#pragma mark - Callback
- (void)mediaPlayer:(ZegoMediaPlayer *)mediaPlayer playingProgress:(unsigned long long)millisecond {
  
//  if (millisecond > 0) {
//    self.enableProgressUpdateEvent = YES;
//  }
  
  self.realProgress = millisecond;
  self.realProgressDate = [NSDate date];
  
//  [self.listener onMediaPlayerProgressUpdate:millisecond];
}

- (void)mediaPlayer:(ZegoMediaPlayer *)mediaPlayer stateUpdate:(ZegoMediaPlayerState)state errorCode:(int)errorCode {
  if (state == ZegoMediaPlayerStatePlaying) {
    self.enableProgressUpdateEvent = YES;
    [self.timer fire];
  }else {
    self.enableProgressUpdateEvent = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.realProgress = 0;
    self.lastSimuProgress = 0;
    self.realProgressDate = nil;
  }
}

@end
