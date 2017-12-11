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

- (void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

- (NSString *)rankAsString {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
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
     CGFloat myX = self.bounds.size.width * 0.1; //x-axis indentation of 10% of the cardView
//     [self drawShapes:faceImage X:(CGFloat)myX];
     
     if (self.number == 1) {
       [self displayOneForm:faceImage X:(CGFloat)myX];
     } else if (self.number == 2) {
       [self displayTwoForms:faceImage X:(CGFloat)myX];
     } else if (self.number == 3) {
       [self displayThreeForms:faceImage X:(CGFloat)myX];
     }
   }
}

//- (void)drawShapes:faceImage X:(CGFloat)myX {
//  CGFloat myY = self.bounds.size.height * kVerticalIndentationStartPositionFactor;
//
//  for (int i = 0; i < self.number; ++i) {
//    CGRect imageRect = CGRectMake(myX, myY, self.bounds.size.width * kHorizontalCompressionFactor,
//                                  self.bounds.size.height * kVerticalCompressionFactror);
//    [faceImage drawInRect:imageRect];
//    myY = self.bounds.size.height * (kVerticalIndentationStartPositionFactor +
//                                     (float)((i+1.0)/self.number) - (0.03 * (i+1)));
//  }
//}

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

#define PIP_HOFFSET_PRECENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips {
  if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
  }
  
  if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PRECENTAGE verticalOffset:0 mirroredVertically:NO];
  }
  
  if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) ||
      (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];
  }
  
  if ((self.rank ==4) || (self.rank ==5) || (self.rank == 6) || (self.rank == 7) ||
      (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PRECENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
  }
  
  if ((self.rank ==9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PRECENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE mirroredVertically:YES];
  }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown {
  if (upsideDown) {
    [self pushContextAndRotateUpsideDown];
  }
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName : pipFont }];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width / 2.0 - hoffset * self.bounds.size.width,
                                  middle.y - pipSize.height / 2.0 - voffset * self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) {
    [self popContext];
  }
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset
                 mirroredVertically:(BOOL)mirroredVertically {
  [self drawPipsWithHorizontalOffset:hoffset
                      verticalOffset:voffset
                          upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:YES];
  }
}

- (void)pushContextAndRotateUpsideDown {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Corners

- (void)drawCorners {
//  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//  paragraphStyle.alignment = NSTextAlignmentCenter;
//
//  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
//
//  NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
//
//  CGRect textBounds;
//  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
//  textBounds.size = [cornerText size];
//  [cornerText drawInRect:textBounds];
//
//  [self pushContextAndRotateUpsideDown];
//  [cornerText drawInRect:textBounds];
//  [self popContext];
}

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

- (BOOL)cardIsNotInitialized {
  if (self.color == undefinedColor) {
    return YES;
  } else {
    return NO;
  }
}
- (void)updateCardDisplay:(int)color theNumber:(int)number
                 theShade:(int)shade theSymbol:(int)symbol {
  self.color = color;
  self.number = number;
  self.shading = shade;
  self.symbol = symbol;
}

@end


NS_ASSUME_NONNULL_END
