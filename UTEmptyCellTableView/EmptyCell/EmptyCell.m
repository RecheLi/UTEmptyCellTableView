//
//  EmptyCell.m
//  UTEmptyCellTableView
//
//  Created by linitial on 2017/8/24.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "EmptyCell.h"

@interface EmptyCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) CAGradientLayer *gradientLayer;


@end

@implementation EmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-30, 20);
    gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor,(__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations = @[@(0.0),@(0.4)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 3.0;
    animation.toValue = @[@(0.5),@(1.0)];
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [gradientLayer addAnimation:animation forKey:nil];
    self.titleLabel.layer.mask = gradientLayer;
    self.gradientLayer = gradientLayer;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"EmptyCell";
    EmptyCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (EmptyCell *)[[[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
