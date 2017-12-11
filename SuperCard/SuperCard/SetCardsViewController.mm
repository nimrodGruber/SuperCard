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

- (void)updateUI {
  for (SetCardView *cardView in self.setCardViews) {
    NSUInteger cardViewIndex = [self.setCardViews indexOfObject:cardView];
    CGCard *card = [self.game cardAtIndex:cardViewIndex];
    cardView.faceUp = YES;
    card.matched ? (cardView.alpha = 0.5) : (cardView.alpha = 1);
    [cardView updateCardDisplay:((CGSetCard *)card).color theNumber:((CGSetCard *)card).number
                       theShade:((CGSetCard *)card).shading theSymbol:((CGSetCard *)card).symbol];
  }
  
  self.scoreLable.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
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

- (void)initializeCardDisplay:(SetCardView *)card atIndex:(NSUInteger)index {
  CGCard *tmp = [self.game getCardAtIndex:index];
  card.color = ((SetCardView *)tmp).color;
  card.number = ((SetCardView *)tmp).number;
  card.shading = ((SetCardView *)tmp).shading;
  card.symbol = ((SetCardView *)tmp).symbol;
}

- (NSString *)cardToText: (CGCard*)card {
  CGSetCard *setCard = (CGSetCard *)card;
  NSMutableString *textCard = [[NSMutableString alloc] init];
  
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

- (ShadeType)findCardShade:(CGCard *)card {
  CGSetCard *setCard = (CGSetCard *) card;
  if (setCard.shading == solid) {
    return solid;
  } else if (setCard.shading == unfilled) {
    return unfilled;
  } else { // (setCard.shading == striped)
    return striped;
  }
}

- (UIColor *)findCardColor:(CGCard *)card {
  CGSetCard *setCard = (CGSetCard *) card;

  if (setCard.color == red) {
    return [UIColor redColor];
  } else if (setCard.color == green) {
    return [UIColor greenColor];
  } else { //(setCard.color == purple)
    return [UIColor purpleColor];
  }
}

- (int)findCardNumber:(CGCard *)card {
   CGSetCard *setCard = (CGSetCard *)card;
   return setCard.number;
 }

- (NSString *)findCardSymbol:(CGCard *)card {
   CGSetCard *setCard = (CGSetCard *)card;

   if (setCard.symbol == diamond) {
     return @"▲";
   } else if (setCard.symbol == oval) {
     return @"●";
   } else { //setCard.symbol == squiggle
     return @"■";
   }
 }

@end

NS_ASSUME_NONNULL_END
