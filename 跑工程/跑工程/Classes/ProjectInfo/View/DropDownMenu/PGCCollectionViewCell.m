//
//  PGCCollectionViewCell.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCCollectionViewCell.h"

@implementation PGCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setAccessoryView:(UIImageView *)accessoryView {
    
    [self removeAccessoryView];
    
    _accessoryView = accessoryView;
    
    _accessoryView.frame = CGRectMake(self.frame.size.width - 10 - 16, (self.frame.size.height - 12) / 2, 16, 12);
    
    [self addSubview:_accessoryView];
}

- (void)removeAccessoryView {
    
    if(_accessoryView){
        
        [_accessoryView removeFromSuperview];
    }
}

@end
