// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCardMatchingGame.h"
#import "MatchingCardsViewController.h"
#import "CGPlayingCardDeck.h"
#import "CGPlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchingCardsViewController ()

@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (strong, nonatomic) CGCardMatchingGame *game;

@end

@implementation MatchingCardsViewController

- (CGCardMatchingGame *)game {
  if (!_game) {
    _game = [[CGCardMatchingGame alloc] initWithCardCount:self.playingCardViews.count];
  }
  
  return _game;
}

- (void)updateUI {
  for (PlayingCardView *cardView in self.playingCardViews) {
    NSUInteger cardViewIndex = [self.playingCardViews indexOfObject:cardView];
    CGCard *card = [self.game cardAtIndex:cardViewIndex];
    card.chosen ? (cardView.faceUp = YES) : (cardView.faceUp = NO);
    card.matched ? (cardView.alpha = 0.5) : (cardView.alpha = 1);
    [cardView updateCardDisplay:((CGPlayingCard *)card).suit rank:((CGPlayingCard *)card).rank];
  }
  self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    NSUInteger chosenButtonIndex = [self.playingCardViews indexOfObject:sender.view];
    PlayingCardView *cardView = (PlayingCardView *)self.playingCardViews[chosenButtonIndex];
    if ([cardView cardIsNotInitialized]) {
      [self initializeCardDisplay:cardView atIndex:chosenButtonIndex];
    }
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)initializeCardDisplay:(PlayingCardView *)card atIndex:(NSUInteger)index {
  CGCard *tmp = [self.game getCardAtIndex:index];
  if ([tmp isKindOfClass:[CGPlayingCard class]]) {
    card.rank = ((CGPlayingCard *)tmp).rank;
    card.suit = ((CGPlayingCard *)tmp).suit;
  }
}

@end

NS_ASSUME_NONNULL_END
