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
      SetCardView *newCardView = [[SetCardView alloc] init];
      [self initializeCardDisplay:newCardView atIndex:self.game.cards.count-1];
      [self.setCardViews addObject: newCardView];
      [self.view addSubview:newCardView];
    }
  }

  [self.addCardsBtn setImage:[UIImage imageNamed:(newCard) ? @"dealMoreCards" : @"noCardsLeft"]
                    forState:UIControlStateNormal];
  
  [self updateCardDisplay];
  [self updateUI];
}


- (void)updateCardDisplay {
  [self setupGridData];
  NSUInteger i = 0;
  for (NSUInteger r = 0; r < self.grid.rowCount; ++r) {
    for (NSUInteger c = 0; c < self.grid.columnCount && i < self.setCardViews.count; ++c, ++i) {
      ((UIView *)self.setCardViews[(r*self.grid.columnCount)+c]).frame = [self.grid frameOfCellAtRow:r inColumn:c];
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


- (void)removeOldViewCards {
//  for (SetCardView *cardView in self.setCardViews) {
//    [cardView removeFromSuperview];
//  }
//
////  [self.setCardViews removeAllObjects];
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
  
  for (SetCardView *view in self.setCardViews) {
    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)]];
    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
  }
  
  [self updateUI];
}

- (void)loadView {
  /// make a empty view to self.view
  /// after calling [super loadView], self.view won't be nil anymore.
  [super loadView];
  
//  paintView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 430)];
//  [paintView setBackgroundColor:[UIColor yellowColor]];
//  [self.view addSubview:paintView];
//  [paintView release];
};

@end

NS_ASSUME_NONNULL_END
