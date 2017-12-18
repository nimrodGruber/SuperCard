// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetCard.h"
#import "CGSetDeck.h"
#import "CGSetGame.h"
#import "SetCardsViewController.h"
#import "Grid.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardsViewController ()

@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) CGSetGame *game;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSMutableArray *setCardViews;
@property (weak, nonatomic) IBOutlet UIView *viewBoundsForCards;
@property (weak, nonatomic) IBOutlet UIButton *addCardsBtn;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panProperty;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeProperty;

@end

@implementation SetCardsViewController


- (IBAction)tapToReleaseGatheredCards:(UITapGestureRecognizer *)sender {
//  CGRect deckFrame = CGRectMake(0, 0, ((UIView *)self.setCardViews[1]).frame.size.width,
//                                ((UIView *)self.setCardViews[1]).frame.size.height);
  
//  if ( deckFrame.origin.x != ((UIView *)self.setCardViews[1]).frame.origin.x )  {
    [UIView animateWithDuration:2.0
      animations:^{
       [self updateCardDisplay];
      }
      completion:^(BOOL finished) {
      }];
//  }
}


- (IBAction)pinchGestureCollectCards:(UIPinchGestureRecognizer *)sender {
  CGRect deckFrame = CGRectMake(0, 0, ((UIView *)self.setCardViews[0]).frame.size.width,
      ((UIView *)self.setCardViews[0]).frame.size.height);
  
  [UIView animateWithDuration:2.0
     animations:^{
       for (NSUInteger i = 0; i < self.setCardViews.count; ++i) {
         ((UIView *)self.setCardViews[i]).frame = deckFrame;
       }
     }
     completion:^(BOOL finished) {
     }];
}


- (IBAction)panGestureMoveDeck:(UIPanGestureRecognizer *)sender {
  [self.panProperty requireGestureRecognizerToFail:self.swipeProperty];
  
  CGPoint gesturePoint = [sender locationInView:self.view];

  if ((sender.state == UIGestureRecognizerStateBegan) ||
     (sender.state == UIGestureRecognizerStateChanged) ||
     (sender.state == UIGestureRecognizerStateEnded)) {
    [self moveGatheredCardsToPoint:gesturePoint];
  }
}


- (void)moveGatheredCardsToPoint:(CGPoint)anchorPoint {
  CGRect deckFrame = CGRectMake(anchorPoint.x, anchorPoint.y,
      ((UIView *)self.setCardViews[0]).frame.size.width,
      ((UIView *)self.setCardViews[0]).frame.size.height);
  
  [UIView animateWithDuration:0.5
    animations:^{
     for (NSUInteger i = 0; i < self.setCardViews.count; ++i) {
       ((UIView *)self.setCardViews[i]).frame = deckFrame;
     }
    }
    completion:^(BOOL finished) {
    }];
}



- (IBAction)addCards:(UIButton *)sender {
  CGCard *newCard = nil;
  for (int i = 0; i < self.game.addedCardsQuota; ++i) {
    newCard = [self.game addCardToGame];
    if (!newCard) {
      break;
    } else {
      [self addNewCardViewItemAtIndex:self.game.cards.count-1];
    }
  }

  [self.addCardsBtn setImage:[UIImage imageNamed:(newCard) ? @"dealMoreCards" : @"noCardsLeft"]
                    forState:UIControlStateNormal];
  
  [UIView animateWithDuration:1.0
     animations:^{
       [self updateCardDisplay];
     }
     completion:^(BOOL finished) {
         [self updateUI];
     }];
}


- (void)initializeGame {
  self.game = [[CGSetGame alloc] initWithCardCount:12];
}

- (void)initializeCardsView {
  
}

- (void)addNewCardViewItemAtIndex:(NSUInteger)index {
  SetCardView *newCardView = [[SetCardView alloc] init];
  [self initializeCardDisplay:newCardView atIndex:index];
  [self.setCardViews addObject: newCardView];
  [self.viewBoundsForCards addSubview:newCardView];
  [newCardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(swipe:)]];
  [newCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(pinch:)]];
  int x = (arc4random() % (int)(self.viewBoundsForCards.bounds.size.width * 2));
  int y = (arc4random() % (int)(self.viewBoundsForCards.bounds.size.height * 2));
  int random = arc4random() % 10;
  if (random % 2 == 0) {
    newCardView.center = CGPointMake(-x, y);
  } else {
    newCardView.center = CGPointMake(x, -y);
  }
}


