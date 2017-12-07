// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGDeck : NSObject

- (void)addCard:(CGCard *)card;
- (void)addCard:(CGCard *)card atTop:(BOOL)atTop;

- (CGCard *)drawRandomCard;

@end

NS_ASSUME_NONNULL_END
