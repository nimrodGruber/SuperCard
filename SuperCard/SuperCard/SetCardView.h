// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

#import "CGSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : UIView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)updateCardDisplay:(ColorType)color theNumber:(int)number
                 theShade:(ShadeType)shade theSymbol:(SymbolType)symbol;

@property (nonatomic) ColorType color;
@property (nonatomic) int number;
@property (nonatomic) ShadeType shading;
@property (nonatomic) SymbolType symbol;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
