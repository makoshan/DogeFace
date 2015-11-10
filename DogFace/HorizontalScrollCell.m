//
//  HorizontalScrollCell.m
//  MoviePicker
//
//  Created by Muratcan Celayir on 28.01.2015.
//  Copyright (c) 2015 Muratcan Celayir. All rights reserved.
//

#import "HorizontalScrollCell.h"


@implementation HorizontalScrollCell

- (void)awakeFromNib {
    // Initialization code
 
}

-(void)setUpCellWithArray:(NSArray *)array
{
    CGFloat xbase = 10;
    CGFloat width = 50;
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    
    for(int i = 0; i < [array count]; i++)
    {
        UIImage *image = [array objectAtIndex:i];
        UIView *custom = [self createCustomViewWithImage: image];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, 7, width, 60)];
        xbase += 10 + width;
        
        
    }
    
    [self.scroll setContentSize:CGSizeMake(xbase, self.scroll.frame.size.height)];
    
    self.scroll.delegate = self;
}

-(UIView *)createCustomViewWithImage:(UIImage *)image
{
    UIView *custom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 60)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imageView setImage:image];
    
    [custom addSubview:imageView];
    [custom setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [custom addGestureRecognizer:singleFingerTap];
    
    return custom;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    [self containingScrollViewDidEndDragging:scrollView];
    
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    
    NSLog(@"%.2f",containingScrollView.contentOffset.x);
    
    NSLog(@"%.2f",self.scroll.contentSize.width);
    
    if (containingScrollView.contentOffset.x <= -25)
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-25 , 7, 50, 50)];
        
        UIActivityIndicatorView *acc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        acc.hidesWhenStopped = YES;
        [view addSubview:acc];
        
        [acc setFrame:CGRectMake(view.center.x , view.center.y , 50, 50)];
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [self.scroll addSubview:view];
        
        
        
    
        
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"clicked");
    
    UIView *selectedView = (UIView *)recognizer.view;
    
    if([_cellDelegate respondsToSelector:@selector(cellSelected)])
        [_cellDelegate cellSelected];
    
    //Do stuff here...
}

@end
