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

@property (strong, nonatomic) CGCardGame *game;

@end

@implementation ViewController

- (void)initializeGame { // Abstract.
}

- (CGCardGame *)game { // Abstract.
  _game = nil;
  return _game;
}


- (IBAction)reDeal:(UIButton *)sender {
  self.game = nil;
//  [self initializeGame];
  [self prepareForNextGame];
  [self updateUI];
}


- (IBAction)swipe:(UISwipeGestureRecognizer *)sender { // Abstract.
}


- (void)updateUI { // Abstract.
}


- (void)prepareForNextGame { // Abstract.
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


@end
