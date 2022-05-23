//
//  ZGKTVLyricCell.m
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricCell.h"
#import "ZegoLyricLabel.h"
#import "ZegoLyricLineModel+ZegoLyricExtension.h"

#define ZEGOColorRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define ZEGOColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define ZEGOColorHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1]
#define ZEGOColorRandom [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

@interface ZegoLyricCell ()

@property (nonatomic, strong) ZegoLyricLabel *lyricLabel;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSInteger playingRow;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation ZegoLyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.lyricLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.scrollerView.contentOffset = CGPointZero;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat scrollViewX = 10;
  [self.scrollerView setFrame:CGRectMake(scrollViewX,
                                         (self.contentView.bounds.size.height - 25) * 0.5,
                                         self.contentView.bounds.size.width - scrollViewX * 2,
                                         25)];
  CGFloat offsetX = 0;
  if (self.scrollerView.frame.size.width < self.lineWidth) {
    self.scrollerView.contentSize = CGSizeMake(self.lineWidth, 25);
  } else {
    self.scrollerView.contentSize = CGSizeMake(self.bounds.size.width - 2 * scrollViewX, 25);
    offsetX = (self.scrollerView.contentSize.width - self.lineWidth) * 0.5;
    self.scrollerView.contentOffset = CGPointMake(0, 0);
  }
  [self.lyricLabel setFrame:CGRectMake(offsetX, 0, self.lineWidth, 25)];
}

- (void)setLyricLineModel:(ZegoLyricLineModel *)lyricLineModel {
  _lyricLineModel = lyricLineModel;
  [self.lyricLabel setText:lyricLineModel.content];
  
}

- (void)setConfig:(ZegoLyricViewConfig *)config {
  _config = config;
  [self.lyricLabel setPlayingColor:config.playingColor];
}

- (void)setCellCurrentRow:(NSInteger)currentRow playingRow:(NSInteger)playingRow {
  _currentRow = currentRow;
  _playingRow = playingRow;
  NSInteger distance = currentRow - playingRow;
  switch (distance) {
    case -1:
    {
      self.lyricLabel.progress = 0;
      UIColor *textColor = self.config.normalColor ?: [UIColor whiteColor];
      self.lyricLabel.textColor = textColor;
      UIFont *font = self.config.playingFont ? :[UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
      self.lyricLabel.font = font;
      self.lineWidth = [self.lyricLineModel calculateContentWidth:font content:self.lyricLineModel.content];
    }
      break;
      
    case 0:
    {
      self.lyricLabel.progress = _currentProgress;
      self.lyricLabel.textColor =  self.config.normalColor ?: UIColor.whiteColor;//(0xFF3571);
      UIFont *font = self.config.playingFont ? :[UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
      self.lyricLabel.font = font;
      self.lineWidth = [self.lyricLineModel calculateContentWidth:font content:self.lyricLineModel.content];
    }
      break;
    
    case 1:
    {
      self.lyricLabel.progress = 0;
      UIColor *textColor = self.config.normalColor ?: [UIColor whiteColor];
      self.lyricLabel.textColor = [textColor colorWithAlphaComponent:0.5];
      UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
      self.lyricLabel.font = font;
      self.lineWidth = [self.lyricLineModel calculateContentWidth:font content:self.lyricLineModel.content];
    }
      break;
      
    default:
    {
      self.lyricLabel.progress = 0;
      UIColor *textColor = self.config.normalColor ?: [UIColor whiteColor];
      self.lyricLabel.textColor = [textColor colorWithAlphaComponent:0.2];
      UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
      self.lyricLabel.font = font;
      self.lineWidth = [self.lyricLineModel calculateContentWidth:font content:self.lyricLineModel.content];
    }
      break;
  }
}

- (void)updateTextProgress:(NSInteger)currentTime {
  //更新进度
  CGFloat progress = [self.lyricLineModel calculateCurrentLrcProgress:currentTime];
  _currentProgress = progress;
  [self.lyricLabel setProgress:progress];
  [self updateTextScrollViewOffset:progress];
}

- (void)updateTextScrollViewOffset:(CGFloat)progress {
  CGFloat location = self.lyricLabel.bounds.size.width * progress;
  if (self.lyricLabel.bounds.size.width > 0 && location > self.scrollerView.bounds.size.width/3) {
    //进度超出了宽度需要滚动scrollview
    CGFloat width = (self.lyricLabel.bounds.size.width - self.scrollerView.bounds.size.width) + 16;
    CGFloat offsetX = location - self.scrollerView.bounds.size.width/3;
    if (offsetX <= width) {
      [self.scrollerView setContentOffset:CGPointMake(offsetX, 0)];
    }
  }
}

#pragma mark -Getter
- (ZegoLyricLabel *)lyricLabel {
  if (!_lyricLabel) {
    _lyricLabel = [[ZegoLyricLabel alloc]init];
    [_lyricLabel setPlayingColor:ZEGOColorHEX(0xFF3571)];
    [_lyricLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium]];
    [_lyricLabel setTextColor:UIColor.whiteColor];
  }
  return _lyricLabel;
}

- (UIScrollView *)scrollerView {
  if (!_scrollerView) {
    _scrollerView = [[UIScrollView alloc]init];
  }
  return _scrollerView;
}

@end
