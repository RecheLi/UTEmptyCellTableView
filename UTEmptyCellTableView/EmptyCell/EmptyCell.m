//
//  EmptyCell.m
//  UTEmptyCellTableView
//
//  Created by linitial on 2017/8/24.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
