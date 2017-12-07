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
#import "PlayingCardView.h"
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (strong, nonatomic) CGDeck *deck;
@property (strong, nonatomic) CGCardGame *game;

@end

@implementation ViewController

- (UIImage *)backGroundImageForCard:(CGCard __unused *)card { // Abstract.
  return nil;
}

- (CGDeck *)createDeck { // Abstract.
  return nil;
}

- (CGCardGame *)game { // Abstract.
  _game = nil;
  return _game;
}


- (CGDeck *)deck { //soon to be nil and abstract so that child can implement set/match game accordingly
  if (!_deck) {
    _deck = [[CGPlayingCardDeck alloc] init];
  }
  
  return _deck;
}

- (void)drawRandomPlayingCard:(PlayingCardView *)card {
  CGCard *tmp = [self.deck drawRandomCard];
  if ([tmp isKindOfClass:[CGPlayingCard class]]) {
    card.rank = ((CGPlayingCard *)tmp).rank;
    card.suit = ((CGPlayingCard *)tmp).suit;
  } //else if ([card isKindOfClass:[CGSetCard class]]) {
  //    add the set card option;
  //}
}

//- (void)drawRandomPlayingCard {
//  CGCard *card = [self.deck drawRandomCard];
//  if ([card isKindOfClass:[CGPlayingCard class]]) {
//    CGPlayingCard *playingCard = (CGPlayingCard *)card;
//    self.playingCardView.rank = playingCard.rank;
//    self.playingCardView.suit = playingCard.suit;
//  }
//}

- (IBAction)reDeal:(UIButton *)sender {
  self.game = nil;
  [self updateUI];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  NSUInteger chosenButtonIndex = [self.playingCardViews indexOfObject:sender.view]; //[self.cardButtons indexOfObject:sender];
  NSLog(@"the card index is %lu", (unsigned long)chosenButtonIndex);
  PlayingCardView *card = (PlayingCardView *)self.playingCardViews[chosenButtonIndex];
  if (!card.faceUp) {
    [self drawRandomPlayingCard:card];
  }
  card.faceUp = !card.faceUp;
}

- (NSString *)titleForCard:(CGCard *)card {
  return card.chosen ? card.contents : @"";
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
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
