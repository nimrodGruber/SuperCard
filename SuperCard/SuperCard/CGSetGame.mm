// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetGame.h"
#import "CGSetCard.h"


NS_ASSUME_NONNULL_BEGIN

@interface CGSetGame()

@property (strong, nonatomic) NSMutableArray<CGCard *> *cards;

@end

@implementation CGSetGame

static const int kMismatchPenalty = 2;
static const int kMatchBonus = 15;
static const int kCostToChoose = 1;

- (nullable instancetype)initWithCardCount:(NSUInteger)count usingDeck:(CGDeck *)deck {
  if (self = [super init]) {
    _cards = [[NSMutableArray<CGCard *> alloc] init];
    _history = [[HistoryBoss alloc] init];
    self.matchMode = 3;
    for (NSUInteger i = 0; i < count; ++i) {
      CGCard *card = [deck drawRandomCard];
      if (card) {
        [self.cards addObject:card];
      } else {
        self = nil;
        break;
      }
    }
  }
  
  return self;
}

- (CGCard *)cardAtIndex:(NSUInteger)index {
  return (index <= self.cards.count) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  CGCard *card = [self cardAtIndex:index];
  
  [self flipAndClearPickedCardsIfNeeded:card];
  
  if (card.matched) {
    return;
  } else if (card.chosen) {
    card.chosen = NO;
    [self.pickedCards removeObject:card];
    [self.history.logSetGame removeLastObject];
  } else {
    card.chosen = YES;
    [self.history.logSetGame addObject:[self cardToText:card]];
    
    if (self.pickedCards.count == self.matchMode - 1) {
      int matchScore = 0;
      matchScore = [card matchThreeCards:self.pickedCards];
      
      if (matchScore) {
        self.score += matchScore * kMatchBonus;
        self.lastMatchScoring = matchScore * kMatchBonus;
        [self markCardsMatchedSign:card cards:self.pickedCards sign:YES];
        [self addHistoryOfMatch];
      } else {
        self.score -= kMismatchPenalty;
        self.lastMatchScoring = kMismatchPenalty;
        [self addHistoryOfMismatch];
      }
    }
    
    [self.pickedCards addObject:card];
    
    self.score -= kCostToChoose;
  }
}

- (void)flipAndClearPickedCardsIfNeeded:(CGCard *)card {
  if (self.pickedCards.count == self.matchMode) {
    if ([self.pickedCards firstObject].matched == NO) {
      [self markCardsChosenSign:card cards:self.pickedCards sign:NO];
    }
    [self.pickedCards removeAllObjects];
  }
}

- (void)markCardsChosenSign:(CGCard *)card cards:(NSMutableArray *)cards sign:(BOOL)sign {
  for (CGCard *picked in cards) {
    picked.chosen = sign;
  }
  
  card.chosen = sign;
}

- (void)markCardsMatchedSign:(CGCard *)card cards:(NSMutableArray *)cards sign:(BOOL)sign {
  for (CGCard *picked in cards) {
    picked.matched = sign;
  }
  
  card.matched = sign;
}

- (NSString *)cardToText:(CGCard*)card {
  CGSetCard *setCard = (CGSetCard *)card;
  NSMutableString *textCard = [[NSMutableString alloc] init];
  
  if (setCard.number == 1) {
    [textCard appendString:@"1"];
  } else if (setCard.number == 2) {
    [textCard appendString:@"2"];
  } else { // (setCard.number == 3)
    [textCard appendString:@"3"];
  }
  
  if (setCard.symbol == triangle) {
    [textCard appendString:@"▲"];
  } else if (setCard.symbol == circle) {
    [textCard appendString:@"●"];
  } else { // (setCard.symbol == square)
    [textCard appendString:@"■"];
  }
  
  return textCard;
}

- (void)addHistoryOfMatch {
  NSString *result = [[NSString alloc] initWithFormat:@" matched for %d points !\n", self.lastMatchScoring];;
  [self.history.logSetGame addObject:result];
}

- (void)addHistoryOfMismatch {
  NSString *result = [[NSString alloc] initWithFormat:@" mismatch penalty %d points !\n", self.lastMatchScoring];
  [self.history.logSetGame addObject:result];
}

@end

NS_ASSUME_NONNULL_END
