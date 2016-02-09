//
//  ViewController.m
//  Playground
//
//  Created by Jessie Serrino on 2/8/16.
//  Copyright © 2016 Hack Reactor. All rights reserved.
//

#import "ViewController.h"

static CGFloat const kCardPadding = 20;
static CGFloat const kSwipeThreshold = 100;

@interface ViewController ()

@property (nonatomic, strong) UIView *cardView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) CGPoint cardViewOrigin;

@property (nonatomic, assign) CGPoint touchPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCardView];
    [self initPanGestureRecognizer];
}

- (void) initCardView
{
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor magentaColor];
    
    self.cardViewOrigin = CGPointMake(kCardPadding, kCardPadding);
    CGRect cardViewFrame = CGRectMake(self.cardViewOrigin.x, self.cardViewOrigin.y, CGRectGetWidth(self.view.frame) - 2 * kCardPadding, CGRectGetHeight(self.view.frame) - 2 * kCardPadding);
    self.cardView.frame = cardViewFrame;
    
    [self.view addSubview:self.cardView];
}

- (void) initPanGestureRecognizer
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void) panGestureRecognized: (UIPanGestureRecognizer *) panGestureRecognizer
{

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.touchPoint = [panGestureRecognizer locationOfTouch:0 inView:self.view];
    } else {
        // Move the view accordingly
        if ([panGestureRecognizer numberOfTouches] > 0) {
            CGPoint touchPoint = [panGestureRecognizer locationOfTouch:0 inView:self.view];
            CGPoint pointDifference = CGPointMake(touchPoint.x - self.touchPoint.x, touchPoint.y - self.touchPoint.y);
            CGRect cardViewFrame = self.cardView.frame;
            CGPoint originOfView = cardViewFrame.origin;
            originOfView.x += pointDifference.x;
            originOfView.y += pointDifference.y;
            
            cardViewFrame.origin = originOfView;
            self.cardView.frame = cardViewFrame;
            self.touchPoint = touchPoint;
        }
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat xDistanceTraveled = self.cardView.frame.origin.x - self.cardViewOrigin.x;
        BOOL shouldBeDismissed = fabsf((float) xDistanceTraveled) > kSwipeThreshold;
        
        if (!shouldBeDismissed) {
            CGRect cardViewFrame = self.cardView.frame;
            cardViewFrame.origin = self.cardViewOrigin;
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.cardView.frame = cardViewFrame;
            } completion:nil];
        } else {
            CGRect cardViewFrame = self.cardView.frame;
            
            if (xDistanceTraveled < 0) {
                // Go to the left
                cardViewFrame.origin = CGPointMake(-300 + kCardPadding, kCardPadding);
            } else {
                cardViewFrame.origin = CGPointMake(300 + kCardPadding, kCardPadding);
            }
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.cardView.frame = cardViewFrame;
            } completion:nil];
        }
    }
}

@end
