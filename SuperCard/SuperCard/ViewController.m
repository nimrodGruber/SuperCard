//
//  ViewController.m
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "CGPlayingCardDeck.h"
#import "CGPlayingCard.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) CGDeck *deck;

@end

@implementation ViewController

- (CGDeck *)deck {
  if (!_deck) {
    _deck = [[CGPlayingCardDeck alloc] init];
  }
  
  return _deck;
}

- (void)drawRandomPlayingCard {
  CGCard *card = [self.deck drawRandomCard];
  if ([card isKindOfClass:[CGPlayingCard class]]) {
    CGPlayingCard *playingCard = (CGPlayingCard *)card;
    self.playingCardView.rank = playingCard.rank;
    self.playingCardView.suit = playingCard.suit;
  }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  if (!self.playingCardView.faceUp) {
    [self drawRandomPlayingCard];
  }
  self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.playingCardView.suit = @"♥️";
  self.playingCardView.rank = 13;
  [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView
                                                                                       action:@selector(pinch:)]];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
