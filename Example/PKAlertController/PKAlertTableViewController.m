//
//  PKAlertTableViewController.m
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/21.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import "PKAlertTableViewController.h"

#import <PKAlertController.h>
#import <FontAwesomeKit.h>
#import <FLEXManager.h>

#import "PKCustomView.h"

static NSString *const Title = @"When the Pawn...\nSecond line";
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
static NSString *const CustomView = @"CustomView";
static NSString *const MessageOnly = @"MessageOnly";
static NSString *const TitleOnly = @"TitleOnly";
static NSString *const ActionHeight = @"ActionHeight";
static NSString *const DropShadow = @"DropShadow";

static const CGFloat DefaultBarButtonItemLength = 22.0;
static const CGSize DefaultBarButtonItemSize = {DefaultBarButtonItemLength, DefaultBarButtonItemLength};

typedef NS_ENUM(NSInteger, PKActionButtonType) {
    PKActionButtonTypeTheme = 20,
    PKActionButtonTypeTxIn = 21,
    PKActionButtonTypeTxOut = 22,
    PKActionButtonTypeAppearInAnimation = 23,
    PKActionButtonTypeFLEXMenu = 24,
};

@interface PKAlertTableViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *switchActionButtons;
@property (nonatomic) PKCustomView *customView;
@property (nonatomic) PKAlertControllerPresentationTransitionStyle presentationTransitionStyle;
@property (nonatomic) PKAlertControllerDismissTransitionStyle dismissTransitionStyle;
@property (nonatomic) PKAlertControllerViewAppearInAnimationType viewAppearInAnimationType;

@end

@implementation PKAlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.presentationTransitionStyle = PKAlertControllerPresentationTransitionStyleFocusIn;
    self.dismissTransitionStyle = PKAlertControllerDismissTransitionStyleFadeOut;
    self.viewAppearInAnimationType = PKAlertControllerViewAppearInAnimationTypeDropIn;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = imageView;

    NSMutableArray *toolbarButtonItems = self.toolbarItems.mutableCopy;
    for (UIBarButtonItem *item in self.switchActionButtons) {
        if (item.tag == PKActionButtonTypeTheme) {
            item.image = [[FAKFontAwesome paintBrushIconWithSize:DefaultBarButtonItemLength] imageWithSize:DefaultBarButtonItemSize];
        } else if (item.tag == PKActionButtonTypeAppearInAnimation) {
            item.image = [[FAKFontAwesome lineChartIconWithSize:DefaultBarButtonItemLength] imageWithSize:DefaultBarButtonItemSize];
        }
    }
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    if (env[@"PK_DEBUGGER_ENABLED"]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"FLEX" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFLEXMenu:)];
        item.tag = PKActionButtonTypeFLEXMenu;
        [toolbarButtonItems addObject:item];
    }
    self.toolbarItems = toolbarButtonItems;

    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PKCustomView class]) bundle:[NSBundle mainBundle]];
    PKCustomView *customView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    UILabel *titleLabel = (UILabel *)[customView viewWithTag:PKCustomViewTypeTitleLabel];
    UILabel *subTitleLabel = (UILabel *)[customView viewWithTag:PKCustomViewTypeSubTitleLabel];
    UITextView *descriptionTextView = (UITextView *)[customView viewWithTag:PKCustomViewTypeDescriptionTextView];

    titleLabel.text = Title;
    subTitleLabel.text = @"Version 0.0.1";
    descriptionTextView.text = Message;

    self.customView = customView;
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

#pragma mark - Target actions

- (IBAction)changeTheme:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Change UI Theme";
    actionSheet.tag = PKActionButtonTypeTheme + 500;
    [actionSheet addButtonWithTitle:@"Default"];
    [actionSheet addButtonWithTitle:@"WhiteBlue"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    [self presentWithActionSheet:actionSheet];
}

- (IBAction)changePresentationTransition:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Change Presentation Transition style";
    actionSheet.tag = PKActionButtonTypeTxIn + 500;
    [@[@"None", @"Fade In", @"Focus In", @"Slide Down", @"Push Down", @"Scale", @"Semi Modal", @"Cancel"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [actionSheet addButtonWithTitle:title];
    }];
    [self presentWithActionSheet:actionSheet];
}

- (IBAction)changeDismissTransition:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Change Dismiss Transition style";
    actionSheet.tag = PKActionButtonTypeTxOut + 500;
    [@[@"None", @"Fade Out", @"Zoom Out", @"Slide Down", @"Push Down", @"Semi Modal", @"Bounce Out", @"Cancel"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [actionSheet addButtonWithTitle:title];
    }];
    [self presentWithActionSheet:actionSheet];
}

- (IBAction)changeViewAppearInAnimation:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Change View Appear In Animation";
    actionSheet.tag = PKActionButtonTypeAppearInAnimation + 500;
    [@[@"None", @"Drop In", @"Cancel"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [actionSheet addButtonWithTitle:title];
    }];
    [self presentWithActionSheet:actionSheet];
}

