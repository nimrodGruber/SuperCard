// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCardGame.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CGCardGame

- (nullable instancetype)init {
  if (self = [super init]) {
    _lastMatchScoring = 0;
    _pickedCards = [[NSMutableArray<CGCard *> alloc] init];
    _score = 0;
  }
  
  return self;
}

- (CGCard *)cardAtIndex:(NSUInteger)index { // Abstract.
  return nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index { // Abstract.
}

- (CGDeck *)getDeck { // Abstract.
  return nil;
}

- (CGCard *) getCardAtIndex:(NSUInteger) index { // Abstract.
  return nil;
}

@end

NS_ASSUME_NONNULL_END
