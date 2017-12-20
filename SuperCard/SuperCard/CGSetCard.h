// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGSetCard : CGCard

typedef enum {
  red = 0,
  green = 1,
  purple = 2,
  undefinedColor
} ColorType;

typedef enum {
  solid = 0,
  striped = 1,
  unfilled = 2,
  undefinedShade
} ShadeType;

typedef enum {
  diamond = 0,
  oval = 1,
  squiggle = 2,
  undefinedSymbol
} SymbolType;

- (instancetype)initWithCardColor:(int)color usingNumberType:(int)number usingShadeType:(int)shade
                  usingSymbolType:(int)symbol;

@property (nonatomic) ColorType color;
@property (nonatomic) int number;
@property (nonatomic) ShadeType shading;
@property (nonatomic) SymbolType symbol;

@end

NS_ASSUME_NONNULL_END
