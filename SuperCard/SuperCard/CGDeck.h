// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGDeck : NSObject

- (void)addCard:(CGCard *)card;
- (nullable CGCard *)drawRandomCard;

@property (readonly, strong, nonatomic) NSArray<CGCard *> *cards;

@end

NS_ASSUME_NONNULL_END
