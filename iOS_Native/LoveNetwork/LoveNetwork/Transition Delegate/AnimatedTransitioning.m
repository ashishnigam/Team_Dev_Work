//
//  AnimatedTransitioning.m
//  CustomTransitionExample
//
//  Created by Blanche Faur on 10/24/13.
//  Copyright (c) 2013 Blanche Faur. All rights reserved.
//

#import "AnimatedTransitioning.h"
//#import "HomeViewController.h"
//#import "SearchViewController.h"

#import "LibiOS.h"

@implementation AnimatedTransitioning

//===================================================================
// - UIViewControllerAnimatedTransitioning
//===================================================================

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (isPortrait()) {
        [toVC.view setFrame:CGRectMake(screenRect.size.width, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
        
    }else if (isLandscape())
    {
        [toVC.view setFrame:CGRectMake(0, -screenRect.size.height, screenRect.size.width, screenRect.size.height)];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (val) {
                                 [toVC.view setFrame:CGRectMake(0, -673, screenRect.size.width, screenRect.size.height)];
                             }else{
                                 [toVC.view setFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
                             }
                             
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
        
    }
    
    
    
}


@end
