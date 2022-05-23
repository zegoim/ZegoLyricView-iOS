//
//  ZGKTVLyricLabel.m
//  GoChat
//
//  Created by zego on 2021/11/2.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoLyricLabel.h"

@interface ZegoLyricLabel ()

@property (nonatomic, strong) UIColor *styleShadowColor;
@property (nonatomic, assign) BOOL style;

@end

@implementation ZegoLyricLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        _style = YES;
        _playingColor = [UIColor whiteColor];
        _styleShadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return self;
}

//- (void)renderText {
//    if (self.progress <=0) {
//        self.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.59];
//    } else if (self.progress >=1) {
//        self.textColor = [UIColor whiteColor];
//    } else {
//        int fill = (int)(self.progress * (CGFloat)self.text.length);
//        NSString * fillText = [self.text substringWithRange:NSMakeRange(0, fill)];
//        int left = self.text.length - fill;
//        NSString * leftText = left <= 0 ? @"" : [self.text substringWithRange:NSMakeRange(fill, left)];
//        NSMutableAttributedString *renderText = [[NSMutableAttributedString alloc]initWithString:fillText attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//        NSAttributedString *string = [[NSAttributedString alloc]initWithString:leftText attributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor]colorWithAlphaComponent:0.59]}];
//        [renderText appendAttributedString:string];
//
//        self.attributedText = renderText;
//    }
//}


- (void)drawRect:(CGRect)rect {
  // Drawing code
  [super drawRect:rect];
  if (self.progress <= 0) {
    return;
  }
  int lines = (int)(self.bounds.size.height / self.font.lineHeight);
  CGFloat paddingTop = (self.bounds.size.height - (CGFloat)lines * self.font.lineHeight) / 2.0;
  CGFloat maxWidth = [self sizeThatFits:CGSizeMake(MAXFLOAT, self.font.lineHeight * 2)].width;
  CGFloat oneLineProgress = maxWidth <= self.bounds.size.width ? 1 : self.bounds.size.width / maxWidth;
  CGMutablePathRef path = CGPathCreateMutable();
  
  for (int index = 0; index < lines; index++) {
    CGFloat leftProgress = MIN(self.progress, 1) - (CGFloat)index * oneLineProgress;
    CGRect fillRect;
    if (leftProgress >= oneLineProgress) {
      fillRect = CGRectMake(0, paddingTop + (CGFloat)index * self.font.lineHeight, self.bounds.size.width, self.font.lineHeight);
      CGPathAddRect(path, nil, fillRect);
    } else if (leftProgress > 0) {
      if ((index != lines -1) || (maxWidth <= self.bounds.size.width)) {
        fillRect = CGRectMake(0, paddingTop + (CGFloat)index * self.font.lineHeight, maxWidth *leftProgress, self.font.lineHeight);
      } else {
        NSInteger newMaxWidth = maxWidth *1000000;
        NSInteger newSizeWidth = self.bounds.size.width *1000000;
        NSInteger z = newMaxWidth % newSizeWidth;
        CGFloat width = z / 1000000.0;
        CGFloat dw = (self.bounds.size.width - width) / 2 + maxWidth * leftProgress;
        fillRect = CGRectMake(0, paddingTop + (CGFloat)index * self.font.lineHeight, dw, self.font.lineHeight);
      }
      CGPathAddRect(path, nil, fillRect);
      break;
    }
  }
  
  // 1.获取上下文
  CGContextRef contextRef = UIGraphicsGetCurrentContext();
  if (!CGPathIsEmpty(path)) {
    CGContextAddPath(contextRef, path);
    CGContextClip(contextRef);
    UIColor *lastTextColor = self.textColor;
    self.textColor = self.playingColor;
    if (self.style) {
      CGSize shadowOffset = self.shadowOffset;
      UIColor * shadowColor = self.shadowColor;
      self.shadowOffset = CGSizeMake(0, 1);
      self.shadowColor = self.styleShadowColor;
      [super drawRect:rect];
      self.shadowOffset = shadowOffset;
      self.shadowColor = shadowColor;
    } else {
      [super drawRect:rect];
    }
    self.textColor = lastTextColor;
  }
  CGPathRelease(path);
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        [self setNeedsDisplay];//进度更新需要重绘
    }
    _progress = progress;
}

@end
