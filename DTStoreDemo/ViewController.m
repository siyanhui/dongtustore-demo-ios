//
//  ViewController.m
//  DTStoreDemo
//
//  Created by Isan Hu on 2019/3/1.
//  Copyright © 2019 siyanhui. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "StoreDemoViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerContainerView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    _headerContainerView = [UIView new];
    _headerContainerView.backgroundColor = [UIColor colorWithWhite:242.0 / 255 alpha:1.0];
    [self.view addSubview:_headerContainerView];
    [_headerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@195);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    self.headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    [self.headerContainerView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContainerView.mas_top);
        make.right.equalTo(self.headerContainerView.mas_right);
        make.bottom.equalTo(self.headerContainerView.mas_bottom);
    }];
    
    _infoLabel = [UILabel new];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.textColor = [UIColor colorWithWhite:74.0 / 255 alpha:1.0];
    _infoLabel.text = @"动图商店SDK Demo";
    _infoLabel.font = [UIFont systemFontOfSize:20];
    _infoLabel.textAlignment = NSTextAlignmentRight;
    [_headerContainerView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_left);
        make.bottom.equalTo(self.headerContainerView.mas_bottom).with.offset(-28);
    }];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorColor = [UIColor colorWithWhite:0.59 alpha:1];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 2, 0);
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _versionLabel = [UILabel new];
    _versionLabel.backgroundColor = [UIColor clearColor];
    _versionLabel.textColor = [UIColor colorWithWhite:155.0 / 255 alpha:1.0];
    _versionLabel.text = [NSString stringWithFormat:@"SDK:%@  Build: %@", [[DongtuStore sharedInstance] version],
                          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    _versionLabel.font = [UIFont systemFontOfSize:12];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_versionLabel];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-23);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = true;
}


#pragma mark: UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"动图SDK Demo";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"动图Store SDK Demo";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //    if (indexPath.row == 0) {
    //        QuaterScreenDemoViewController *vc = [[QuaterScreenDemoViewController alloc] init];
    //        [self.navigationController pushViewController:vc animated:true];
    //    }else if (indexPath.row == 1) {
    //        HalfScreenDemoViewController *vc = [[HalfScreenDemoViewController alloc] init];
    //        [self.navigationController pushViewController:vc animated:true];
    //    }else if (indexPath.row == 2) {
    //
    //    }
    
    StoreDemoViewController *vc = [[StoreDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}


@end
