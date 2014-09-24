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
@property (nonatomic, readonly) NSMutableArray *contentViews;
/**
 *   Always shows at the bottom of the contentView
 */
@property (nonatomic, strong) UIView *footerView;

/**
 *   Layout all views.
 *   If view responds to MDMExpectedFrameProtocol. ExpectedFrame assings to view while layouting
 */
- (void)layoutContentViews;
- (void)layoutContentViewsAnimated:(BOOL)animated withPreAnimationBlock:(MDMLayoutAnimationBlock)preBlock completeBlock:(MDMLayoutAnimationBlock)complete;

/**
 *   After contentViews update you must call layoutContentViews to properly position views
 */
- (void)contentViewInsertView:(UIView *)view atIndex:(NSInteger)index;
- (void)contentViewAddView:(UIView *)view;
- (void)contentViewRemoveView:(UIView *)view;
- (void)contentViewRemoveViews:(NSArray *)views;



@end
