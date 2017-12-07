// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGDeck.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGCardGame : NSObject

- (CGCard *)cardAtIndex:(NSUInteger)index; // Abstract.
- (void)chooseCardAtIndex:(NSUInteger)index; // Abstract.

@property (nonatomic) NSMutableString *log;
@property (nonatomic) NSUInteger matchMode;
@property (nonatomic) NSInteger score;
@property (strong, nonatomic, nullable) NSMutableArray<CGCard *> *pickedCards;
@property (nonatomic) int lastMatchScoring;

@end

NS_ASSUME_NONNULL_END
