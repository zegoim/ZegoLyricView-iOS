//
//  User.m
//  ZegoLyricView_Example
//
//  Created by Vic on 2022/4/30.
//  Copyright © 2022 vicwan1992@163.com. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)randomUser {
  User *user = [[User alloc] init];
  user.userID = [user getRandomUserID];
  user.userName = [user getRandomUserName];
  return user;
}

- (NSString *)getRandomUserID {
  uint32_t randomDigit = arc4random_uniform(1000000000);
  NSString *randomUserID = [NSString stringWithFormat:@"%d", randomDigit];
  return randomUserID;
}

- (NSString *)getRandomUserName {
  uint32_t rdNameSuffix = arc4random_uniform(100);
  return [NSString stringWithFormat:@"ios_grab_%d", rdNameSuffix];
}

@end
