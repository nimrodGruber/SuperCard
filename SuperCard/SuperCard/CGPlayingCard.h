// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPlayingCard : CGCard

+ (NSUInteger)maxRank;
+ (NSArray *)validSuits;

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@end

NS_ASSUME_NONNULL_END
