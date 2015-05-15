//
//  UIView+MDMLayout.m
//  MDMLayoutExample
//
//  Created by Oleg Alekseenko on 15/05/15.
//  Copyright (c) 2015 alekoleg. All rights reserved.
//

#import "UIView+MDMLayout.h"
#import <objc/runtime.h>

@implementation UIView (MDMLayout)

- (void)setMdm_expectedHeigth:(CGFloat)mdm_expectedHeigth {
    objc_setAssociatedObject(self, @selector(mdm_expectedHeigth), @(mdm_expectedHeigth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mdm_expectedHeigth {
    NSNumber *number = objc_getAssociatedObject(self, @selector(mdm_expectedHeigth));
    CGFloat result = [number floatValue];
    if (!number) {
        result = self.frame.size.height;
    }
    return result;
}

- (void)setMdm_expectedWidth:(CGFloat)mdm_expectedWidth {
    objc_setAssociatedObject(self, @selector(mdm_expectedWidth), @(mdm_expectedWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mdm_expectedWidth {
    NSNumber *number = objc_getAssociatedObject(self, @selector(mdm_expectedWidth));
    CGFloat result = [number floatValue];
    if (!number) {
        result = self.frame.size.width;
    }
    return result;
}

- (void)setMdm_expectedTopOffset:(CGFloat)mdm_expectedTopOffset {
    objc_setAssociatedObject(self, @selector(mdm_expectedTopOffset), @(mdm_expectedTopOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mdm_expectedTopOffset {
    return [objc_getAssociatedObject(self, @selector(mdm_expectedTopOffset)) floatValue];
}

- (void)setMdm_expectedLeftOffset:(CGFloat)mdm_expectedLeftOffset {
    objc_setAssociatedObject(self, @selector(mdm_expectedLeftOffset), @(mdm_expectedLeftOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mdm_expectedLeftOffset {
    return [objc_getAssociatedObject(self, @selector(mdm_expectedLeftOffset)) floatValue];
}

- (void)setMdm_expectedRightOffset:(CGFloat)mdm_expectedRightOffset {
    objc_setAssociatedObject(self, @selector(mdm_expectedRightOffset), @(mdm_expectedRightOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mdm_expectedRightOffset {
    return [objc_getAssociatedObject(self, @selector(mdm_expectedRightOffset)) floatValue];
}

- (void)setMdm_shouldStretchViewToFillWidth:(BOOL)mdm_shouldStretchViewToFillWidth {
    objc_setAssociatedObject(self, @selector(mdm_shouldStretchViewToFillWidth), @(mdm_shouldStretchViewToFillWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mdm_shouldStretchViewToFillWidth {
    return [objc_getAssociatedObject(self, @selector(mdm_shouldStretchViewToFillWidth)) boolValue];
}

@end
