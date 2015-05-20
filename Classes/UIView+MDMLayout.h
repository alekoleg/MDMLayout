//
//  UIView+MDMLayout.h
//  MDMLayoutExample
//
//  Created by Oleg Alekseenko on 15/05/15.
//  Copyright (c) 2015 alekoleg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MDMLayout)

//by default expected height is equal to height
@property (nonatomic, assign) CGFloat mdm_expectedHeigth;
@property (nonatomic, assign) CGFloat mdm_expectedWidth;
@property (nonatomic, assign) CGFloat mdm_expectedTopOffset;
@property (nonatomic, assign) CGFloat mdm_expectedLeftOffset;
@property (nonatomic, assign) CGFloat mdm_expectedRightOffset;
@property (nonatomic, assign) CGFloat mdm_expectedBottomOffset;

@property (nonatomic, assign) BOOL mdm_shouldStretchViewToFillWidth;

@end
