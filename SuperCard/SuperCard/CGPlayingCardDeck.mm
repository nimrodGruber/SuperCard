// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGPlayingCard.h"
#import "CGPlayingCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CGPlayingCardDeck

- (instancetype)init {
  if (self = [super init]) {
    for (NSString *suit in [CGPlayingCard validSuits]) {
      for (NSUInteger rank = 1; rank <= [CGPlayingCard maxRank]; ++rank){
        CGPlayingCard *card = [[CGPlayingCard alloc] initWithValues:(NSUInteger)rank suit:(NSString *)suit];
        [self addCard:card];
      }
    }
  }
    
  return self;
}

@end

NS_ASSUME_NONNULL_END
