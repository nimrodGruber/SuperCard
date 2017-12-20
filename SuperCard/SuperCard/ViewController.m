//
//  ViewController.m
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "ViewController.h"

#import "CGCardGame.h"
#import "CGPlayingCard.h"
#import "CGPlayingCardDeck.h"
#import "CGSetCard.h"
#import "CGSetDeck.h"


@interface ViewController ()

@property (strong, nonatomic) CGCardGame *game;

@end

@implementation ViewController

- (CGCardGame *)game { // Abstract.
  _game = nil;
  return _game;
}

- (IBAction)reDeal:(UIButton *)sender {
  [self prepareForNextGame];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender { // Abstract.
}

- (void)prepareForNextGame { // Abstract.
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

@end