- (void)updateCardDisplay {
  NSUInteger viewCardsHandeled = 0;
  NSUInteger existingViewCards = self.setCardViews.count;
  
  [self setupGridData];
  
  for (NSUInteger r = 0; r < self.grid.rowCount; ++r) {
    for (NSUInteger c = 0; c < self.grid.columnCount && viewCardsHandeled < existingViewCards;
         ++c, ++viewCardsHandeled) {
      ((UIView *)self.setCardViews[(r*self.grid.columnCount)+c]).frame =
          [self.grid frameOfCellAtRow:r inColumn:c];
    }
  }
}


- (void)setupGridData {
//  if (!self.grid) {
    self.grid = [[Grid alloc] init];
    self.grid.size = self.viewBoundsForCards.bounds.size;
  
    CGFloat goldenRatio = {0.618};
    self.grid.cellAspectRatio = goldenRatio;
//  }

  self.grid.minimumNumberOfCells = self.game.cards.count;
  assert ([self.grid inputsAreValid]);
}


- (CGCardGame *)game {
  if (!_game) {
    _game = [[CGSetGame alloc] initWithCardCount:self.setCardViews.count];
  }

  return _game;
}


- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  NSUInteger chosenButtonIndex = [self.setCardViews indexOfObject:sender.view];
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
  CGCard *tmp = self.game.cards[index];
  card.color = ((SetCardView *)tmp).color;
  card.number = ((SetCardView *)tmp).number;
  card.shading = ((SetCardView *)tmp).shading;
  card.symbol = ((SetCardView *)tmp).symbol;
}

- (void)viewDidLayoutSubviews {
//  self.grid = nil;
  [self updateCardDisplay];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self initializeGame];
  [self.view addSubview:self.viewBoundsForCards];
  for (SetCardView *newCardView in self.setCardViews) {
    [newCardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc]
        initWithTarget:self action:@selector(swipe:)]];
    [newCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
        initWithTarget:self action:@selector(pinch:)]];
  }
  [self updateUI];
}


- (void)prepareForNextGame {
  self.reDealBtn.enabled = NO;
  self.reDealBtn.hidden = YES;
  [self replaceOldCardsWithNewOnes];
  [self.addCardsBtn setImage:[UIImage imageNamed:@"dealMoreCards"] forState:UIControlStateNormal];
}

- (void)replaceOldCardsWithNewOnes {
  self.addCardsBtn.enabled = NO;
  [UIView animateWithDuration:3.0
     animations:^{
       [self moveViewCardsFromScreenWithAlphaValue:0.0];
     }
     completion:^(BOOL finished) {
       [self.setCardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       [self.setCardViews removeAllObjects];
       [self initializeGame];
       for (int i = 0; i < 12; ++i) {
         [self addNewCardViewItemAtIndex:i];
       }
       [self moveViewCardsFromScreenWithAlphaValue:1.0];
       [UIView animateWithDuration:1.0
          animations:^{
            [self updateCardDisplay];
          }
          completion:^(BOOL finished) {
            [self updateUI];
            self.addCardsBtn.enabled = YES;
            self.reDealBtn.enabled = YES;
            self.reDealBtn.hidden = NO;
          }];
     }];
}

- (void)newGameAnimation {
  [UIView animateWithDuration:3.0
    animations:^{
      [self moveViewCardsFromScreenWithAlphaValue:0.0];
    }
    completion:^(BOOL finished) {
      [self.setCardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
      [self.setCardViews removeAllObjects];
      
      for (int i = 0; i < 12; ++i) {
        [self addNewCardViewItemAtIndex:i];
      }
      
      [self moveViewCardsFromScreenWithAlphaValue:1.0];
      
      [UIView animateWithDuration:1.0
        animations:^{
          [self updateCardDisplay];
        }
        completion:^(BOOL finished) {
          [self updateUI];
        }];
    }];
}

- (void)moveViewCardsFromScreenWithAlphaValue:(float)alph {
  int i = 0;
  for (SetCardView *newCardView in self.setCardViews) {
    int x = (arc4random() % (int)(self.viewBoundsForCards.bounds.size.width * 2));
    int y = (arc4random() % (int)(self.viewBoundsForCards.bounds.size.height * 2));
    if (i++ % 2) {
      newCardView.center = CGPointMake(-x, y);
    } else {
      newCardView.center = CGPointMake(x, -y);
    }
    newCardView.alpha = alph;
  }
}

@end

NS_ASSUME_NONNULL_END
