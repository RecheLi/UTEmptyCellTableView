//
//  UITableView+UTEmptyCell.h
//  UTEmptyCellTableView
//
//  Created by linitial on 2017/8/24.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewEmptyCellDataSource,UITableViewEmptyCellDelegate;

@interface UITableView (UTEmptyCell)

@property (nonatomic, weak) id<UITableViewEmptyCellDataSource>emptyCellDataSource;

@property (nonatomic, weak) id<UITableViewEmptyCellDelegate>emptyCellDelegate;

- (void)reloadEmptyDataSource;

@end

@protocol UITableViewEmptyCellDataSource <NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfUITableViewEmptyCellInSection:(NSInteger)section;

- ( UITableViewCell *)cellForTableView:(UITableView *)tableView;


@end

@protocol UITableViewEmptyCellDelegate <NSObject>

- (CGFloat)heightForEmptyCellAtIndexPath:(NSIndexPath *)indexPath;


@end

