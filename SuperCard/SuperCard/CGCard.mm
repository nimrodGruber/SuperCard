// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CGCard
 
- (instancetype)init {
  if (self = [super init]) {
    _contents = @"?";
    _chosen = NO;
    _matched = NO;
  }
  
  return self;
}

- (int)matchTwoCards:(NSArray<CGCard *> __unused *)otherCards { // Abstract.
  return 0; // Empty.
}

- (int)matchThreeCards:(NSArray<CGCard *> __unused *)otherCards { // Abstract.
  return 0; // Empty.
}

@end

NS_ASSUME_NONNULL_END
