// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by nimrod gruber.

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : UIView

- (BOOL)cardIsNotInitialized;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)updateCardDisplay:(NSString *)suit rank:(NSUInteger)rank;

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
