// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "MatchingCardsViewController.h"

#import "CGCardMatchingGame.h"
#import "CGPlayingCard.h"
#import "CGPlayingCardDeck.h"

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

- (void)prepareForNextGame {
  self.game = [[CGCardMatchingGame alloc] initWithCardCount:self.playingCardViews.count];
  [self updateUI];
}

- (void)updateUI {
  for (PlayingCardView *cardView in self.playingCardViews) {
    NSUInteger cardViewIndex = [self.playingCardViews indexOfObject:cardView];
    CGPlayingCard *card = (CGPlayingCard *)[self.game cardAtIndex:cardViewIndex];
    [self flipCardViewIfNeeded:card cardFrame:cardView];
    card.matched ? (cardView.alpha = 0.5) : (cardView.alpha = 1);
    [cardView updateCardDisplay:card.suit rank:card.rank];
  }
  self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)flipCardViewIfNeeded:(CGCard *)card cardFrame:(PlayingCardView*)cardView {
  if (card.chosen && cardView.faceUp == NO) {
    [self flipAnimation:cardView];
    cardView.faceUp = YES;
  } else if (card.chosen == NO && cardView.faceUp == YES) {
    [self flipAnimation:cardView];
    cardView.faceUp = NO;
  }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  NSUInteger chosenButtonIndex = [self.playingCardViews indexOfObject:sender.view];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)flipAnimation:(PlayingCardView *)card {
  [UIView transitionWithView:card
    duration:0.65
    options:UIViewAnimationOptionTransitionFlipFromLeft
    animations:^{}
    completion:^(BOOL finished) {}];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  for (PlayingCardView *view in self.playingCardViews) {
    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)]];
    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
  }
  
   [self updateUI];
}

@end

NS_ASSUME_NONNULL_END
