// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGDeck ()

@property (readwrite, strong, nonatomic) NSArray<CGCard *> *cards;

@end

@implementation CGDeck

- (instancetype)init {
  if (self = [super init]) {
    _cards = [[NSArray alloc] init];
  }
  
  return self;
}

- (void)addCard:(CGCard *)card {
  self.cards = [self.cards arrayByAddingObject:card];
  //[self.cards addObject:card];
}

- (nullable CGCard *)drawRandomCard {
  if (self.cards.count) {
    unsigned index = arc4random() % self.cards.count;
    CGCard *randomCard = self.cards[index];
    NSMutableArray *cardsArray = [self.cards mutableCopy];
    [cardsArray removeObjectAtIndex:index];
    self.cards = cardsArray;
    return randomCard;
  }
  
  return nil;
}

@end

NS_ASSUME_NONNULL_END
