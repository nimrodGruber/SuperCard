// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

//#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGCard : NSObject

- (int)match:(NSArray *)otherCards;

@property (nonatomic) BOOL chosen;
@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL matched;

- (int)match:(NSArray *)otherCards matchMethod:(NSUInteger)matchMethod; // Abstract.
- (int)matchTwoCards:(NSArray *)otherCards; // Abstract.
- (int)matchThreeCards:(NSArray *)otherCards; // Abstract.

@end

NS_ASSUME_NONNULL_END
