//
//  ViewController.h
//  SuperCard
//
//  Created by nimrod gruber on 05/12/2017.
//  Copyright © 2017 Lightricks. All rights reserved.
//

#import "CGDeck.h"

@interface ViewController : UIViewController

// For subclasses.
- (CGDeck *)createDeck; // Abstract.
- (UIImage *)backGroundImageForCard:(CGCard *)card; // Abstract.
- (void)updateUI; // Abstract.

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@end
