//
//  ZGKTVLyricLineModel+ZGKTVLyricExtension.m
//  GoChat
//
//  Created by zego on 2021/11/11.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricLineModel+ZegoLyricExtension.h"

@implementation ZegoLyricLineModel (ZGKTVLyricExtension)

- (CGFloat)calculateContentWidth:(UIFont *)font content:(NSString *)content {
  NSDictionary *attrs = @{NSFontAttributeName:font};
  CGSize size = [content sizeWithAttributes:attrs];
  return ceilf(size.width);
}


- (CGFloat)calculateCurrentLrcProgress:(NSInteger)currentTime {
  NSInteger offsetTime = currentTime - self.beginTime;
  
  ZegoLyricWordModel *lastWord;
  //念完所有字花费的总时长
  NSInteger allWordDuration = 0;
  if (self.words.count > 0) {
    lastWord = self.words[self.words.count - 1];
    allWordDuration = lastWord.offset + lastWord.duration;
  }
  
  CGFloat progressAll = 0.f;
  
  if (offsetTime < allWordDuration) {
    for (int i = 0; i<self.words.count; i++) {
      ZegoLyricWordModel *wordModel = self.words[i];
      if (offsetTime >= wordModel.offset && offsetTime <= wordModel.offset + wordModel.duration) {
        //在这个词组区间内
        //算出之前所有词组的时间占比
        CGFloat progressBefore = i / (CGFloat)self.words.count;
        // 计算当前时间戳在这个词组内的时间占比，线性
        CGFloat percent = 1 / (CGFloat)self.words.count;
        CGFloat progressCurrentWord = (offsetTime - wordModel.offset) / (CGFloat)wordModel.duration;
        // 这两个progress加起来就是总的时间百分比
        progressAll = progressBefore + progressCurrentWord * percent;
        break;
      } else if (i < self.words.count - 1) {
        //不是最后一个字
        ZegoLyricWordModel *nextModel = self.words[i+1];
        //时间在两个字之间
        if (offsetTime > wordModel.offset + wordModel.duration && offsetTime < nextModel.offset) {
          progressAll = (i+1) / (CGFloat)self.words.count;
        }
      }
    }
  }else {
    progressAll = 1.f;
  }
  
  return progressAll;
}

@end
