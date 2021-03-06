//
//  MDMPayRootViewController.m
//  MDM
//
//  Created by Alekseenko Oleg on 02.06.14.
//  Copyright (c) 2014 Hyperboloid. All rights reserved.
//

#import "MDMLayoutViewController.h"
#import <ViewUtils.h>
#import "UIView+MDMLayout.h"

@interface MDMLayoutViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableSet *toAddContent;
@property (nonatomic, strong) NSMutableSet *toRemoveContent;
@property (nonatomic) CGFloat contentOffset;
@property (nonatomic, readonly) NSMutableArray *contentViews;
@end


@implementation MDMLayoutViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setupCommon];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCommon];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;


    [self setupContentView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.enableKeyboardObserving) {
        [self subscribeForKeyboardNotifications];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unSubscribeForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentView endEditing:YES];;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup -

- (void)setupCommon {
    if (!_toAddContent) {
        _toAddContent = [NSMutableSet set];
    }
    if (!_toRemoveContent) {
        _toRemoveContent = [NSMutableSet set];
    }

    if (!_contentView) {
        _contentViews = [NSMutableArray array];
    }
}

- (void)setupContentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _contentView.delegate = self;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        [self.view addSubview:_contentView];
    }
}


#pragma mark - Actions -

- (void)setFooterView:(UIView *)footerView {
    if (_footerView != footerView ) {
        if (_footerView) {
            [_footerView removeFromSuperview];
        }
        _footerView = footerView;
        [self.contentView addSubview:_footerView];
        [self layoutContentViewsAnimated:NO withPreAnimationBlock:NULL completeBlock:NULL];
    }
}

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView != headerView) {
        if (_headerView) {
            [_headerView removeFromSuperview];
        }
        _headerView = headerView;
        [self.contentView addSubview:_headerView];
        [self layoutContentViewsAnimated:NO withPreAnimationBlock:NULL completeBlock:NULL];
    }
}

- (void)textFieldBecomeResponder:(NSNotification *)not {
    UITextField *f = not.object;
    CGPoint point = [self.contentView convertPoint:f.frame.origin fromView:f];
    self.contentOffset = point.y - 10;
}

- (void)showKeyboard:(NSNotification *)not {

    CGRect frame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.contentInset.top, 0, frame.size.height, 0);
    CGFloat height = self.contentView.contentSize.height - self.contentOffset;
    CGFloat visibleHeight = self.contentView.frame.size.height - frame.size.height;
    if (visibleHeight > height) {
        self.contentOffset -= (visibleHeight - height);
    }
    
    if (self.contentOffset > 0) {
        __weak typeof(UIScrollView) *weakScroll = self.contentView;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakScroll setContentOffset:CGPointMake(weakScroll.contentOffset.x, weakSelf.contentOffset) animated:YES];
        });
    }
}

- (void)hideKeyboard:(NSNotification *)not {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.contentInset.top, 0, 0, 0);
    }];
}

- (void)viewTapped:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}


#pragma mark - Keyboard - 

- (void)setEnableKeyboardObserving:(BOOL)enableKeyboardObserving {
    _enableKeyboardObserving = enableKeyboardObserving;
    if (_enableKeyboardObserving) {
        [self subscribeForKeyboardNotifications];
    } else {
        [self unSubscribeForKeyboardNotifications];
    }
}

- (void)subscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBecomeResponder:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)unSubscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Variables -

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    [self.view setNeedsLayout];
}

- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    [self.view setNeedsLayout];
}


#pragma mark - API -

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutContentViews];
}

- (void)layoutContentViews {
    [self layoutContentViewsAnimated:NO withPreAnimationBlock:NULL completeBlock:NULL];
}

- (void)layoutContentViewsWithAnimation {
    [self layoutContentViewsAnimated:YES withPreAnimationBlock:NULL completeBlock:NULL];
}

