// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

NS_ASSUME_NONNULL_BEGIN

@interface CGCard : NSObject

- (int)matchTwoCards:(NSArray<CGCard *> *)otherCards; // Abstract.
- (int)matchThreeCards:(NSArray<CGCard *> *)otherCards; // Abstract.

@property (nonatomic) BOOL chosen;
@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL matched;

@end

NS_ASSUME_NONNULL_END
