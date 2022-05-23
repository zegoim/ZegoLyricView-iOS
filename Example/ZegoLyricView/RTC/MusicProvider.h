//
//  MusicProvider.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCLoader.h"
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicProvider : NSObject

- (instancetype)initWithRTCLoader:(RTCLoader *)rtcLoader;

- (void)loadNext:(void(^)(Song *))complete;

@end

NS_ASSUME_NONNULL_END