- (void)layoutContentViewsAnimated:(BOOL)animated withPreAnimationBlock:(MDMLayoutAnimationBlock)preBlock completeBlock:(MDMLayoutAnimationBlock)complete {
    if (self.contentView == nil) {
        return;
    }
    
    //copy to be save
    
    NSSet *copy_toAddContent = [self.toAddContent copy];
    NSSet *copy_toRemove = [self.toRemoveContent copy];
    
    //clear
    [self.toAddContent removeAllObjects];
    [self.toRemoveContent removeAllObjects];
    
    
    for (UIView *view in copy_toAddContent) {
        view.alpha = 0.0;
        [self.contentView addSubview:view];
    }
    
    [self.contentViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.contentView bringSubviewToFront:obj];
    }];
    
    
    //pre caulculate start animation position for added views
    if (animated) {
        __block float offset = self.headerView.height;
        
        [self.contentViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
            if ([copy_toAddContent containsObject:obj]) {
                obj.top = offset - (obj.mdm_expectedHeigth / 2);
            }
            offset += (obj.mdm_expectedTopOffset + obj.mdm_expectedHeigth + obj.mdm_expectedBottomOffset);
        }];
    }
    
    
    void (^animationBlock) (void) = ^{
        if (preBlock) {
            preBlock();
        }
        
        //layout
        void (^layouBlock)(UIView *view, CGFloat offset) = ^(UIView *view, CGFloat offset) {
            view.frame = ({
                CGRect frame = view.frame;
                frame.origin.y = offset + view.mdm_expectedTopOffset;
                frame.origin.x = self.leftMargin + view.mdm_expectedLeftOffset;
                if (view.mdm_shouldStretchViewToFillWidth) {
                    frame.size.width = self.contentView.width - self.rightMargin - self.leftMargin - view.mdm_expectedLeftOffset - view.mdm_expectedRightOffset;
                } else {
                    frame.size.width = view.mdm_expectedWidth - view.mdm_expectedRightOffset - view.mdm_expectedLeftOffset;
                }
                frame.size.height = view.mdm_expectedHeigth;
                frame;
            });
        };
        
        
        //interaction
        float offset = 0;
        
        if (self.headerView) {
            layouBlock(self.headerView, offset);
            offset += self.headerView.bottom;
        }
        
        for (UIView *view in self.contentViews) {
            if ([copy_toRemove containsObject:view]) {
                [self.contentView sendSubviewToBack:view];
                view.top -= (view.height / 2);
                view.alpha = 0.0;
            } else if (view.hidden == NO) {
                view.alpha = 1.0;
                layouBlock(view, offset);
                
                if ([view respondsToSelector:@selector(mdm_updateLayoutAnimated:)]) {
                    [(id <MDMExpectedFrameProtocol>)view mdm_updateLayoutAnimated:animated];
                }
                offset = view.bottom + view.mdm_expectedBottomOffset;
            }
        }
        
        CGFloat footerY = MAX((self.contentView.height - self.footerView.mdm_expectedHeigth), offset);
        layouBlock(self.footerView, footerY);
        
        if (self.footerView) {
            offset = self.footerView.bottom;
        }
        
        self.contentView.contentSize = CGSizeMake(self.view.width, offset);
        
        [_contentViews removeObjectsInArray:[copy_toRemove allObjects]];
    };
    
    void (^completeBlock) (BOOL) = ^(BOOL flag){
        //for performance
        NSSet *set = [NSSet setWithArray:self.contentViews];
        [copy_toRemove enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            if (![set containsObject:obj]) {
                [obj removeFromSuperview];
            }
        }];
        
        if (complete) {
            complete();
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:animationBlock completion:completeBlock];
    } else {
        animationBlock();
        completeBlock(YES);
    }
}

- (void)contentViewAddViews:(NSArray *)views {
    for (UIView *view in views) {
        [self contentViewAddView:view];
    }
}

- (void)contentViewAddView:(UIView *)view {
    [self contentViewInsertView:view atIndex:self.contentViews.count];
}

- (void)contentViewRemoveView:(UIView *)view {
    
    [self contentViewRemoveViews:@[view]];
}

- (void)contentViewRemoveViews:(NSArray *)views {
    for (UIView *view in views) {
        [self.toAddContent removeObject:view];
    }
    [self.toRemoveContent addObjectsFromArray:views];
}

- (void)contentViewInsertView:(UIView *)view atIndex:(NSInteger)index {
    NSInteger idx = [self.contentViews indexOfObject:view];
    if (idx != NSNotFound) {
        if (idx < index) {
            index -= 1;
        }
        [self.contentViews removeObject:view];
        [self.contentViews insertObject:view atIndex:index];
    } else {
        [self.contentViews insertObject:view atIndex:index];
        [self.toAddContent addObject:view];
    }
    
    [self.toRemoveContent removeObject:view];
}

- (void)contentViewInsertView:(UIView *)view aboveView:(UIView *)relativeView {
    NSInteger index = [self.contentViews indexOfObject:relativeView];
    if (index == NSNotFound) {
        index = self.contentViews.count;
    }
    [self contentViewInsertView:view atIndex:index];
}

- (void)contentViewInsertView:(UIView *)view belowView:(UIView *)relativeView {
    NSInteger index = [self.contentViews indexOfObject:relativeView];
    if (index == NSNotFound) {
        index = self.contentViews.count;
    } else {
        index += 1;
    }
    [self contentViewInsertView:view atIndex:index];
}

- (void)contentViewRemoveAllViews {
    [self contentViewRemoveAllViewsExeptViews:nil];
}

- (void)contentViewRemoveAllViewsExeptViews:(NSArray *)exeptViews {
    NSSet * set = [NSSet setWithArray:exeptViews];
    [self.contentViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![set containsObject:obj]) {
            [self contentViewRemoveView:obj];
        }
    }];
}

- (void)relayoutContentViews {
    self.toAddContent = [self.contentView.subviews mutableCopy];
    [self.toAddContent makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self layoutContentViews];
}

@end