- (void)presentWithActionSheet:(UIActionSheet *)actionSheet {
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    actionSheet.delegate = self;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (IBAction)toggleFLEXMenu:(id)sender {
    FLEXManager *flexManager = [FLEXManager sharedManager];
    if (flexManager.isHidden) {
        [flexManager showExplorer];
    } else {
        [flexManager hideExplorer];
    }
}

#pragma mark - Navigation

- (void)performDisplayAlertAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PKAlertControllerStyle style = (PKAlertControllerStyle)indexPath.section;
    NSMutableArray *actions = [NSMutableArray array];

    if ([cell.reuseIdentifier isEqualToString:OKCancel]) {
        [actions addObjectsFromArray:@[[PKAlertAction cancelAction], [PKAlertAction okAction]]];
    } else if ([@[Other, NoMessage] containsObject:cell.reuseIdentifier]) {
        [actions addObjectsFromArray:@[[PKAlertAction doneAction], [PKAlertAction okAction], [PKAlertAction cancelAction]]];
    } else if ([cell.reuseIdentifier isEqualToString:CustomView]) {
        [actions addObject:[PKAlertAction actionWithTitle:@"Close" handler:nil]];
    } else {
        [actions addObject:[PKAlertAction okAction]];
    }

    PKAlertViewController *alertController = [PKAlertViewController alertControllerWithConfigurationBlock:^(PKAlertControllerConfiguration *configuration) {
        if (![cell.reuseIdentifier isEqualToString:NoMessage]) {
            if ([@[LongTitleLongMessage, LongTitleLeftLongMessageLeft] containsObject:cell.reuseIdentifier]) {
                configuration.title = LongTitle;
                configuration.message = LongMessage;
            } else if ([cell.reuseIdentifier isEqualToString:CustomView]) {
                configuration.customView = self.customView;
            } else if ([cell.reuseIdentifier isEqualToString:MessageOnly]) {
                configuration.message = Message;
            } else if ([cell.reuseIdentifier isEqualToString:TitleOnly]) {
                configuration.title = Title;
            } else {
                configuration.title = Title;
                configuration.message = Message;
            }
        }
        if ([cell.reuseIdentifier isEqualToString:ActionHeight]) {
            configuration.actionControlHeight = cell.tag;
        }
        if ([cell.reuseIdentifier isEqualToString:DropShadow]) {
            configuration.solid = YES;
        }
        configuration.preferredStyle = style;
        configuration.presentationTransitionStyle = self.presentationTransitionStyle;
        configuration.dismissTransitionStyle = self.dismissTransitionStyle;
        configuration.viewAppearInAnimationType = self.viewAppearInAnimationType;
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    if (actionSheet.tag == PKActionButtonTypeTheme + 500) {
        [self performChangeUIThemeWithButtonIndex:buttonIndex];
    } else if (actionSheet.tag == PKActionButtonTypeTxIn + 500) {
        [self performChangePresentationTransitionStyleWithButtonIndex:buttonIndex];
    } else if (actionSheet.tag == PKActionButtonTypeTxOut + 500) {
        [self performChangeDismissTransitionStyleWithButtonIndex:buttonIndex];
    } else if (actionSheet.tag == PKActionButtonTypeAppearInAnimation + 500) {
        [self performChangeViewAppearInAnimationWithButtonIndex:buttonIndex];
    }
}

- (void)performChangeUIThemeWithButtonIndex:(NSInteger)buttonIndex {
    id <PKAlertTheme> theme = nil;
    switch (buttonIndex) {
        case 0:
            theme = [[PKAlertDefaultTheme alloc] init];
            break;
        case 1:
            theme = [[PKAlertWhiteBlueTheme alloc] init];
            break;
        default:
            return;
    }
    [PKAlertThemeManager setRegisterDefaultTheme:theme];
    [self performDisplayAlertAtIndexPath:self.tableView.indexPathsForVisibleRows.firstObject];
}

- (void)performChangePresentationTransitionStyleWithButtonIndex:(NSInteger)buttonIndex {
    PKAlertControllerPresentationTransitionStyle style = (PKAlertControllerPresentationTransitionStyle)buttonIndex;
    self.presentationTransitionStyle = style;
    [self performDisplayAlertAtIndexPath:self.tableView.indexPathsForVisibleRows.firstObject];
}

- (void)performChangeDismissTransitionStyleWithButtonIndex:(NSInteger)buttonIndex {
    PKAlertControllerDismissTransitionStyle style = (PKAlertControllerDismissTransitionStyle)buttonIndex;
    self.dismissTransitionStyle = style;
    [self performDisplayAlertAtIndexPath:self.tableView.indexPathsForVisibleRows.firstObject];
}

- (void)performChangeViewAppearInAnimationWithButtonIndex:(NSInteger)buttonIndex {
    PKAlertControllerViewAppearInAnimationType type = (PKAlertControllerViewAppearInAnimationType)buttonIndex;
    self.viewAppearInAnimationType = type;
    [self performDisplayAlertAtIndexPath:self.tableView.indexPathsForVisibleRows.firstObject];
}

@end
