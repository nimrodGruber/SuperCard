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

- (CGDeck *)createDeck {
  return [[CGPlayingCardDeck alloc] init]; 
}

- (NSString *)titleForCard:(CGCard *)card {
  return card.chosen ? card.contents : @"";
}

- (UIImage *)backGroundImageForCard:(CGCard *)card {
  return [UIImage imageNamed:card.chosen ? @"cardFront" : @"cardBack"];
}

- (CGCardMatchingGame *)game {
  if (!_game) {
    _game = [[CGCardMatchingGame alloc] initWithCardCount:self.playingCardViews.count];
  }
  
  return _game;
}

- (void)updateUI {
//  for (PlayingCardView *cardView in self.playingCardViews) {
//    NSUInteger cardViewIndex = [self.playingCardViews indexOfObject:cardView];
//    CGCard *card = [self.game cardAtIndex:cardViewIndex];
//    if (card.matched) {
//      cardView.faceUp = YES;
//    }
////    [cardView setTitle:[self titleForCard:card] forState:UIControlStateNormal];
////    [cardView setBackgroundImage:[self backGroundImageForCard:card] forState:UIControlStateNormal];
////    cardView.enabled = !card.matched; //disable swip, change alpha for visuality
//
//    self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
//  }
 
  //from the set function updateUI
//  for (UIButton *cardButton in self.cardButtons) {
//    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//    CGCard *card = [self.game cardAtIndex:cardButtonIndex];
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
//
//    [self extractCardAttributedTitle:card title:title];
//    [cardButton setAttributedTitle:title forState:UIControlStateNormal];
//    [cardButton setBackgroundImage:[self backGroundImageForCard:card]forState:UIControlStateNormal];
//    cardButton.enabled = !card.matched;
  
  for (PlayingCardView *cardView in self.playingCardViews) {
    NSUInteger cardViewIndex = [self.playingCardViews indexOfObject:cardView];
    CGCard *card = [self.game cardAtIndex:cardViewIndex];
    card.chosen ? (cardView.faceUp = YES) : (cardView.faceUp = NO);
    [cardView updateCardDisplay:((CGPlayingCard *)card).suit rank:((CGPlayingCard *)card).rank];
    //    [cardView setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    //    [cardView setBackgroundImage:[self backGroundImageForCard:card] forState:UIControlStateNormal];
    //    cardView.enabled = !card.matched; //disable swip, change alpha for visuality
    
    self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  }
}

@end

NS_ASSUME_NONNULL_END
