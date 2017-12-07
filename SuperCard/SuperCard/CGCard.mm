// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGCard()

@end

@implementation CGCard
 
- (instancetype)init {
  if (self = [super init]) {
    _contents = @"?";
    _chosen = NO;
    _matched = NO;
  }
  
  return self;
}

- (int)match:(NSArray *)otherCards {
  int score = 0;
  
  for (CGCard *card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      score = 1;
    }
  }
  return score;
}
  
- (int)match:(NSArray __unused *)otherCards matchMethod:(NSUInteger __unused)matchMethod {
  int score = 1;
  // Empty.
  return score;
}

- (int)matchTwoCards:(NSArray __unused *)otherCards {
  int score = 1;
  // Empty.
  return score;
}

- (int)matchThreeCards:(NSArray __unused *)otherCards {
  int score = 1;
  // Empty.
  return score;
}

@end

NS_ASSUME_NONNULL_END
