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
 * 配置对象
 */
@property (nonatomic, strong) ZegoLyricViewConfig *config;

/**
 * 事件监听对象
 */
@property (nonatomic,  weak ) id<ZegoLyricViewProtocol> lyricDelegate;


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

/**
 * 设置播放器进度, 展示对应歌词
 * @param progress 播放器进度. 单位毫秒(ms)
 */
- (void)setProgress:(NSInteger)progress;

/**
 * 设置播放器进度, 展示对应歌词
 * 仅用于高潮片段资源类型
 * @param progress 播放器进度. 单位毫秒(ms)
 * @param segBeginTime 高潮片段开始时间
 * @param krcFormatOffset krc 歌词与歌曲的偏移时间量
 */
- (void)setAccompanimentClipProgress:(NSInteger)progress
                        segBeginTime:(NSInteger)segBeginTime
                     krcFormatOffset:(NSInteger)krcFormatOffset;

@end

NS_ASSUME_NONNULL_END
