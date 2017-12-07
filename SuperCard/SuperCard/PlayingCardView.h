// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@end

NS_ASSUME_NONNULL_END
