//
//  ZGKTVLyricByWordView.m
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricView.h"
#import "ZegoLyricCell.h"
#import "ZegoLyricLineFeedRecord.h"

#ifndef ZEGO_LYRIC_LF_POS_INIT_VAL
#define ZEGO_LYRIC_LF_POS_INIT_VAL -1
#endif

#ifndef ZEGO_LYRIC_CUR_ROW_INIT_VAL
#define ZEGO_LYRIC_CUR_ROW_INIT_VAL -1
#endif

@interface ZegoLyricView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic,strong)ZegoLyricModel *model;
@property (nonatomic,assign)NSInteger currentRow;

/// 当前已经换行的行数
@property (nonatomic, assign) NSInteger lfPos;

/// 换行记录
@property (nonatomic, strong) NSMutableArray *lfRecords;

@end

@implementation ZegoLyricView

- (instancetype)initWithFrame:(CGRect)frame config:(ZegoLyricViewConfig *)config {
  return [self initWithFrame:frame style:UITableViewStyleGrouped config:config];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style config:(ZegoLyricViewConfig *)config {
  self = [super initWithFrame:frame style:style];
  if (self) {
    _config = config;
    _currentRow = ZEGO_LYRIC_CUR_ROW_INIT_VAL;
    _lfPos = ZEGO_LYRIC_LF_POS_INIT_VAL;
    
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[ZegoLyricCell class] forCellReuseIdentifier:NSStringFromClass(ZegoLyricCell.class)];
  }
  return self;
}

- (void)setupMusicDataSource:(ZegoLyricModel *)model {
  _model = model;
  if (!model) {
    [self reset];
  }
  [self addDummyLinesInPlace:model];
  [self reloadData];
}

- (void)setupMusicDataSource:(ZegoLyricModel *)model beginTime:(NSInteger)beginTime endTime:(NSInteger)endTime {
  if (!model ||
      !model.lines ||
      beginTime >= endTime) {
    [self reset];
    [self setupMusicDataSource:nil];
    return;
  }
  
  [self reset];
  
  // Validation
//  beginTime = MAX(0, beginTime);
//  ZegoLyricLineModel *lastLineModel = model.lines.lastObject;
//  if (lastLineModel) {
//    NSInteger eTime = lastLineModel.beginTime + lastLineModel.duration;
//    endTime = MIN(endTime, eTime);
//  }
  
  ZegoLyricModel *filteredModel = [self filterModel:model fromBeginTime:beginTime toEndtime:endTime];
  [self setupMusicDataSource:filteredModel];
}

- (ZegoLyricModel *)filterModel:(ZegoLyricModel *)model fromBeginTime:(NSInteger)beginTime toEndtime:(NSInteger)endTime {
  NSMutableArray *lines = [NSMutableArray array];
  [model.lines enumerateObjectsUsingBlock:^(ZegoLyricLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (obj.beginTime > endTime) {
      return;
    }
    if (obj.beginTime + obj.duration < beginTime) {
      return;
    }
    [lines addObject:obj];
  }];
  model.lines = lines.copy;
  return model;
}

- (void)addDummyLinesInPlace:(ZegoLyricModel *)lyricModel {
  NSMutableArray *lineArray = [lyricModel.lines mutableCopy];
  ZegoLyricLineModel *lineModel = [ZegoLyricLineModel dummyMax];
  [lineArray addObject:lineModel];
  lyricModel.lines = [lineArray copy];
}

- (void)reset {
  self.model = nil;
  self.currentRow = ZEGO_LYRIC_CUR_ROW_INIT_VAL;
  self.lfPos = ZEGO_LYRIC_LF_POS_INIT_VAL;
  [self.lfRecords removeAllObjects];
  [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  [self reloadData];
}

- (void)setConfig:(ZegoLyricViewConfig *)config {
  _config = config;
  [self reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.model ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.model.lines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ZegoLyricCell *lrcCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZegoLyricCell.class)];
  ZegoLyricLineModel *lineModel = self.model.lines[indexPath.row];
  lrcCell.lyricLineModel = lineModel;
  lrcCell.config = self.config;
  [lrcCell setCellCurrentRow:indexPath.row playingRow:self.currentRow];
  return lrcCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat cellHeight = CGRectGetHeight(self.bounds) / self.config.lineCount;
  CGFloat height = MAX(20, cellHeight);
  return height;
}

