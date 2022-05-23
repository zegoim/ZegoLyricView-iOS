//
//  ZGKTVLyricLabel.h
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoLyricLabel : UILabel

///当前的播放精度
@property (nonatomic, assign) CGFloat progress;
///正在播放时的颜色
@property (nonatomic, strong) UIColor *playingColor;

@end

NS_ASSUME_NONNULL_END
