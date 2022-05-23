//
//  ZGKTVLyricLineModel+ZGKTVLyricExtension.h
//  GoChat
//
//  Created by zego on 2021/11/11.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoLyricLineModel (ZegoLyricExtension)

/// 计算内容的宽度
/// @param font 字体大小
/// @param content 内容
- (CGFloat)calculateContentWidth:(UIFont *)font content:(NSString *)content;


/// 根据时间计算进度
/// @param currentTime 当前时间戳
- (CGFloat)calculateCurrentLrcProgress:(NSInteger)currentTime;

@end

NS_ASSUME_NONNULL_END
