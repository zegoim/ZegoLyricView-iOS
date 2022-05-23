//
//  User.h
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;

+ (instancetype)randomUser;

@end

NS_ASSUME_NONNULL_END
