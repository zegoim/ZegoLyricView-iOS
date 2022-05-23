//
//  RTCLoader.m
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import "RTCLoader.h"
#import "User.h"
#import "SemaHelper.h"

#define appid 332459354
#define appsign @"15d52c171813af207250085c06d6c92fc5c68163761daa070d2cbf7af82f16f3"

#define rtc_sema_init_value 0

@interface RTCLoader () <ZegoEventHandler>

@property (nonatomic, strong) ZegoCopyrightedMusic *copyrightMusic;
@property (nonatomic, strong) ZegoMediaPlayer *mediaPlayer;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) dispatch_semaphore_t sema;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation RTCLoader

- (User *)user {
  if (!_user) {
    _user = [User randomUser];
  }
  return _user;
}

- (dispatch_semaphore_t)sema {
  if (!_sema) {
    _sema = dispatch_semaphore_create(rtc_sema_init_value);
  }
  return _sema;
}

- (dispatch_queue_t)queue {
  if (!_queue) {
    _queue = dispatch_queue_create("RTC Queue", DISPATCH_QUEUE_CONCURRENT);
  }
  return _queue;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self registerCompletionCallback];
  }
  return self;
}

- (void)initEngine {
  ZegoEngineProfile *profile = [[ZegoEngineProfile alloc] init];
  profile.appID = appid;
  profile.appSign = appsign;
  
  [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
}

- (void)initCopyrightedMusic {
  ZegoCopyrightedMusic *obj = [[ZegoExpressEngine sharedEngine] createCopyrightedMusic];
  self.copyrightMusic = obj;
  ZegoCopyrightedMusicConfig *config = [[ZegoCopyrightedMusicConfig alloc] init];
  ZegoUser *user = [[ZegoUser alloc] init];
  user.userID = self.user.userID;
  user.userName = self.user.userName;
  config.user = user;
  [obj initCopyrightedMusic:config callback:^(int errorCode) {
    NSLog(@"[RTC] ZegoCopyrightedMusic init complete: %d", errorCode);
    [SemaHelper semaSignal:self.sema];
  }];
}

- (void)initMediaPlayer {
  ZegoMediaPlayer *obj = [[ZegoExpressEngine sharedEngine] createMediaPlayer];
  self.mediaPlayer = obj;
}

- (void)registerCompletionCallback {
  dispatch_async(self.queue, ^{
    [SemaHelper semaWait:self.sema];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"[RTC] RTC prepare complete");
      [self.listener onRTCLoadComplete];
    });
  });
}

#pragma mark - Public
- (void)loadRTC {
  [self initEngine];
  [self initMediaPlayer];
  [self initCopyrightedMusic];
}

- (ZegoCopyrightedMusic *)getCopyrightedMusicInstance {
  return self.copyrightMusic;
}

- (ZegoMediaPlayer *)getMediaPlayerInstance {
  return self.mediaPlayer;
}

#pragma mark - Callback
- (void)onDebugError:(int)errorCode funcName:(NSString *)funcName info:(NSString *)info {
  NSLog(@"[RTC][E] RTC Error: %d, %@, %@", errorCode, funcName, info);
}

@end
