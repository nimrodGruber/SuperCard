// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGCardGame : NSObject

- (CGCard *)cardAtIndex:(NSUInteger)index; // Abstract.
- (void)chooseCardAtIndex:(NSUInteger)index; // Abstract.

- (CGDeck *)getDeck; // Abstract.

//@property (strong, nonatomic) CGDeck *deck;
@property (nonatomic) int lastMatchScoring;
@property (nonatomic) NSUInteger matchMode;
@property (strong, nonatomic, nullable) NSMutableArray<CGCard *> *pickedCards;
@property (nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END
