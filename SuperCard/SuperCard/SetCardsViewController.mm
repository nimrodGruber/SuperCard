// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetCard.h"
#import "CGSetDeck.h"
#import "CGSetGame.h"
#import "SetCardsViewController.h"
#import "Grid.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardsViewController ()

@property (strong, nonatomic) CGSetGame *game;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSMutableArray *setCardViews;
@property (weak, nonatomic) IBOutlet UIView *viewBoundsForCards;
@property (weak, nonatomic) IBOutlet UIButton *addCardsBtn;


@end

@implementation SetCardsViewController


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
  
  [self updateCardDisplay];
  [self updateUI];
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
  if (!self.grid) {
    self.grid = [[Grid alloc] init];
    self.grid.size = self.viewBoundsForCards.bounds.size;
    
    CGFloat goldenRatio = {0.618};
    self.grid.cellAspectRatio = goldenRatio;
  }
  
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


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self.view addSubview:self.viewBoundsForCards];
  [self prepareForNextGame];
  [self updateUI];
}


- (void)prepareForNextGame {
  for (SetCardView *oldCard in self.setCardViews) {
    [oldCard removeFromSuperview];
  }
  [self.setCardViews removeAllObjects];
  
  self.game = [[CGSetGame alloc] initWithCardCount:12];
  
  for (int i = 0; i < 12; ++i) {
    [self addNewCardViewItemAtIndex:i];
  }
  
  [self updateCardDisplay];
  
  [self.addCardsBtn setImage:[UIImage imageNamed:@"dealMoreCards"] forState:UIControlStateNormal];
}


@end

NS_ASSUME_NONNULL_END
