//
//  ZGKTVLyricCell.h
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoLyricModel.h"
#import "ZegoLyricViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoLyricCell : UITableViewCell

@property (nonatomic,strong)ZegoLyricLineModel *lyricLineModel;///每行歌词的数据模型
@property (nonatomic,strong)ZegoLyricViewConfig *config;///歌词个性化配置


/// 设置当前行的一些UI展示状态
/// @param currentRow 当前行的行号
/// @param playingRow 正在播放的行号
- (void)setCellCurrentRow:(NSInteger)currentRow  playingRow:(NSInteger)playingRow;

/// 更新逐字歌词控件的时间
/// @param currentTime 当前时间
- (void)updateTextProgress:(NSInteger)currentTime;

@end

NS_ASSUME_NONNULL_END
