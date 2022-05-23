//
//  ZEGOViewController.m
//  ZegoLyricView
//
//  Created by vicwan1992@163.com on 03/22/2022.
//  Copyright (c) 2022 vicwan1992@163.com. All rights reserved.
//

#import "ZEGOViewController.h"
#import "ZegoLyricView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "RTCLoader.h"
#import "MusicProvider.h"
#import "MediaPlayer.h"

@interface ZEGOViewController ()
<
ZegoLyricViewProtocol,
RTCEventListener,
MediaPlayerListener
>

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *loadNextBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) ZegoLyricView *lyricView;
@property (nonatomic, strong) RTCLoader *rtcLoader;
@property (nonatomic, strong) MusicProvider *musicProvider;
@property (nonatomic, strong) MediaPlayer *player;

@property (nonatomic, strong) Song *curLoadedSong;

@end

@implementation ZEGOViewController

- (UIStackView *)stackView {
  if (!_stackView) {
    UIStackView *view = [[UIStackView alloc] initWithArrangedSubviews:@[
      self.loadNextBtn,
      self.playBtn
    ]];
    view.axis = UILayoutConstraintAxisHorizontal;
    view.spacing = 10;
    view.distribution = UIStackViewDistributionFillProportionally;
    [self.view addSubview:view];
    _stackView = view;
  }
  return _stackView;
}

- (UIButton *)loadNextBtn {
  if (!_loadNextBtn) {
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:self action:@selector(loadNextAction) forControlEvents:UIControlEventTouchUpInside];
    [view setTitle:@"下一曲" forState:UIControlStateNormal];
    [view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _loadNextBtn = view;
  }
  return _loadNextBtn;
}

- (UIButton *)playBtn {
  if (!_playBtn) {
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [view setTitle:@"播放" forState:UIControlStateNormal];
    [view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _playBtn = view;
  }
  return _playBtn;
}

- (MBProgressHUD *)hud {
  if (!_hud) {
    MBProgressHUD *view = [[MBProgressHUD alloc] initWithView:self.view];
    view.removeFromSuperViewOnHide = NO;
    view.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    view.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    view.minShowTime = 0.5;
    [self.view addSubview:view];
    _hud = view;
  }
  return _hud;
}

- (RTCLoader *)rtcLoader {
  if (!_rtcLoader) {
    _rtcLoader = [[RTCLoader alloc] init];
    _rtcLoader.listener = self;
  }
  return _rtcLoader;
}

- (MusicProvider *)musicProvider {
  if (!_musicProvider) {
    _musicProvider = [[MusicProvider alloc] initWithRTCLoader:self.rtcLoader];
  }
  return _musicProvider;
}

- (MediaPlayer *)player {
  if (!_player) {
    _player = [[MediaPlayer alloc] initWithRTCLoader:self.rtcLoader];
    [_player setListener:self];
  }
  return _player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  [self.hud showAnimated:YES];
  
  [self.rtcLoader loadRTC];
}

- (void)updateViewConstraints {
  
  [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(44);
    make.top.equalTo(self.view).offset(100);
    make.left.equalTo(self.view).offset(12);
    make.right.equalTo(self.view).inset(12);
  }];
  
  [self.lyricView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.stackView.mas_bottom).offset(50);
    make.height.mas_equalTo(300);
  }];
  
  [super updateViewConstraints];
}

- (ZegoLyricView *)lyricView {
  if (!_lyricView) {
    ZegoLyricViewConfig *lyricViewConfig = [ZegoLyricViewConfig new];
    lyricViewConfig.playingFont = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    lyricViewConfig.playingColor = UIColorHex(0xFF3571);
    lyricViewConfig.normalColor = [UIColor whiteColor];
    lyricViewConfig.lineCount = 15;
    
    ZegoLyricView *lyricView = [[ZegoLyricView alloc] initWithFrame:CGRectZero config:lyricViewConfig];
    lyricView.lyricDelegate = self;
    lyricView.separatorStyle = UITableViewCellSeparatorStyleNone;
    lyricView.backgroundColor = [UIColor purpleColor];
    lyricView.userInteractionEnabled = NO;
    lyricView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:lyricView];
    _lyricView = lyricView;
  }
  return _lyricView;
}

#pragma mark - Action

- (void)loadNextAction {
  [self.player stop];
  [self loadNextActionComplete:nil];
}

- (void)loadNextActionComplete:(void(^)(Song *))complete {
  self.hud.label.text = @"加载中...";
  [self.hud showAnimated:YES];
  [self.musicProvider loadNext:^(Song * song) {
    self.hud.label.text = @"加载完毕";
    [self.hud hideAnimated:YES];
    if (song) {
      self.curLoadedSong = song;
    }
    if (complete) {
      complete(song);
    }
  }];
}

- (void)playAction {
  [self loadLyricForSong:self.curLoadedSong];
  [self.player play:self.curLoadedSong];
}

- (void)loadLyricForSong:(Song *)song {
  ZegoLyricModel *model = [ZegoLyricModel analyticalLyricData:song.lyricJson];
  [self.lyricView setupMusicDataSource:model];
}

#pragma mark - Lyric Callback
- (void)lyricView:(ZegoLyricView *)lyricView didFinishLineWithModel:(ZegoLyricLineModel *)lineModel lineIndex:(NSInteger)index {
  
}

#pragma mark - RTC Callback
- (void)onRTCLoadComplete {
  [self.hud hideAnimated:YES];
  
  [self loadNextActionComplete:^(Song *song) {
    if (song) {
      [self playAction];
    }
  }];
}

- (void)onMediaPlayerSimulatedProgressUpdate:(unsigned long long)progress {
  NSLog(@"[PLAYER] progress: %llu", progress);
  [self.lyricView setProgress:progress];
}

@end
