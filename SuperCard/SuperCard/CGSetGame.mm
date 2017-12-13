// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetGame.h"
#import "CGSetCard.h"
#import "CGSetDeck.h"


NS_ASSUME_NONNULL_BEGIN

@interface CGSetGame()

//@property (strong, nonatomic) NSMutableArray<CGCard *> *cards;
@property (strong, nonatomic) CGSetDeck *deck;

@end

@implementation CGSetGame


static const int kMismatchPenalty = 2;
static const int kMatchBonus = 15;
static const int kCostToChoose = 1;
static const int kNumOfAdditionalCards = 3;


- (nullable instancetype)initWithCardCount:(NSUInteger)count {
  if (self = [super init]) {
    _cards = [[NSMutableArray<CGCard *> alloc] init];
    _deck = [[CGSetDeck alloc] init];
    _addedCardsQuota = kNumOfAdditionalCards;
    self.matchMode = 3;
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
  
  return self;
}


- (CGCard *)addCardToGame {
  CGCard *newCard = nil;
  
  if (self.deck.cards.count) {
    newCard = [self.deck drawRandomCard];
    [self.cards addObject:newCard];
  }
  
  return newCard;
}


- (CGCard *)cardAtIndex:(NSUInteger)index {
  return (index <= self.cards.count) ? self.cards[index] : nil;
}


- (CGDeck *)getDeck {
  return self.deck;
}


- (void)chooseCardAtIndex:(NSUInteger)index {
  CGCard *card = [self cardAtIndex:index];
  
  [self flipAndClearPickedCardsIfNeeded:card];
  
  if (card.matched) {
    return;
  } else if (card.chosen) {
    card.chosen = NO;
    [self.pickedCards removeObject:card];
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
    
    [self.pickedCards addObject:card];
    
    self.score -= kCostToChoose;
  }
}


- (void)flipAndClearPickedCardsIfNeeded:(CGCard *)card {
  if (self.pickedCards.count == self.matchMode) {
    if ([self.pickedCards firstObject].matched == NO) {
      [self markCardsChosenSign:card cards:self.pickedCards sign:NO];
    } else if ([self.pickedCards firstObject].matched == YES) {
      [self replaceMatchedCardsWithNewCards:self.pickedCards];
    }
    
    [self.pickedCards removeAllObjects];
  }
}


- (void)replaceMatchedCardsWithNewCards:(NSMutableArray <CGCard *>*)matchedCards {
  for (int i = 0; i < self.matchMode; ++i) {
    NSUInteger index = [self.cards indexOfObject:matchedCards[i]];
    if (self.deck.cards.count) {
      self.cards[index] = [self.deck drawRandomCard];
      self.cards[index].matched = NO;
      self.cards[index].chosen = NO;
    }
  }
  NSLog(@"deck cards count is: %lu", (unsigned long)self.deck.cards.count);
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
  //use switch case
  if (setCard.number == 1) {
    [textCard appendString:@"1"];
  } else if (setCard.number == 2) {
    [textCard appendString:@"2"];
  } else { // (setCard.number == 3)
    [textCard appendString:@"3"];
  }
  
  if (setCard.symbol == diamond) {
    [textCard appendString:@"▲"];
  } else if (setCard.symbol == oval) {
    [textCard appendString:@"●"];
  } else { // (setCard.symbol == squiggle)
    [textCard appendString:@"■"];
  }
  
  return textCard;
}


@end

NS_ASSUME_NONNULL_END
