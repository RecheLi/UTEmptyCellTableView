//
//  ViewController.m
//  UTEmptyCellTableView
//
//  Created by linitial on 2017/8/24.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+UTEmptyCell.h"
#import "EmptyCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate,UITableViewEmptyCellDataSource,UITableViewEmptyCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *datasource;

@end

@implementation ViewController

#pragma mark - Getter -
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = self.view.center;
    }
    return _activityIndicatorView;
}

#pragma mark - View Cycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark - setup

- (void)setup {
    [self setupTableView];
    [self setupRefreshButton];
    [self fetchData];
}

- (void)setupTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyCellDataSource = self;
    _tableView.emptyCellDelegate = self;
    [_tableView reloadData];
    [_tableView reloadEmptyDataSource];
}

- (void)setupRefreshButton {
    [_refreshButton addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventTouchUpInside];
}

- (void)fetchData {
    [self.datasource removeAllObjects];
    [self.view addSubview:self.activityIndicatorView];
    [_activityIndicatorView startAnimating];
    for (int i=0; i<22; i++) {
        [self.datasource addObject:@(i)];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView removeFromSuperview];
        [_tableView reloadData];
        [_tableView reloadEmptyDataSource];
    });
}

#pragma mark - UITableViewDataSource, UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"the %@ row",self.datasource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewEmptyCellDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfUITableViewEmptyCellInSection:(NSInteger)section {
    return floor(self.view.bounds.size.height/70.0);
}

- (UITableViewCell * _Nonnull)cellForTableView:(UITableView *)tableView {
    return [EmptyCell cellWithTableView:tableView];
}

#pragma mark - UITableViewEmptyCellDelegate -
- (CGFloat)heightForEmptyCellAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
