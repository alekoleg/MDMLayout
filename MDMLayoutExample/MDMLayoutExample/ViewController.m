//
//  ViewController.m
//  MDMLayoutExample
//
//  Created by Alekseenko Oleg on 23.09.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *colors;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.colors = @[ [UIColor redColor], [UIColor greenColor], [UIColor blackColor], [UIColor blueColor]];
    
    self.footerView = [self randomView];
}

- (UIView *)randomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, arc4random() % 70 + 30)];
    view.backgroundColor = self.colors[arc4random() % self.colors.count];
    return view;
}

- (IBAction)addView:(id)sender {
    UIView *view = [self randomView];
    NSInteger index = (self.contentViews.count > 0) ? arc4random() % self.contentViews.count : 0;
    [self contentViewInsertView:view atIndex:index];
    [self layoutContentViewsAnimated:YES withPreAnimationBlock:NULL completeBlock:NULL];
}

- (IBAction)removeView:(id)sender {
    UIView *view = self.contentViews[arc4random() % self.contentViews.count];
    [self contentViewRemoveView:view];
    [self layoutContentViewsAnimated:YES withPreAnimationBlock:NULL completeBlock:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
