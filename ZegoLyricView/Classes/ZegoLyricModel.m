//
//  ZGKTVLyricModel.m
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricModel.h"

@implementation ZegoLyricModel

+ (instancetype)analyticalLyricData:(id)jsonData {
  return [self analyzeLyricData:jsonData trim:YES];
}

+ (instancetype)analyzeLyricData:(id)jsonData trim:(BOOL)trim {
  if (jsonData) {
    NSDictionary *dic = [self dictionaryWithJSON:jsonData];
    ZegoLyricModel *model = [[ZegoLyricModel alloc]init];
    model.al = dic[@"al"];
    model.ar = dic[@"ar"];
    model.au = dic[@"au"];
    model.by = dic[@"by"];
    model.offset = dic[@"offset"];
    model.re = dic[@"re"];
    model.ti = dic[@"ti"];
    model.ve = dic[@"ve"];
    model.total = [dic[@"total"]integerValue];
    model.krcFormatOffset = [dic[@"krc_format_offset"]integerValue];
    NSMutableArray *linesArray = [NSMutableArray array];
    NSArray *array = dic[@"lines"];
    if ([array isKindOfClass:[NSArray class]]) {
      for (int i =0; i<array.count; i++) {
        NSDictionary *lineDic = array[i];
        ZegoLyricLineModel *lineModel = [model analyticalLyricLineData:lineDic trim:trim];
        if (lineModel) {
          [linesArray addObject:lineModel];
        }
      }
      model.lines = [linesArray copy];
    }
    return model;
  } else {
    return nil;
  }
}

- (ZegoLyricLineModel *)analyticalLyricLineData:(NSDictionary *)dic trim:(BOOL)trim {
  if (!dic) {
    return nil;
  }
  ZegoLyricLineModel *lineModel = [[ZegoLyricLineModel alloc]init];
  lineModel.beginTime = ({
    NSInteger time = [dic[@"begin_time"]integerValue];
    if (trim) {
      time -= self.krcFormatOffset;
    }
    time;
  });
  lineModel.duration = [dic[@"duration"]integerValue];
  lineModel.content = dic[@"content"];
  NSArray *words = dic[@"words"];
  NSMutableArray *wordsArray = [NSMutableArray array];
  if ([words isKindOfClass:[NSArray class]]) {
    for (int i = 0; i<words.count; i++) {
      NSDictionary *wordDic = words[i];
      ZegoLyricWordModel *wordModel = [[ZegoLyricWordModel alloc]init];
      wordModel.word = wordDic[@"word"];
      wordModel.duration = [wordDic[@"duration"]integerValue];
      wordModel.offset = [wordDic[@"offset"]integerValue];
      [wordsArray addObject:wordModel];
    }
    lineModel.words = [wordsArray copy];
  }
  return lineModel;
}

- (ZegoLyricLineModel *)analyticalLyricLineData:(NSDictionary *)dic {
  if (!dic) {
    return nil;
  }
  ZegoLyricLineModel *lineModel = [[ZegoLyricLineModel alloc]init];
  lineModel.beginTime = [dic[@"begin_time"]integerValue] - self.krcFormatOffset;
  lineModel.duration = [dic[@"duration"]integerValue];
  lineModel.content = dic[@"content"];
  NSArray *words = dic[@"words"];
  NSMutableArray *wordsArray = [NSMutableArray array];
  if ([words isKindOfClass:[NSArray class]]) {
    for (int i = 0; i<words.count; i++) {
      NSDictionary *wordDic = words[i];
      ZegoLyricWordModel *wordModel = [[ZegoLyricWordModel alloc]init];
      wordModel.word = wordDic[@"word"];
      wordModel.duration = [wordDic[@"duration"]integerValue];
      wordModel.offset = [wordDic[@"offset"]integerValue];
      [wordsArray addObject:wordModel];
    }
    lineModel.words = [wordsArray copy];
  }
  return lineModel;
}

+ (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

@end

@implementation ZegoLyricLineModel

+ (instancetype)dummyMax {
  ZegoLyricLineModel *lineModel = [[ZegoLyricLineModel alloc]init];
  lineModel.duration = NSIntegerMax;
  lineModel.beginTime = NSIntegerMax;
  return lineModel;
}

@end

@implementation ZegoLyricWordModel

@end
