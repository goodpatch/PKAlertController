//
//  PKAlertTableViewController.m
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/21.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import "PKAlertTableViewController.h"

#import <PKAlertController.h>

@interface PKAlertTableViewController ()

@end

@implementation PKAlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performDisplayAlertAtIndexPath:indexPath];
}

#pragma mark - Navigation

- (void)performDisplayAlertAtIndexPath:(NSIndexPath *)indexPath {
    PKAlertControllerStyle style = (PKAlertControllerStyle)indexPath.row;
    PKAlertViewController *alertController = [PKAlertViewController alertControllerWithConfigurationBlock:^(PKAlertControllerConfiguration *configuration) {
        configuration.title = @"Alert title";
//        configuration.message = @"人間はひとくきの葦にすぎない。自然の中で最も弱いものである。だが、それは考える葦である。\n Human being is a reed of one stalk. It is the weakest existence naturally. However , it is a thinking reed.";
        // Testing multi-byte text.
        configuration.message = @"人間はひとくきの葦にすぎない。自然の中で最も弱いものである。だが、それは考える葦である。\n Human being is a reed of one stalk. It is the weakest existence naturally. However , it is a thinking reed .Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        configuration.preferredStyle = style;
        NSMutableArray *actions = @[
            [PKAlertAction cancelAction],
            [PKAlertAction okAction],
        ].mutableCopy;
        if (style == PKAlertControllerStyleFullScreen) {
            [actions addObject:[PKAlertAction doneAction]];
        }
        [configuration addActions:actions];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
