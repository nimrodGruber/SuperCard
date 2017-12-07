// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryBoss : NSObject

@property (strong, nonatomic) NSMutableArray<NSString *> *logMatchGame;
@property (strong, nonatomic) NSMutableArray<NSString *> *logSetGame;

@end

NS_ASSUME_NONNULL_END
