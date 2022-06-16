//
//  ZGKTVLyricViewConfig.m
//  GoChat
//
//  Created by zego on 2021/11/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricViewConfig.h"

@implementation ZegoLyricViewConfig

- (instancetype)init {
  self = [super init];
  if (self) {
    [self defaultConfig];
  }
  return self;
}

- (void)defaultConfig {
  _lineCount = 2;
  _playingFont = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
  _playingColor = [UIColor redColor];
  _normalColor = [UIColor whiteColor];
}

- (NSUInteger)lineCount {
  _lineCount = MAX(1, _lineCount);
  return _lineCount;
}

@end
