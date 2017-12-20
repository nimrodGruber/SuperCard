// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPlayingCard : CGCard

- (instancetype)initWithValues:(NSUInteger)rank suit:(NSString *)suit;

+ (NSUInteger)maxRank;
+ (NSArray<NSString *> *)validSuits;

@property (readonly, nonatomic) NSUInteger rank;
@property (strong, readonly, nonatomic) NSString *suit;

@end

NS_ASSUME_NONNULL_END
