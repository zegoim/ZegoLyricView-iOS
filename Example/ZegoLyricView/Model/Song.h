//
//  SongInfo.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

@property (nonatomic, copy) NSString *songID;

@property (nonatomic, copy) NSString *resourceID;

@property (nonatomic, copy) NSString *krcToken;

@property (nonatomic, copy) NSString *lyricJson;

@end

NS_ASSUME_NONNULL_END
