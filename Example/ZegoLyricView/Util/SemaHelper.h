//
//  SemaHelper.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SemaHelper : NSObject

+ (void)semaWait:(dispatch_semaphore_t)sema;

+ (void)semaSignal:(dispatch_semaphore_t)sema;

@end

NS_ASSUME_NONNULL_END
