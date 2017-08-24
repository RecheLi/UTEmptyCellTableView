//
//  UITableView+EmptyCell.m
//  RunloopDemo
//
//  Created by linitial on 2017/8/24.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "UITableView+UTEmptyCell.h"
#import <objc/runtime.h>

@interface UTWeakObject : NSObject

@property (nonatomic, weak, readonly) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface UTEmptyView : UIView

@property (nonatomic, strong) UITableView *emptyTableView;

@property (nonatomic, weak) UITableView *parentTableView;

@end

@interface UITableView ()

@property (nonatomic, strong, readonly) UTEmptyView *emptyView;

@property (nonatomic, assign, readonly) UITableViewCellSeparatorStyle currentSeperatorStyle;

@end

static char const * const kEmptyCellDataSource = "emptyCellDataSource";
static char const * const kEmptyCellDelegate = "emptyCellDelegate";
static char const * const kEmptyViewKey = "emptyViewKey";
static char const * const kEmptyCellCurrentSeperatorStyle = "emptyCellCurrentSeperatorStyle";

@implementation UITableView (UTEmptyCell)

- (id<UITableViewEmptyCellDataSource>)emptyCellDataSource {
    UTWeakObject *tempObject =  objc_getAssociatedObject(self, kEmptyCellDataSource);
    return tempObject.weakObject;
}

- (void)setEmptyCellDataSource:(id<UITableViewEmptyCellDataSource>)emptyCellDataSource {
    self.currentSeperatorStyle = self.separatorStyle;
    objc_setAssociatedObject(self, kEmptyCellDataSource, [[UTWeakObject alloc]initWithWeakObject:emptyCellDataSource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UITableViewEmptyCellDelegate>)emptyCellDelegate {
    UTWeakObject *tempObject =  objc_getAssociatedObject(self, kEmptyCellDelegate);
    return tempObject.weakObject;
}

- (void)setEmptyCellDelegate:(id<UITableViewEmptyCellDelegate>)emptyCellDelegate {
    objc_setAssociatedObject(self, kEmptyCellDelegate, [[UTWeakObject alloc]initWithWeakObject:emptyCellDelegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UTEmptyView *)emptyView {
    UTEmptyView *view = objc_getAssociatedObject(self, kEmptyViewKey);
    if (!view) {
        view = [UTEmptyView new];
        view.parentTableView = self;
        [self setEmptyView:view];
    }
    return view;
}

- (void)setEmptyView:(UTEmptyView *)emptyView {
    objc_setAssociatedObject(self, kEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCellSeparatorStyle)currentSeperatorStyle {
    return [objc_getAssociatedObject(self, kEmptyCellCurrentSeperatorStyle) integerValue];
}

- (void)setCurrentSeperatorStyle:(UITableViewCellSeparatorStyle)currentSeperatorStyle {
    objc_setAssociatedObject(self, kEmptyCellCurrentSeperatorStyle, @(currentSeperatorStyle), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Public
- (void)reloadEmptyDataSource {
    [self ut_reloadEmptyDataSource];
}

#pragma mark - Private 
- (void)ut_reloadEmptyDataSource {
    if (!self.emptyCellDataSource) {
        self.separatorStyle = self.currentSeperatorStyle;
        if (self.emptyView) {
            [self.emptyView removeFromSuperview];
        }
        return;
    }
    if ([self ut_rowsCount]>0) {
        self.separatorStyle = self.currentSeperatorStyle;
        if (self.emptyView) {
            [self.emptyView removeFromSuperview];
        }
        return;
    }
    if (self.emptyCellDataSource&&[self.emptyCellDataSource respondsToSelector:@selector(cellForTableView:)]) {
        UITableView *tableView = (UITableView *)self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView addSubview:self.emptyView];
    }
}

#pragma mark - NumberOfRows
- (NSInteger)ut_rowsCount {
    UITableView *tableView = (UITableView *)self;
    id <UITableViewDataSource> dataSource = tableView.dataSource;
    NSInteger sections = 1;
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfSections)]) {
        sections = [dataSource numberOfSectionsInTableView:tableView];
    }
    NSInteger rowsCount = 0;
    if (dataSource &&[dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        for (int section=0; section<sections; section++) {
            rowsCount += [dataSource tableView:tableView numberOfRowsInSection:section];
        }
    }
    return rowsCount;
}

@end

#pragma mark - UTEmptyView -

@interface UTEmptyView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UTEmptyView

- (UITableView *)emptyTableView {
    if (!_emptyTableView) {
        _emptyTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _emptyTableView.dataSource = self;
        _emptyTableView.delegate = self;
        _emptyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _emptyTableView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyTableView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.emptyTableView];
    }
    return self;
}

- (void)didMoveToSuperview {
    self.frame = self.superview.bounds;
    _emptyTableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.parentTableView.emptyCellDataSource && [self.parentTableView.emptyCellDataSource respondsToSelector:@selector(tableView:numberOfUITableViewEmptyCellInSection:)]) {
        return [self.parentTableView.emptyCellDataSource tableView:self.parentTableView numberOfUITableViewEmptyCellInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parentTableView.emptyCellDataSource && [self.parentTableView.emptyCellDataSource respondsToSelector:@selector(cellForTableView:)]) {
        UITableViewCell *emptyCell = [self.parentTableView.emptyCellDataSource cellForTableView:self.parentTableView];
        if (!emptyCell) {
            static NSString *cellIdentifier = @"cellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
                imageView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
                [cell.contentView addSubview:imageView];

                UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, self.bounds.size.width-10*2, 20)];
                tempLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
                [cell.contentView addSubview:tempLabel];
            }
            emptyCell = cell;
        }
        return emptyCell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parentTableView.emptyCellDelegate && [self.parentTableView.emptyCellDelegate respondsToSelector:@selector(heightForEmptyCellAtIndexPath:)]) {
        return [self.parentTableView.emptyCellDelegate heightForEmptyCellAtIndexPath:indexPath];
    }
    return 70.0;
}

@end

#pragma mark - UTWeakObject -
@implementation UTWeakObject

- (instancetype)initWithWeakObject:(id)object {
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end
