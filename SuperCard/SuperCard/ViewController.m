//
//  ViewController.m
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "CGCardGame.h"

#import "CGPlayingCardDeck.h"
#import "CGPlayingCard.h"

#import "CGSetDeck.h"
#import "CGSetCard.h"

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSArray *setCardViews;

@property (strong, nonatomic) CGCardGame *game;

@end

@implementation ViewController

- (CGCardGame *)game { // Abstract.
  _game = nil;
  return _game;
}

- (IBAction)reDeal:(UIButton *)sender {
  self.game = nil;
  [self updateUI];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender { // Abstract.
}

- (void)updateUI { // Abstract.
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  for (PlayingCardView *view in self.playingCardViews) {
    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)]];
    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
  }
  
  for (SetCardView *view in self.setCardViews) {
    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)]];
    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
  }
}

@end
