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
    [self flipCardViewIfNeeded:card cardFrame:cardView];
    card.matched ? (cardView.alpha = 0.5) : (cardView.alpha = 1);
    [cardView updateCardDisplay:((CGPlayingCard *)card).suit rank:((CGPlayingCard *)card).rank];
  }
  self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}


- (void)flipCardViewIfNeeded:(CGCard *)card cardFrame:(PlayingCardView*)cardView {
  if (card.chosen) {
    if (cardView.faceUp == NO) {
      [self flipAnimation:cardView];
      cardView.faceUp = YES;
    }
  } else {
    if (cardView.faceUp == YES) {
      [self flipAnimation:cardView];
      cardView.faceUp = NO;
    }
  }
}


- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  NSUInteger chosenButtonIndex = [self.playingCardViews indexOfObject:sender.view];
  PlayingCardView *cardView = (PlayingCardView *)self.playingCardViews[chosenButtonIndex];
  if ([cardView cardIsNotInitialized]) {
    [self initializeCardDisplay:cardView atIndex:chosenButtonIndex];
  }
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self flipAnimation:cardView];
  [self updateUI];
}


- (void)flipAnimation:(PlayingCardView *)card {
  [UIView transitionWithView:card duration:0.65f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{
//                       frontImageView.hidden = NO;
//                       backImageView.hidden = YES;
                     }
                  completion:^(BOOL finished) {
                     }];
}


- (void)initializeCardDisplay:(PlayingCardView *)card atIndex:(NSUInteger)index {
  CGCard *tmp = [self.game getCardAtIndex:index];
  if ([tmp isKindOfClass:[CGPlayingCard class]]) {
    card.rank = ((CGPlayingCard *)tmp).rank;
    card.suit = ((CGPlayingCard *)tmp).suit;
  }
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  for (PlayingCardView *view in self.playingCardViews) {
    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)]];
    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
  }
  
   [self updateUI];
}


@end

NS_ASSUME_NONNULL_END
