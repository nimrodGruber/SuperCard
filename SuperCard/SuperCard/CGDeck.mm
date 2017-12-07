// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGDeck()

@property (strong, nonatomic) NSMutableArray *cards; // Of CGCard.

@end

@implementation CGDeck

- (instancetype)init {
  if (self = [super init]) {
    _cards = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)addCard:(CGCard *)card {
  [self addCard:card atTop:NO];
}

- (void)addCard:(CGCard *)card atTop:(BOOL)atTop {
  if (atTop) {
      [self.cards insertObject:card atIndex:0];
  } else {
      [self.cards addObject:card];
  }
}

- (CGCard *)drawRandomCard {
  CGCard *randomCard = nil;
  
  if (self.cards.count) {
    unsigned index = arc4random() % self.cards.count;
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  
  return randomCard;
}

@end

NS_ASSUME_NONNULL_END
