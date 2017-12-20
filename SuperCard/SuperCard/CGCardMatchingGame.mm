// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCardMatchingGame.h"

#import "CGPlayingCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGCardMatchingGame()

@property (strong, nonatomic) NSMutableArray<CGCard *> *cards;
@property (strong, nonatomic) CGPlayingCardDeck *deck;

@end

@implementation CGCardMatchingGame

static const int kMismatchPenalty = 2;
static const int kMatchBonus = 4;
static const int kCostToChoose = 1;

- (nullable instancetype)initWithCardCount:(NSUInteger)count {
  if (self = [super init]) {
    _cards = [[NSMutableArray<CGCard *> alloc] init];
    _deck = [[CGPlayingCardDeck alloc] init];
    self.matchMode = 2;
    if (count > self.deck.cards.count) { // Early bail.
      return nil;
    } else {
      for (NSUInteger i = 0; i < count; ++i) {
        CGCard *card = [self.deck drawRandomCard];
        if (card) {
          [self.cards addObject:card];
        } else {
          self = nil;
          break;
        }
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
    NSMutableArray *pickedCardsCopy = [self.pickedCards mutableCopy];
    [pickedCardsCopy removeObject:card];
    self.pickedCards = pickedCardsCopy;
  } else {
    card.chosen = YES;
  
    if (self.pickedCards.count == self.matchMode - 1) {
      int matchScore = 0;
      
      if (self.matchMode == 2) {
        matchScore = [card matchTwoCards:self.pickedCards];
      } else if (self.matchMode == 3) {
        matchScore = [card matchThreeCards:self.pickedCards];
      }
      
      if (matchScore) {
        self.score += matchScore * kMatchBonus;
        self.lastMatchScoring = matchScore * kMatchBonus;
        [self markCardsMatchedSign:card cards:self.pickedCards sign:YES];
      } else {
        self.score -= kMismatchPenalty;
        self.lastMatchScoring = kMismatchPenalty;
      }
    }
  
    self.pickedCards = [self.pickedCards arrayByAddingObject:card];
  
    self.score -= kCostToChoose;
  }
}

- (void)flipAndClearPickedCardsIfNeeded:(CGCard *)card {
  if (self.pickedCards.count == self.matchMode) {
    if (self.pickedCards.firstObject.matched == NO) {
      NSArray *cardsArrayToMark = [[NSArray alloc] initWithArray:self.pickedCards];
      cardsArrayToMark = [cardsArrayToMark arrayByAddingObject:card];
      [self markCards:(NSArray<CGCard *> *)cardsArrayToMark accordingToSign:(BOOL)NO];
    }
    NSArray *emptyPickedCards = [[NSArray alloc] init];
    self.pickedCards = emptyPickedCards;
  }
}

- (CGCard *) getCardAtIndex:(NSUInteger) index {
  return self.cards[index];
}

- (void)markCards:(NSArray<CGCard *> *)cards accordingToSign:(BOOL)sign {
  for (CGCard *picked in cards) {
    picked.chosen = sign;
  }
}

- (void)markCardsMatchedSign:(CGCard *)card cards:(NSArray<CGCard *> *)cards sign:(BOOL)sign {
  for (CGCard *picked in cards) {
    picked.matched = sign;
  }
  
  card.matched = sign;
}

@end

NS_ASSUME_NONNULL_END
