//
//  PKAlertTableViewController.m
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/21.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import "PKAlertTableViewController.h"

#import <PKAlertController.h>

static NSString *const Title = @"When the Pawn...";
static NSString *const LongTitle = @"When the Pawn Hits the Conflicts He Thinks like a King What He Knows Throws the Blows When He Goes to the Fight and He'll Win the Whole Thing 'fore He Enters the Ring There's No Body to Batter When Your Mind Is Your Might So When You Go Solo, You Hold Your Own Hand and Remember That Depth Is the Greatest of Heights and If You Know Where You Stand, Then You Know Where to Land and If You Fall It Won't Matter, Cuz You'll Know That You're Right";
static NSString *const Message = @"人間はひとくきの葦にすぎない。自然の中で最も弱いものである。だが、それは考える葦である。\n Human being is a reed of one stalk. It is the weakest existence naturally. However , it is a thinking reed.";
static NSString *const LongMessage = @"人間はひとくきの葦にすぎない。自然の中で最も弱いものである。だが、それは考える葦である。\n Human being is a reed of one stalk. It is the weakest existence naturally. However, it is a thinking reed. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. ";


static NSString *const Simple = @"Simple";
static NSString *const OKCancel = @"OKCancel";
static NSString *const Other = @"Other";
static NSString *const NoMessage = @"NoMessage";
static NSString *const TitleCenterMessageLeft = @"TitleCenterMessageLeft";
static NSString *const TitleLeftMessageLeft = @"TitleLeftMessageLeft";
static NSString *const LongTitleLongMessage = @"LongTitleLongMessage";
static NSString *const LongTitleLeftLongMessageLeft = @"LongTitleLeftLongMessageLeft";

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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PKAlertControllerStyle style = (PKAlertControllerStyle)indexPath.section;
    NSMutableArray *actions = [NSMutableArray array];

    if ([cell.reuseIdentifier isEqualToString:OKCancel]) {
        [actions addObjectsFromArray:@[[PKAlertAction cancelAction], [PKAlertAction okAction]]];
    } else if ([cell.reuseIdentifier isEqualToString:Other] ||
               [cell.reuseIdentifier isEqualToString:NoMessage]) {
        [actions addObjectsFromArray:@[[PKAlertAction doneAction], [PKAlertAction okAction], [PKAlertAction cancelAction]]];
    } else {
        [actions addObject:[PKAlertAction okAction]];
    }

    PKAlertViewController *alertController = [PKAlertViewController alertControllerWithConfigurationBlock:^(PKAlertControllerConfiguration *configuration) {
        if (![cell.reuseIdentifier isEqualToString:NoMessage]) {
            if ([cell.reuseIdentifier isEqualToString:LongTitleLongMessage] ||
                [cell.reuseIdentifier isEqualToString:LongTitleLeftLongMessageLeft]) {
                configuration.title = LongTitle;
                configuration.message = LongMessage;
            } else {
                configuration.title = Title;
                configuration.message = Message;
            }
        }
        configuration.preferredStyle = style;
        [configuration addActions:actions];
        if ([cell.reuseIdentifier isEqualToString:TitleCenterMessageLeft]) {
            configuration.messageTextAlignment = NSTextAlignmentLeft;
        } else if ([cell.reuseIdentifier isEqualToString:TitleLeftMessageLeft]) {
            configuration.titleTextAlignment = NSTextAlignmentLeft;
            configuration.messageTextAlignment = NSTextAlignmentLeft;
        } else if ([cell.reuseIdentifier isEqualToString:LongTitleLeftLongMessageLeft]) {
            configuration.titleTextAlignment = NSTextAlignmentLeft;
            configuration.messageTextAlignment = NSTextAlignmentLeft;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
