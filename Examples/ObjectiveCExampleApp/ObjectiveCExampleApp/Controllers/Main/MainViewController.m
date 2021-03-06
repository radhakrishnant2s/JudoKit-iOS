//
//  MainViewController.m
//  ObjectiveCExampleApp
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <CoreLocation/CoreLocation.h>
#import <InAppSettingsKit/IASKAppSettingsViewController.h>
#import <InAppSettingsKit/IASKSettingsReader.h>

@import JudoKit_iOS;

#import "DemoFeature.h"
#import "ExampleAppStorage.h"
#import "IASKAppSettingsViewController+Additions.h"
#import "MainViewController.h"
#import "PBBAViewController.h"
#import "PayWithCardTokenViewController.h"
#import "Result.h"
#import "ResultTableViewController.h"
#import "Settings.h"

static NSString *const kShowPbbaScreenSegue = @"showPbbaScreen";
static NSString *const kTokenPaymentsScreenSegue = @"tokenPayments";

@interface MainViewController ()

@property (nonatomic, strong) JudoKit *judoKit;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray<DemoFeature *> *features;
@property (strong, nonatomic) NSSet<NSString *> *settingsToObserve;

@property (nonatomic, assign) BOOL shouldSetupJudoSDK;
@property (nonatomic, strong) NSURL *deepLinkURL;
@end

@implementation MainViewController

// MARK: View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.features = DemoFeature.defaultFeatures;
    self.shouldSetupJudoSDK = YES;
    self.settingsToObserve = [NSSet setWithArray:@[ kSandboxedKey,
                                                    kTokenKey, kSecretKey, kPaymentSessionKey, kSessionTokenKey,
                                                    kIsTokenAndSecretOnKey, kIsPaymentSessionOnKey ]];

    [self requestLocationPermissions];

    self.judoKit = [[JudoKit alloc] initWithAuthorization:Settings.defaultSettings.authorization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.shouldSetupJudoSDK) {
        self.shouldSetupJudoSDK = NO;
        [self setupJudoSDK];
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(settingDidChanged:)
                                               name:kIASKAppSettingChanged
                                             object:nil];
}

- (void)settingDidChanged:(NSNotification *)notification {
    if (![notification.name isEqualToString:kIASKAppSettingChanged]) {
        return;
    }

    IASKAppSettingsViewController *settingsViewController = (IASKAppSettingsViewController *)notification.object;
    NSSet *changes = [NSSet setWithArray:notification.userInfo.allKeys];

    if ([changes intersectsSet:self.settingsToObserve]) {
        self.shouldSetupJudoSDK = YES;
    }

    if ([settingsViewController respondsToSelector:@selector(didChangedSettingsWithKeys:)]) {
        [settingsViewController didChangedSettingsWithKeys:changes.allObjects];
    }
}

// MARK: Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:IASKAppSettingsViewController.class]) {
        IASKAppSettingsViewController *controller = segue.destinationViewController;
        controller.neverShowPrivacySettings = YES;
        [controller updateHiddenKeys];
    }
    if ([segue.destinationViewController isKindOfClass:PBBAViewController.class]) {
        PBBAViewController *controller = segue.destinationViewController;
        controller.judoKit = self.judoKit;
        controller.configuration = self.configuration;
    }
    if ([segue.destinationViewController isKindOfClass:PayWithCardTokenViewController.class]) {
        PayWithCardTokenViewController *controller = segue.destinationViewController;
        controller.judoKit = self.judoKit;
        controller.configuration = self.configuration;
    }
}

// MARK: Setup methods

- (void)setupJudoSDK {
    self.judoKit.isSandboxed = Settings.defaultSettings.isSandboxed;
    self.judoKit.authorization = Settings.defaultSettings.authorization;
}

- (void)requestLocationPermissions {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
}

// MARK: SDK Features

- (void)paymentOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypePayment
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error];
                                 }];
}

- (void)preAuthOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypePreAuth
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error];
                                 }];
}

- (void)createCardTokenOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeRegisterCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error];
                                 }];
}

- (void)checkCardOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeCheckCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error];
                                 }];
}

