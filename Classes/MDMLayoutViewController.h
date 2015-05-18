//
//  MDMPayRootViewController.h
//  MDM
//
//  Created by Alekseenko Oleg on 02.06.14.
//  Copyright (c) 2014 Hyperboloid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMExpectedFrameProtocol.h"

typedef void(^MDMLayoutAnimationBlock)(void);

@interface MDMLayoutViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, readonly) UIScrollView *contentView;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

/**
 *   Always shows at the bottom of the contentView
 */
@property (nonatomic, strong) UIView *footerView;

/**
 *   Always shos at the top of the contentView
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *   Enable keyboard observing
 */
@property (nonatomic, assign) BOOL enableKeyboardObserving;

/**
 *   Layout all views.
 */
- (void)layoutContentViews;
- (void)layoutContentViewsWithAnimation;
- (void)layoutContentViewsAnimated:(BOOL)animated withPreAnimationBlock:(MDMLayoutAnimationBlock)preBlock completeBlock:(MDMLayoutAnimationBlock)complete;

/**
 *   After contentViews update you must call layoutContentViews to properly position views
 */
- (void)contentViewInsertView:(UIView *)view atIndex:(NSInteger)index;
- (void)contentViewInsertView:(UIView *)view aboveView:(UIView *)relativeView;
- (void)contentViewInsertView:(UIView *)view belowView:(UIView *)relativeView;

- (void)contentViewAddView:(UIView *)view;
- (void)contentViewAddViews:(NSArray *)views;

- (void)contentViewRemoveView:(UIView *)view;
- (void)contentViewRemoveViews:(NSArray *)views;

- (void)contentViewRemoveAllViews;
- (void)contentViewRemoveAllViewsExeptViews:(NSArray *)exeptViews;

@end