- (void)setCurrentRow:(NSInteger)currentRow currentTime:(NSInteger)currentTime {
    if (self.currentRow != currentRow) {
        self.currentRow = currentRow;
        [self reloadData];
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]
                    atScrollPosition:UITableViewScrollPositionTop
                            animated:YES];
    } else {
        //如果是同一行要考虑逐字动画
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
        ZegoLyricCell *cell = [self cellForRowAtIndexPath:indexPath];
        [cell updateTextProgress:currentTime];
    }

}

- (void)setProgress:(NSInteger)progress {
    if (progress < 0) {
        return;
    }
    _progress = progress;
    
  [self updateLyric:progress];
  [self linefeed:progress];
}

- (void)updateLyric:(NSInteger)progress {
  dispatch_async(dispatch_get_main_queue(), ^{
    CGFloat secTime = progress;
    for (int i = 0; i < self.model.lines.count; i++) {
      ZegoLyricLineModel *lineModel = self.model.lines[i];
      if (lineModel.beginTime > secTime) {
        NSInteger currentRow = 0;
        if (i > 0) {
          currentRow = i - 1;
        }
        [self setCurrentRow:currentRow currentTime:progress];
        break;
      }
    }
  });
}

#pragma mark - Linefeed
- (void)linefeed:(NSInteger)progress {
  NSInteger pos = [self getCurLFPos:progress];
  if (self.lfPos + 1 != pos) {
    self.lfPos = pos;
    return;
  }
  if ([self isLineFeedAtPos:pos]) {
    self.lfPos = pos;
    [self addLFRecordAtPos:pos];
    ZegoLyricLineModel *lineModel = self.model.lines[pos];
    [self.lyricDelegate lyricView:self didFinishLineWithModel:lineModel lineIndex:pos];
  }
}

- (NSInteger)getCurLFPos:(NSInteger)progress {
  NSInteger pos = ZEGO_LYRIC_LF_POS_INIT_VAL;
  for (int i = 0; i < self.model.lines.count; i++) {
    ZegoLyricLineModel *lineModel = self.model.lines[i];
    ZegoLyricWordModel *lastWord = lineModel.words.lastObject;
    if (lastWord) {
      NSInteger endTime = lineModel.beginTime + lastWord.offset + lastWord.duration;
      if (progress >= endTime) {
        pos = i;
      } else {
        break;
      }
    }
  }
  return pos;
}

- (BOOL)isLineFeedAtPos:(NSInteger)pos {
  /**
   * 如果当前 pos 已经存在于数组内, 则不是真正换行
   * 如果 pos 比较不相等, 则移除
   */
  NSMutableIndexSet *removeIndices = [NSMutableIndexSet indexSet];
  for (int i = 0; i < self.lfRecords.count; i++) {
    ZegoLyricLineFeedRecord *r = self.lfRecords[i];
    if (r.pos == pos) {
      return NO;
    }
    [removeIndices addIndex:i];
  }
  [self.lfRecords removeObjectsAtIndexes:removeIndices];
  
  return YES;
}

- (void)addLFRecordAtPos:(NSInteger)pos {
  ZegoLyricLineFeedRecord *record = [[ZegoLyricLineFeedRecord alloc] init];
  record.pos = pos;
  record.time = [[NSDate date] timeIntervalSince1970];
  [self.lfRecords addObject:record];
}

- (NSMutableArray *)lfRecords {
  if (!_lfRecords) {
    _lfRecords = [NSMutableArray array];
  }
  return _lfRecords;
}

@end
