// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetCard.h"
#import "CGSetDeck.h"
#import "CGSetGame.h"
#import "SetCardsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardsViewController ()

@property (strong, nonatomic) CGSetGame *game;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSArray *setCardViews;

@end

@implementation SetCardsViewController

- (CGCardGame *)game {
  if (!_game) {
    _game = [[CGSetGame alloc] initWithCardCount:self.setCardViews.count];
  }

  return _game;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  NSUInteger chosenButtonIndex = [self.setCardViews indexOfObject:sender.view];
  SetCardView *cardView = (SetCardView *)self.setCardViews[chosenButtonIndex];
  if ([cardView cardIsNotInitialized]) {
    [self initializeCardDisplay:cardView atIndex:chosenButtonIndex];
  }
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  for (SetCardView *cardView in self.setCardViews) {
    NSUInteger cardViewIndex = [self.setCardViews indexOfObject:cardView];
    CGCard *card = [self.game cardAtIndex:cardViewIndex];
    cardView.faceUp = YES;
    card.chosen ? (cardView.alpha = 0.5) : (cardView.alpha = 1);
    card.matched ? (cardView.hidden = YES) : (cardView.hidden = NO);
    [cardView updateCardDisplay:((CGSetCard *)card).color theNumber:((CGSetCard *)card).number
                       theShade:((CGSetCard *)card).shading theSymbol:((CGSetCard *)card).symbol];
  }
  
  self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)initializeCardDisplay:(SetCardView *)card atIndex:(NSUInteger)index {
  CGCard *tmp = [self.game getCardAtIndex:index];
  card.color = ((SetCardView *)tmp).color;
  card.number = ((SetCardView *)tmp).number;
  card.shading = ((SetCardView *)tmp).shading;
  card.symbol = ((SetCardView *)tmp).symbol;
}

@end

NS_ASSUME_NONNULL_END