- (void)saveCardOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeTransactionWithType:JPTransactionTypeSaveCard
                              configuration:self.configuration
                                 completion:^(JPResponse *response, JPError *error) {
                                     [weakSelf handleResponse:response error:error];
                                 }];
}

- (void)applePayPaymentOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeApplePayWithMode:JPTransactionModePayment
                           configuration:self.configuration
                              completion:^(JPResponse *response, JPError *error) {
                                  [weakSelf handleResponse:response error:error];
                              }];
}

- (void)applePayPreAuthOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokeApplePayWithMode:JPTransactionModePreAuth
                           configuration:self.configuration
                              completion:^(JPResponse *response, JPError *error) {
                                  [weakSelf handleResponse:response error:error];
                              }];
}

- (void)paymentMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModePayment
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
                                             [weakSelf handleResponse:response error:error];
                                         }];
}

- (void)preAuthMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModePreAuth
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
                                             [weakSelf handleResponse:response error:error];
                                         }];
}

- (void)pbbaMethodOperation {
    [self performSegueWithIdentifier:kShowPbbaScreenSegue sender:nil];
}

- (void)tokenPaymentsMethodOperation {
    [self performSegueWithIdentifier:kTokenPaymentsScreenSegue sender:nil];
}

- (void)serverToServerMethodOperation {
    __weak typeof(self) weakSelf = self;
    [self.judoKit invokePaymentMethodScreenWithMode:JPTransactionModeServerToServer
                                      configuration:self.configuration
                                         completion:^(JPResponse *response, JPError *error) {
                                             [weakSelf handleResponse:response error:error];
                                         }];
}

- (void)transactionDetailsMethodOperation {
    __block UITextField *textField = [UITextField new];
    __weak typeof(self) weakSelf = self;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Get transaction"
                                                                        message:@"For receipt Id:"
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *buttonOk = [UIAlertAction actionWithTitle:@"Search"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         [weakSelf.judoKit fetchTransactionWithReceiptId:textField.text
                                                                                              completion:^(JPResponse *response, JPError *error) {
                                                                                                  [weakSelf handleResponse:response error:error];
                                                                                              }];
                                                     }];

    UIAlertAction *buttonCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:nil];

    [controller addTextFieldWithConfigurationHandler:^(UITextField *aTextField) {
        textField = aTextField;
        textField.placeholder = @"Receipt ID";
    }];

    [controller addAction:buttonCancel];
    [controller addAction:buttonOk];
    [self presentViewController:controller animated:YES completion:nil];
}

// MARK: Helper methods

- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self displayAlertWithError:error];
        return;
    }

    if (!response) {
        return;
    }

    if ([response.paymentMethod isEqualToString:@"PBBA"] && !response.orderDetails.orderStatus) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [weakSelf presentResultTableViewControllerWithResponse:response];
                             }];
}

