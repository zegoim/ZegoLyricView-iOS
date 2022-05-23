//
//  ZGKTVLyricViewConfig.h
//  GoChat
//
//  Created by zego on 2021/11/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoLyricViewConfig : NSObject

/**
 * 每行歌词的 beginTime 是否需要校正偏移量.
 * 完整歌曲需要校正, 传 YES;
 * 高潮片段歌曲不需要校正, 传 NO
 * 默认为 YES
 */
@property (nonatomic, assign) BOOL shouldTrimBeginTime;

/**
 * 歌词行数, 默认 2 行
 */
@property (nonatomic, assign) NSUInteger lineCount;

/**
 * 文字播放的高亮颜色
 */
@property (nonatomic, strong) UIColor *playingColor;

/**
 * 未播放时的默认颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 * 播放时的字体大小
 */
@property (nonatomic, strong) UIFont *playingFont;

@end

NS_ASSUME_NONNULL_END
