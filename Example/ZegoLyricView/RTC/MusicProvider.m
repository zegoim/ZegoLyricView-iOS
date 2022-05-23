//
//  MusicProvider.m
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import "MusicProvider.h"
#import "SemaHelper.h"
#import <YYKit/YYKit.h>

typedef void(^SongDownloadCallback)(int errorCode, float progress);

@interface MusicProvider () <ZegoCopyrightedMusicEventHandler>

@property (nonatomic, strong) ZegoCopyrightedMusic *copyrightMusic;
@property (nonatomic, strong) dispatch_semaphore_t songRequestSema;
@property (nonatomic, strong) dispatch_semaphore_t loadNextSema;

@property (nonatomic, copy) NSArray *songIDs;
@property (nonatomic, assign) NSInteger curSongIndex;

@property (nonatomic, strong) NSMutableDictionary *downloadCallbackTable;

@end

@implementation MusicProvider

- (dispatch_semaphore_t)songRequestSema {
  if (!_songRequestSema) {
    _songRequestSema = dispatch_semaphore_create(0);
  }
  return _songRequestSema;
}

- (dispatch_semaphore_t)loadNextSema {
  if (!_loadNextSema) {
    _loadNextSema = dispatch_semaphore_create(0);
  }
  return _loadNextSema;
}

- (NSArray *)songIDs {
  if (!_songIDs) {
    _songIDs = @[
      @"32091330",
      @"39560086",
      @"68025605",
      @"106774473",
      @"27605998",
      @"39560086",
      @"68025605",
      @"106774473",
      @"27605998"
    ];
  }
  return _songIDs;
}

- (instancetype)initWithRTCLoader:(RTCLoader *)rtcLoader {
  if (self = [super init]) {
    _copyrightMusic = [rtcLoader getCopyrightedMusicInstance];
    [_copyrightMusic setEventHandler:self];
    _downloadCallbackTable = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)loadNext:(void(^)(Song *))complete {
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    NSString *nextSongID = self.songIDs[[self getNextIndex]];
    
    __block Song *song = nil;
    [self requestSongWithSongID:nextSongID complete:^(Song *s) {
      song = s;
      [SemaHelper semaSignal:self.loadNextSema];
    }];
    
    [SemaHelper semaWait:self.loadNextSema];
  
    if (!song) {
      [self loadNext:complete];
      return;
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self downloadSong:song callback:^(int errorCode, float progress) {
      if (errorCode) {
        dispatch_group_leave(group);
        [self loadNext:complete];
        return;
      }
      if (progress >= 1) {
        dispatch_group_leave(group);
      }
    }];
    
    dispatch_group_enter(group);
    [self downloadSongLyric:song callback:^(NSString *lyricJson) {
      dispatch_group_leave(group);
      if (!lyricJson) {
        [self loadNext:complete];
      }else {
        song.lyricJson = lyricJson;
      }
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      !complete ?: complete(song);
    });
  });
}



- (NSInteger)getNextIndex {
  self.curSongIndex += 1;
  return self.curSongIndex % self.songIDs.count;
}

- (void)requestSongWithSongID:(NSString *)songID complete:(void(^)(Song *))complete {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    __block NSString *resource = nil;
    
    ZegoCopyrightedMusicRequestConfig *config = [ZegoCopyrightedMusicRequestConfig new];
    config.mode = ZegoCopyrightedMusicBillingModeCount;
    config.songID = songID;
    [self.copyrightMusic requestAccompaniment:config callback:^(int errorCode, NSString * _Nonnull rsc) {
      resource = rsc;
      [SemaHelper semaSignal:self.songRequestSema];
    }];
    
    [SemaHelper semaWait:self.songRequestSema];
    
    if (!resource) {
      !complete ?: complete(nil);
      return;
    }
    
    NSLog(@"[RTC] %@", resource);
    
    NSData *data = [resource dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSDictionary *dataDict = dict[@"data"];
    NSDictionary *resourceDict = [dataDict[@"resources"] firstObject];
    
    Song *song = [Song new];
    song.songID = songID;
    song.resourceID = resourceDict[@"resource_id"];
    song.krcToken = dataDict[@"krc_token"];
    
    !complete ?: complete(song);
  });
}

- (void)downloadSong:(Song *)song callback:(SongDownloadCallback)callback {
  if (!song.resourceID) {
    !callback ?: callback(-1, 0);
    return;
  }
  if (callback && song.resourceID) {
    [self.downloadCallbackTable setObject:callback forKey:song.resourceID];
  }
  [self.copyrightMusic download:song.resourceID callback:^(int errorCode) {
    if (errorCode) {
      !callback ?: callback(-1, 0);
    }
  }];
}

- (void)downloadSongLyric:(Song *)song callback:(void(^)(NSString *lyricJson))callback {
  if (!song.krcToken) {
    !callback ?: callback(nil);
    return;
  }
  [self.copyrightMusic getKrcLyricByToken:song.krcToken callback:^(int errorCode, NSString * _Nonnull lyrics) {
    !callback ?: callback(lyrics);
  }];
}

#pragma mark - Callback
- (void)onDownloadProgressUpdate:(ZegoCopyrightedMusic *)copyrightedMusic resourceID:(NSString *)resourceID progressRate:(float)progressRate {
  SongDownloadCallback callback = [self.downloadCallbackTable objectForKey:resourceID];
  !callback ?: callback(0, progressRate);
}

@end
