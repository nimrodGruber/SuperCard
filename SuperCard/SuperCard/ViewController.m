//
//  ViewController.m
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation ViewController
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
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
