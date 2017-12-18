// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : UIView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)updateCardDisplay:(int)color theNumber:(int)number
                 theShade:(int)shade theSymbol:(int)symbol;

@property (nonatomic) int color;
@property (nonatomic) int number;
@property (nonatomic) int shading;
@property (nonatomic) int symbol;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
