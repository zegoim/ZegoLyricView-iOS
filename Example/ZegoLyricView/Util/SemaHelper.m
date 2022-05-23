//
//  SemaHelper.m
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import "SemaHelper.h"

@implementation SemaHelper

+ (void)semaWait:(dispatch_semaphore_t)sema {
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

+ (void)semaSignal:(dispatch_semaphore_t)sema {
  dispatch_semaphore_signal(sema);
}

@end
