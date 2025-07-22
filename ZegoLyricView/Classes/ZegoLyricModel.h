//
//  ZGKTVLyricModel.h
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoLyricWordModel : NSObject

@property (nonatomic, assign) NSInteger offset;///相对当前行开始时间的偏移
@property (nonatomic, assign) NSInteger duration;/// 字的时长
@property (nonatomic,  copy ) NSString *word;/// 字的内容 例如英文是一个单词

@end

@interface ZegoLyricLineModel : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger beginTime;///每行歌词开始时间 单位为毫秒
@property (nonatomic, assign) NSInteger duration;///行的时长
@property (nonatomic,  copy ) NSString *content;/// 每行歌词的内容
@property (nonatomic,  copy ) NSArray <ZegoLyricWordModel *>*words;/// 每行歌词的字信息

/**
 * 模拟空数据, 创建对象默认添加到歌词最后一行.
 * 歌词控件内部使用, 外界不要调用.
 */
+ (instancetype)dummyMax;

@end

@interface ZegoLyricModel : NSObject <NSCopying>

@property (nonatomic,  copy ) NSString *al;///唱片集
@property (nonatomic,  copy ) NSString *ar;///歌手
@property (nonatomic,  copy ) NSString *au;///歌词作者
@property (nonatomic,  copy ) NSString *by;///LRC文件的创建者
@property (nonatomic,  copy ) NSString *offset;///+/-以毫秒为单位加快或延后歌词的播放
@property (nonatomic,  copy ) NSString *re;/// 创建此LRC文件的播放器或编辑器
@property (nonatomic,  copy ) NSString *ti;/// 歌词标题
@property (nonatomic,  copy ) NSString *ve;/// 程序版本
@property (nonatomic, assign) NSInteger total;///  总时长
@property (nonatomic, assign) NSInteger krcFormatOffset;///歌词偏移 歌词相对音乐要快多少 单位毫秒
@property (nonatomic,  copy ) NSArray <ZegoLyricLineModel *>*lines;

/**
 * 歌词数据解析
 * @param jsonData 通过SDK获取到的JSON格式歌词数据
 */
+ (instancetype)analyticalLyricData:(id)jsonData;

@end

NS_ASSUME_NONNULL_END
