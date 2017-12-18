// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "SetCardView.h"
#import "CGSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation SetCardView

#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor {
  if (!_faceCardScaleFactor) {
    _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  }
  
  return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

#pragma mark - Gesture Handling

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    self.faceCardScaleFactor *= gesture.scale;
    gesture.scale = 1.0;
  }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
static const float kHorizontalCompressionFactor = 0.8;
static const float kVerticalCompressionFactror = 0.2;
static const float kVerticalIndentationStartPositionFactor = 0.1;

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

 - (void)drawRect:(CGRect)rect {
   // Drawing code.
   UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                          cornerRadius:[self cornerRadius]];
   [roundedRect addClip];
   
   [[UIColor whiteColor] setFill];
   UIRectFill(self.bounds);
   
   [[UIColor blackColor] setStroke];
   [roundedRect stroke];

   NSMutableString *imageName = [[NSMutableString alloc] init];
   [self setImageNameFromCard:imageName];
   UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
   
   if (faceImage) {
     CGFloat myX = self.bounds.size.width * 0.1;
     if (self.number == 1) {
       [self displayOneForm:faceImage X:(CGFloat)myX];
     } else if (self.number == 2) {
       [self displayTwoForms:faceImage X:(CGFloat)myX];
     } else if (self.number == 3) {
       [self displayThreeForms:faceImage X:(CGFloat)myX];
     }
   }
}

- (void)displayOneForm:faceImage X:(CGFloat)myX {
  CGFloat myY = self.bounds.size.height * 0.4;
  CGRect imageRect = CGRectMake(myX, myY, self.bounds.size.width * kHorizontalCompressionFactor,
                                self.bounds.size.height * kVerticalCompressionFactror);
  [faceImage drawInRect:imageRect];
}

- (void)displayTwoForms:faceImage X:(CGFloat)myX {
  CGFloat myY = self.bounds.size.height * 0.2;
  CGRect imageRect = CGRectMake(myX, myY, self.bounds.size.width * kHorizontalCompressionFactor,
                                 self.bounds.size.height * kVerticalCompressionFactror);
  [faceImage drawInRect:imageRect];
  
  myY = self.bounds.size.height * 0.6;
  imageRect = CGRectMake(myX, myY, self.bounds.size.width * kHorizontalCompressionFactor,
                         self.bounds.size.height * kVerticalCompressionFactror);
  [faceImage drawInRect:imageRect];
}

-(void) displayThreeForms:faceImage X:(CGFloat)myX {
  CGFloat myY = self.bounds.size.height * kVerticalIndentationStartPositionFactor;
  
  for (int i = 0; i < self.number; ++i) {
    CGRect imageRect = CGRectMake(myX, myY, self.bounds.size.width * kHorizontalCompressionFactor,
                                  self.bounds.size.height * kVerticalCompressionFactror);
    [faceImage drawInRect:imageRect];
    myY = self.bounds.size.height * (kVerticalIndentationStartPositionFactor +
                                     (float)((i+1.0)/self.number) - (0.03 * (i+1)));
  }
}

- (void)setImageNameFromCard:(NSMutableString *)imageName {
  [imageName appendString:[self symbolPrefix]];
  [imageName appendString:[self colorPrefix]];
  [imageName appendString:[self filling]];
}

- (NSString *)symbolPrefix {
  switch (self.symbol) {
    case diamond:
      return @"D";
      break;
    case oval:
      return @"O";
      break;
    case squiggle:
      return @"S";
      break;
  }
  
  return nil;
}

- (NSString *)colorPrefix {
  switch (self.color) {
    case red:
      return @"R";
      break;
    case green:
      return @"G";
      break;
    case purple:
      return @"P";
      break;
  }
  
  return nil;
}

- (NSString *)filling {
  switch (self.shading) {
    case solid:
      return @"solid";
      break;
    case striped:
      return @"striped";
      break;
    case unfilled:
      return @"unfilled";
      break;
  }
  
  return nil;
}

#pragma  mark - Pips

#pragma mark - Corners

#pragma mark - Initialization

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

#pragma mark - Personal Utility functions

- (void)updateCardDisplay:(int)color theNumber:(int)number theShade:(int)shade
      theSymbol:(int)symbol {
  self.color = color;
  self.number = number;
  self.shading = shade;
  self.symbol = symbol;
}

@end

NS_ASSUME_NONNULL_END
