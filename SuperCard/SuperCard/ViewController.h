//
//  ViewController.h
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "CGDeck.h"
#import "PlayingCardView.h"
#import "SetCardView.h"

@interface ViewController : UIViewController

// For subclasses.
- (void)prepareForNextGame; // Abstract.
- (void)initializeCardsView; // Abstract.

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (weak, nonatomic) IBOutlet UIButton *reDealBtn;

@end
