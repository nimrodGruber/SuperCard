// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CGSetCard

static const int kMaxNumberAttributes = 4;
@synthesize color = _color;
@synthesize number = _number;
@synthesize shading = _shading;
@synthesize symbol = _symbol;

- (instancetype)init {
  if (self = [super init]) {
    _number = kMaxNumberAttributes;
    _symbol = undefinedSymbol;
    _shading = undefinedShade;
    _color = undefinedColor;
  }

  return self;
}

- (instancetype)initWithCardColor:(int)color
                  usingNumberType:(int)number
                   usingShadeType:(int)shade
                  usingSymbolType:(int)symbol {
  if (self = [super init]) {
    _color = (ColorType)color;
    _number = (int)number;
    _shading = (ShadeType)shade;
    _symbol = (SymbolType)symbol;
  }
  
  return self;
}

- (int)matchThreeCards:(NSMutableArray *)otherCards {
  BOOL cardsAreLegalSet = NO;
  CGSetCard *first = [otherCards firstObject];
  CGSetCard *second = [otherCards lastObject];
  NSMutableArray *cards = [[NSMutableArray alloc] init];
  
  [cards addObject:first];
  [cards addObject:second];
  [cards addObject:self];
  
  if ( (([self allNumbersAreEqual:cards]) || ([self allNumbersAreDifferent:cards])) &&
       (([self allSymbolAreEqual:cards])  || ([self allSymbolAreDifferent:cards]))  &&
       (([self allShadingAreEqual:cards]) || ([self allShadingAreDifferent:cards]))  &&
       (([self allColorsAreEqual:cards])  || ([self allColorsAreDifferent:cards]))  ) {
    cardsAreLegalSet = YES;
  }

  return cardsAreLegalSet;
}

-(BOOL)areAllIntsEqual:(int)first second:(int)second third:(int)third {
  if ((first == second) && (first == third)) {
    return YES;
  } else {
    return NO;
  }
}

-(BOOL)areAllIntsDifferent:(int)first second:(int)second third:(int)third {
  if ((first != second) && (first != third) && (second != third)) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)allNumbersAreEqual:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsEqual:first.number second:second.number third:third.number];
}

- (BOOL)allNumbersAreDifferent:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsDifferent:first.number second:second.number third:third.number];
}

- (BOOL)allSymbolAreEqual:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsEqual:first.symbol second:second.symbol third:third.symbol];
}

- (BOOL)allSymbolAreDifferent:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsDifferent:first.symbol second:second.symbol third:third.symbol];
}

- (BOOL)allShadingAreEqual:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsEqual:first.shading second:second.shading third:third.shading];
}

- (BOOL)allShadingAreDifferent:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsDifferent:first.shading second:second.shading third:third.shading];
}

- (BOOL)allColorsAreEqual:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsEqual:first.color second:second.color third:third.color];
}

- (BOOL)allColorsAreDifferent:(NSMutableArray *)cards {
  CGSetCard *first = [cards objectAtIndex:0];
  CGSetCard *second = [cards objectAtIndex:1];
  CGSetCard *third = [cards objectAtIndex:2];
  
  return [self areAllIntsDifferent:first.color second:second.color third:third.color];
}

- (ColorType)color {
  return ((_color < undefinedColor) && (_color >= 0)) ? _color : undefinedColor;
}

- (int)number {
  return ((_number < kMaxNumberAttributes) && (_number >= 1)) ? _number : kMaxNumberAttributes;
}

- (ShadeType)shading {
  return ((_shading < undefinedShade) && (_shading >= 0)) ? _shading : undefinedShade;
}

- (SymbolType)symbol {
  return ((_symbol < undefinedSymbol) && (_symbol >= 0)) ? _symbol : undefinedSymbol;
}

-(void)setColor:(ColorType)color {
  if ((color < undefinedColor) && (color >= 0)) {
    _color = color;
  }
}

-(void)setNumber:(int)number {
  if ((number < kMaxNumberAttributes) && (number >= 0)) {
    _number = number;
  }
}

-(void)setShading:(ShadeType)shading {
  if ((shading < undefinedShade) && (shading >= 0)) {
    _shading = shading;
  }
}

-(void)setSymbol:(SymbolType)symbol {
  if ((symbol < undefinedSymbol) && (symbol >= 0)) {
    _symbol = symbol;
  }
}

@end

NS_ASSUME_NONNULL_END