- (void)presentResultTableViewControllerWithResponse:(JPResponse *)response {
    Result *result = [Result resultFromObject:response];
    UIViewController *controller = [[ResultTableViewController alloc] initWithResult:result];
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: Lazy properties

- (JPConfiguration *)configuration {
    JPConfiguration *configuration = [[JPConfiguration alloc] initWithJudoID:Settings.defaultSettings.judoId
                                                                      amount:Settings.defaultSettings.amount
                                                                   reference:Settings.defaultSettings.reference];
    configuration.paymentMethods = Settings.defaultSettings.paymentMethods;
    configuration.uiConfiguration.isAVSEnabled = Settings.defaultSettings.isAVSEnabled;
    configuration.uiConfiguration.shouldPaymentMethodsDisplayAmount = Settings.defaultSettings.shouldPaymentMethodsDisplayAmount;
    configuration.uiConfiguration.shouldPaymentButtonDisplayAmount = Settings.defaultSettings.shouldPaymentButtonDisplayAmount;
    configuration.uiConfiguration.shouldPaymentMethodsVerifySecurityCode = Settings.defaultSettings.shouldPaymentMethodsVerifySecurityCode;
    configuration.supportedCardNetworks = Settings.defaultSettings.supportedCardNetworks;
    configuration.applePayConfiguration = self.applePayConfiguration;

    configuration.pbbaConfiguration = [JPPBBAConfiguration configurationWithDeeplinkScheme:@"judo://pay" andDeeplinkURL:self.deepLinkURL];

    return configuration;
}

- (JPApplePayConfiguration *)applePayConfiguration {

    NSDecimalNumber *itemOnePrice = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    NSDecimalNumber *itemTwoPrice = [NSDecimalNumber decimalNumberWithString:@"0.02"];
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"0.03"];

    NSArray *items = @[ [JPPaymentSummaryItem itemWithLabel:@"Item 1" amount:itemOnePrice],
                        [JPPaymentSummaryItem itemWithLabel:@"Item 2"
                                                     amount:itemTwoPrice],
                        [JPPaymentSummaryItem itemWithLabel:@"Tim Apple"
                                                     amount:totalPrice] ];

    JPApplePayConfiguration *configuration = [[JPApplePayConfiguration alloc] initWithMerchantId:Settings.defaultSettings.applePayMerchantId
                                                                                        currency:Settings.defaultSettings.amount.currency
                                                                                     countryCode:@"GB"
                                                                             paymentSummaryItems:items];
    configuration.requiredShippingContactFields = JPContactFieldAll;
    configuration.requiredBillingContactFields = JPContactFieldAll;
    configuration.returnedContactInfo = JPReturnedInfoAll;
    configuration.shippingMethods = @[ [[JPPaymentShippingMethod alloc] initWithIdentifier:@"method"
                                                                                    detail:@"details"
                                                                                     label:@"label"
                                                                                    amount:totalPrice
                                                                                      type:JPPaymentSummaryItemTypeFinal] ];
    return configuration;
}

@end

@implementation MainViewController (TableViewDelegates)

// MARK: UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.features.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Features";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"To view test card details:\nSign in to judo and go to Developer/Tools.";
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DemoFeature *option = self.features[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:option.cellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = option.title;
    cell.detailTextLabel.text = option.details;
    return cell;
}

// MARK: UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoFeature *feature = self.features[indexPath.row];
    switch (feature.type) {
        case DemoFeatureTypePayment:
            [self paymentOperation];
            break;

        case DemoFeatureTypePreAuth:
            [self preAuthOperation];
            break;

        case DemoFeatureTypeCreateCardToken:
            [self createCardTokenOperation];
            break;

        case DemoFeatureTypeSaveCard:
            [self saveCardOperation];
            break;

        case DemoFeatureTypeCheckCard:
            [self checkCardOperation];
            break;

        case DemoFeatureTypeApplePayPayment:
            [self applePayPaymentOperation];
            break;

        case DemoFeatureTypeApplePayPreAuth:
            [self applePayPreAuthOperation];
            break;

        case DemoFeatureTypePaymentMethods:
            [[ExampleAppStorage sharedInstance] persistLastUsedFeature:DemoFeatureTypePaymentMethods];
            [self paymentMethodOperation];
            break;

        case DemoFeatureTypePreAuthMethods:
            [self preAuthMethodOperation];
            break;

        case DemoFeatureTypeServerToServer:
            [self serverToServerMethodOperation];
            break;

        case DemoFeatureTypePBBA:
            [self pbbaMethodOperation];
            break;

        case DemoFeatureTokenPayments:
            [self tokenPaymentsMethodOperation];
            break;

        case DemoFeatureGetTransactionDetails:
            [self transactionDetailsMethodOperation];
            break;
    }
}

- (void)openPBBAScreen:(NSURL *)url {

    self.deepLinkURL = url;
    self.judoKit = [[JudoKit alloc] initWithAuthorization:Settings.defaultSettings.authorization];
    self.judoKit.isSandboxed = Settings.defaultSettings.isSandboxed;

    [self.judoKit invokePBBAWithConfiguration:self.configuration
                                   completion:^(JPResponse *response, JPError *error) {
                                       self.deepLinkURL = nil;
                                       [self handleResponse:response error:error];
                                   }];
}

@end
