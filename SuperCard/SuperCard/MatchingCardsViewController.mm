// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGCardMatchingGame.h"
#import "HistoryViewController.h"
#import "MatchingCardsViewController.h"
#import "CGPlayingCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchingCardsViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
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
    _game = [[CGCardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[self createDeck]];
  }
  
  return _game;
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardButtons) {
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    CGCard *card = [self.game cardAtIndex:cardButtonIndex];
    
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backGroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.matched;
    
    self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    [self logUpdateInTheUI];
  }
}

- (void)logUpdateInTheUI {
  NSMutableString *log = [[NSMutableString alloc] init];
  for (CGCard *card in self.game.pickedCards) {
    [log appendString:card.contents];
  }
  
  if ([self.game.pickedCards count] == self.game.matchMode) {
    if ([self.game.pickedCards firstObject].matched) {
      [log appendString:[[NSString alloc] initWithFormat:@" matched for %d points !", self.game.lastMatchScoring]];
    } else {
      [log appendString:[[NSString alloc] initWithFormat:@" mismatch penalty %d points !", self.game.lastMatchScoring]];
    }
  }
  
  self.logLable.text = log;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString:@"matchGameToHistory"]) {
    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
      HistoryViewController *history = (HistoryViewController *) segue.destinationViewController;
      //[history updateHistory:self.game.history.logMatchGame]; //cannot work!
      history.log = self.game.history.logMatchGame;
    }
  }
}

@end

NS_ASSUME_NONNULL_END
