// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetGame.h"

#import "CGSetCard.h"
#import "CGSetDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGSetGame()

@property (strong, nonatomic) CGSetDeck *deck;

@end

@implementation CGSetGame

static const int kMismatchPenalty = 2;
static const int kMatchBonus = 15;
static const int kCostToChoose = 1;
static const int kNumOfAdditionalCards = 3;

- (nullable instancetype)initWithCardCount:(NSUInteger)count {
  if (self = [super init]) {
    _cards = [[NSArray<CGCard *> alloc] init];
    _deck = [[CGSetDeck alloc] init];
    _addedCardsQuota = kNumOfAdditionalCards;
    self.matchMode = 3;
    for (NSUInteger i = 0; i < count; ++i) {
      CGCard *card = [self.deck drawRandomCard];
      if (card) {
        self.cards = [self.cards arrayByAddingObject:card];
      } else {
        self = nil;
        break;
      }
    }
  }
  
  return self;
}

- (CGCard *)addCardToGame {
  CGCard *newCard = nil;
  
  if (self.deck.cards.count) {
    newCard = [self.deck drawRandomCard];
    self.cards = [self.cards arrayByAddingObject:newCard];
  }
  
  return newCard;
}

- (CGCard *)cardAtIndex:(NSUInteger)index {
  return (index <= self.cards.count) ? self.cards[index] : nil;
}

- (CGDeck *)deck {
  return _deck;
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
      matchScore = [card matchThreeCards:self.pickedCards];
      
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
      
    } else if (self.pickedCards.firstObject.matched == YES) {
      [self replaceMatchedCardsWithNewCards:self.pickedCards];
    }
    NSArray *emptyPickedCards = [[NSArray alloc] init];
    self.pickedCards = emptyPickedCards;
  }
}

- (void)replaceMatchedCardsWithNewCards:(NSArray<CGCard *> *)matchedCards {
  for (int i = 0; i < self.matchMode; ++i) {
    NSUInteger index = [self.cards indexOfObject:matchedCards[i]];
    if (self.deck.cards.count) {
      [self replaceCardContent:(CGSetCard *) self.cards[index]
                 WithOtherCard:(CGSetCard *)[self.deck drawRandomCard]];
      self.cards[index].matched = NO;
      self.cards[index].chosen = NO;
    }
  }
}

- (void)replaceCardContent:(CGSetCard *)card WithOtherCard:(CGSetCard *)otherCard {
  card.color = otherCard.color;
  card.number = otherCard.number;
  card.shading = otherCard.shading;
  card.symbol = otherCard.symbol;
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
