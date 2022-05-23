//
//  ZGKTVLyricByWordView.h
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoLyricModel.h"
#import "ZegoLyricViewConfig.h"

@class ZegoLyricView;

NS_ASSUME_NONNULL_BEGIN

@protocol ZegoLyricViewProtocol <NSObject>

/**
 * 歌曲播放完一行时的歌词回调
 * @param lyricView 对象自己
 * @param lineModel 行信息
 * @param index 行数
 */
- (void)lyricView:(ZegoLyricView *)lyricView didFinishLineWithModel:(ZegoLyricLineModel *)lineModel lineIndex:(NSInteger)index;

@end

@interface ZegoLyricView : UITableView

/**
 * 事件监听对象
 */
@property (nonatomic,  weak ) id<ZegoLyricViewProtocol> lyricDelegate;

/**
 * 设置歌词进度
 */
@property (nonatomic, assign) NSInteger progress;

/**
 * 配置对象
 */
@property (nonatomic, strong) ZegoLyricViewConfig *config;


- (instancetype)initWithFrame:(CGRect)frame config:(ZegoLyricViewConfig *)config;

/// 初始化方法
/// @param frame 位置大小
/// @param style 列表样式
/// @param config 歌词配置
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style config:(ZegoLyricViewConfig *)config;


/**
 * 设置歌词数据, 默认不过滤
 * @param model 歌词数据模型
 */
- (void)setupMusicDataSource:(ZegoLyricModel * _Nullable)model;


/**
 * 设置歌词数据, 根据传入的时间区域过滤
 * @param model 歌词数据模型
 */
- (void)setupMusicDataSource:(ZegoLyricModel * _Nullable)model
                   beginTime:(NSInteger)beginTime
                     endTime:(NSInteger)endTime;

@end

NS_ASSUME_NONNULL_END
