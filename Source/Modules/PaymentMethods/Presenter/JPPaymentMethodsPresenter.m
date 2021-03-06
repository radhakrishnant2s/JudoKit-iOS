//
//  JPPaymentMethodsPresenter.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPPaymentMethodsPresenter.h"
#import "JPAmount.h"
#import "JPCardNetwork.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPIDEALBank.h"
#import "JPIDEALService.h"
#import "JPPBBAConfiguration.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodsInteractor.h"
#import "JPPaymentMethodsRouter.h"
#import "JPPaymentMethodsViewController.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPStoredCardDetails.h"
#import "NSString+Additions.h"

@interface JPPaymentMethodsPresenterImpl ()
@property (nonatomic, strong) JPPaymentMethodsViewModel *viewModel;
@property (nonatomic, strong) JPPaymentMethodsHeaderModel *headerModel;
@property (nonatomic, strong) JPPaymentMethodsSelectionModel *paymentSelectionModel;
@property (nonatomic, strong) JPPaymentMethodsEmptyListModel *emptyListModel;
@property (nonatomic, strong) JPPaymentMethodsCardHeaderModel *cardHeaderModel;
@property (nonatomic, strong) JPPaymentMethodsCardFooterModel *cardFooterModel;
@property (nonatomic, strong) JPPaymentMethodsCardListModel *cardListModel;
@property (nonatomic, strong) JPPaymentMethodsIDEALBankListModel *bankListModel;
@property (nonatomic, strong) JPTransactionButtonViewModel *paymentButtonModel;

@property (nonatomic, assign) NSUInteger previousSectionIndex;
@property (nonatomic, assign) NSUInteger selectedSectionIndex;

@property (nonatomic, assign) NSUInteger selectedBankIndex;
@property (nonatomic, strong) NSArray<JPPaymentMethod *> *paymentMethods;
@property (nonatomic, strong) JPConfiguration *configuration;

@end

@implementation JPPaymentMethodsPresenterImpl

#pragma mark - Initializers
- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - Protocol Conformance

- (void)viewModelNeedsUpdate {
    [self updateViewModelWithAnimationType:JPAnimationTypeSetup];
    [self.view configureWithViewModel:self.viewModel
                  shouldAnimateChange:NO];
    [self checkIfDeeplinkURLExist];
}

- (void)checkIfDeeplinkURLExist {
    if ([self.configuration.pbbaConfiguration hasDeepLinkURL]) {
        NSInteger pbbaIndex = [self.interactor indexOfPBBAMethod];
        if (pbbaIndex != NSNotFound) {
            [self changePaymentMethodToIndex:pbbaIndex];
            __weak typeof(self) weakSelf = self;
            [self.interactor pollingPBBAWithCompletion:^(JPResponse *response, NSError *error) {
                [weakSelf handleCallbackWithResponse:response andError:error];
            }];
        }
    }
}

- (void)viewModelNeedsUpdateWithAnimationType:(JPAnimationType)animationType
                          shouldAnimateChange:(BOOL)shouldAnimate {

    [self updateViewModelWithAnimationType:animationType];
    [self.view configureWithViewModel:self.viewModel
                  shouldAnimateChange:shouldAnimate];
}

- (void)didSelectCardAtIndex:(NSUInteger)index
               isEditingMode:(BOOL)isEditing {

    if (isEditing) {
        [self.router navigateToCardCustomizationWithIndex:index];
        return;
    }

    [self.interactor selectCardAtIndex:index];

    JPAnimationType animationType;
    animationType = self.headerModel.cardModel ? JPAnimationTypeBottomToTop : JPAnimationTypeSetup;

    [self viewModelNeedsUpdateWithAnimationType:animationType
                            shouldAnimateChange:YES];
}

- (void)didSelectBankAtIndex:(NSUInteger)index {
    self.selectedBankIndex = index;
    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeBottomToTop
                            shouldAnimateChange:YES];
}

#pragma mark - Action Handlers

- (void)handleAddCardButtonTap {
    [self.router navigateToTransactionModuleWith:JPCardDetailsModeDefault
                                     cardNetwork:self.selectedCard.cardNetwork
                              andTransactionType:JPTransactionTypeSaveCard];
}

- (void)handleBackButtonTap {
    [self.interactor completeTransactionWithResponse:nil
                                            andError:JPError.judoUserDidCancelError];
    [self.router dismissViewController];
}

- (void)handlePayButtonTap {

    __weak typeof(self) weakSelf = self;

    if (self.paymentSelectionModel.selectedPaymentMethod == JPPaymentMethodTypeIDeal) {

        NSArray *bankTypes = [self.interactor getIDEALBankTypes];
        NSNumber *numberValue = bankTypes[self.selectedBankIndex];
        JPIDEALBankType bankType = (JPIDEALBankType)numberValue.intValue;
        JPIDEALBank *iDEALBank = [JPIDEALBank bankWithType:bankType];

        [self.router navigateToIDEALModuleWithBank:iDEALBank
                                     andCompletion:^(JPResponse *response, NSError *error) {
                                         [weakSelf handleIDEALCallbackWithResponse:response andError:error];
                                     }];
        return;
    }

    if (self.paymentSelectionModel.selectedPaymentMethod == JPPaymentMethodTypePbba) {
        [self.interactor openPBBAWithCompletion:^(JPResponse *response, NSError *error) {
            [weakSelf handleCallbackWithResponse:response andError:error];
        }];
        return;
    }

    if ([self.interactor shouldVerifySecurityCode]) {
        [self.router navigateToTransactionModuleWith:JPCardDetailsModeSecurityCode cardNetwork:self.selectedCard.cardNetwork andTransactionType:JPTransactionTypePayment];
    } else {
        [self handlePaymentWithSecurityCode:nil];
    }
}

- (void)handlePaymentWithSecurityCode:(nullable NSString *)code {
    __weak typeof(self) weakSelf = self;
    [self.interactor paymentTransactionWithToken:self.selectedCard.cardToken
                                 andSecurityCode:code
                                   andCompletion:^(JPResponse *response, NSError *error) {
                                       [weakSelf handleCallbackWithResponse:response
                                                                   andError:error];
                                   }];
}

- (void)handleApplePayButtonTap {
    __weak typeof(self) weakSelf = self;
    [self.view presentApplePayWithAuthorizationBlock:^(PKPayment *payment, JPApplePayAuthStatusBlock completion) {
        [self.interactor processApplePayment:payment
                              withCompletion:^(JPResponse *response, JPError *error) {
                                  if (error) {
                                      completion(PKPaymentAuthorizationStatusFailure);
                                  }

                                  completion(PKPaymentAuthorizationStatusSuccess);
                                  [weakSelf handleCallbackWithResponse:response andError:error];
                              }];
    }];
}

- (void)handlePaymentResponse:(JPResponse *)response {
    NSInteger selectedCardIndex = [self indexOfSelectedCard];
    if (selectedCardIndex >= 0) {
        [self.interactor setLastUsedCardAtIndex:selectedCardIndex];
    }
    [self.interactor completeTransactionWithResponse:response andError:nil];
    [self.router dismissViewController];
}

- (void)handlePaymentError:(NSError *)error {

    if (error.code == Judo3DSRequestError) {
        [self handle3DSecureTransactionWithError:error];
        return;
    }

    [self.interactor storeError:error];
    [self.view displayAlertWithTitle:@"transaction_unsuccessful".localized andError:error];
}

- (void)handle3DSecureTransactionWithError:(NSError *)error {

    __weak typeof(self) weakSelf = self;
    [self.interactor handle3DSecureTransactionFromError:error
                                             completion:^(JPResponse *response, NSError *transactionError) {
                                                 if (error) {
                                                     [weakSelf handlePaymentError:transactionError];
                                                     return;
                                                 }
                                                 [weakSelf handlePaymentResponse:response];
                                             }];
}

- (void)deleteCardWithIndex:(NSUInteger)index {
    NSArray *storedCards = [self.interactor getStoredCardDetails];
    JPStoredCardDetails *selectedCard = storedCards[index];

    [self.interactor deleteCardWithIndex:index];
    [self.cardListModel.cardModels removeObjectAtIndex:index];
    self.viewModel.headerModel.cardModel = nil;

    if (selectedCard.isSelected && storedCards.count - 1 > 0) {
        [self.interactor setCardAsSelectedAtIndex:0];
    }
    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeBottomToTop
                            shouldAnimateChange:YES];
}

- (void)changeHeaderButtonTitle:(BOOL)isEditing {
    NSString *title = isEditing ? @"button_done" : @"button_edit";
    self.cardHeaderModel.editButtonTitle = title.localized.uppercaseString;

    [self viewModelNeedsUpdateWithAnimationType:JPAnimationTypeNone
                            shouldAnimateChange:NO];
}

- (void)changePaymentMethodToIndex:(NSUInteger)index {

    if (index == self.previousSectionIndex) {
        return;
    }

    JPAnimationType animationType = JPAnimationTypeLeftToRight;

    if (index < self.previousSectionIndex) {
        animationType = JPAnimationTypeRightToLeft;
    }

    JPPaymentMethod *previousMethod = self.paymentSelectionModel.paymentMethods[self.previousSectionIndex];
    if (previousMethod.type == JPPaymentMethodTypeCard && self.cardListModel.cardModels.count == 0) {
        animationType = JPAnimationTypeSetup;
    }

    self.previousSectionIndex = index;
    self.selectedSectionIndex = index;

    self.paymentSelectionModel.selectedIndex = index;
    self.paymentSelectionModel.selectedPaymentMethod = self.paymentMethods[index].type;

    [self viewModelNeedsUpdateWithAnimationType:animationType
                            shouldAnimateChange:YES];
}

- (void)orderCards {
    [self.interactor orderCards];
}

#pragma mark - Helper methods

- (void)handleIDEALCallbackWithResponse:(JPResponse *)response
                               andError:(NSError *)error {
    if (error) {
        [self handlePaymentError:error];
        return;
    }
    [self.interactor completeTransactionWithResponse:response andError:nil];
    [self.router dismissViewController];
}

- (void)handleCallbackWithResponse:(JPResponse *)response
                          andError:(NSError *)error {
    if (error) {
        [self handlePaymentError:error];
        return;
    }
    [self handlePaymentResponse:response];
}

- (void)setLastAddedCardAsSelected {
    NSArray *cards = [self.interactor getStoredCardDetails];
    [self.interactor setCardAsSelectedAtIndex:cards.count - 1];
}

- (void)updateViewModelWithAnimationType:(JPAnimationType)animationType {
    [self.viewModel.items removeAllObjects];

    [self prepareHeaderModel];
    self.viewModel.headerModel.animationType = animationType;
    [self preparePaymentMethodModels];
}

- (void)preparePaymentMethodModels {

    self.paymentSelectionModel.paymentMethods = self.paymentMethods;

    if (self.paymentMethods.count > 1) {
        [self.viewModel.items addObject:self.paymentSelectionModel];
    }

    self.viewModel.headerModel.paymentMethodType = self.paymentSelectionModel.selectedPaymentMethod;
    self.viewModel.headerModel.isApplePaySetUp = [self.interactor isApplePaySetUp];

    switch (self.paymentSelectionModel.selectedPaymentMethod) {
        case JPPaymentMethodTypeCard:
            [self prepareCardListModels];
            break;
        case JPPaymentMethodTypeApplePay:
            break;
        case JPPaymentMethodTypeIDeal:
            [self prepareIDEALBankListModel];
            break;
        default:
            break;
    }
}

- (void)prepareCardListModels {
    NSArray<JPStoredCardDetails *> *cardDetailsArray = [self.interactor getStoredCardDetails];

    if (cardDetailsArray.count == 0) {
        [self.viewModel.items addObject:self.emptyListModel];
    } else {
        [self prepareCardModelsForStoredCardDetails:cardDetailsArray];
        [self.viewModel.items addObject:self.cardHeaderModel];
        [self.viewModel.items addObject:self.cardListModel];
        [self.viewModel.items addObject:self.cardFooterModel];
    }
}

- (void)prepareIDEALBankListModel {
    [self.bankListModel.bankModels removeAllObjects];
    NSArray *iDEALBankTypes = [self.interactor getIDEALBankTypes];
    for (NSNumber *type in iDEALBankTypes) {
        JPPaymentMethodsIDEALBankModel *bankModel = [self iDEALBankModelForType:type.intValue];
        [self.bankListModel.bankModels addObject:bankModel];
    }

    JPPaymentMethodsIDEALBankModel *bankModel = self.bankListModel.bankModels[self.selectedBankIndex];
    bankModel.isSelected = YES;

    [self.viewModel.items addObject:self.bankListModel];
    self.headerModel.bankModel = bankModel;
}

- (void)prepareHeaderModel {
    self.headerModel.amount = [self.interactor getAmount];
    self.headerModel.payButtonModel = self.paymentButtonModel;
    self.headerModel.payButtonModel.isEnabled = NO;
    NSArray *storedCardDetails = [self.interactor getStoredCardDetails];

    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        if (cardDetails.isSelected) {
            self.headerModel.cardModel = [self cardModelFromStoredCardDetails:cardDetails];
            BOOL isCardExpired = self.headerModel.cardModel.cardExpirationStatus != JPCardExpirationStatusExpired;
            self.headerModel.payButtonModel.isEnabled = isCardExpired;
        }
    }

    if (self.paymentSelectionModel.selectedPaymentMethod == JPPaymentMethodTypeIDeal ||
        self.paymentSelectionModel.selectedPaymentMethod == JPPaymentMethodTypePbba) {
        self.headerModel.payButtonModel.isEnabled = YES;
    }

    self.viewModel.headerModel = self.headerModel;
}

- (void)prepareCardModelsForStoredCardDetails:(NSArray<JPStoredCardDetails *> *)storedCardDetails {
    [self.cardListModel.cardModels removeAllObjects];
    for (JPStoredCardDetails *cardDetails in storedCardDetails) {
        JPPaymentMethodsCardModel *cardModel = [self cardModelFromStoredCardDetails:cardDetails];
        [self.cardListModel.cardModels addObject:cardModel];
    }
}

- (JPPaymentMethodsCardModel *)cardModelFromStoredCardDetails:(JPStoredCardDetails *)cardDetails {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];
    cardModel.cardTitle = cardDetails.cardTitle;
    cardModel.cardNetwork = cardDetails.cardNetwork;
    cardModel.cardNumberLastFour = cardDetails.cardLastFour;
    cardModel.cardExpiryDate = cardDetails.expiryDate;
    cardModel.cardPatternType = cardDetails.patternType;
    cardModel.isDefaultCard = cardDetails.isDefault;
    cardModel.isSelected = cardDetails.isSelected;
    cardModel.cardExpirationStatus = cardDetails.expirationStatus;
    return cardModel;
}

- (JPStoredCardDetails *)selectedCard {
    for (JPStoredCardDetails *card in [self.interactor getStoredCardDetails]) {
        if (card.isSelected) {
            return card;
        }
    }
    return nil;
}

- (NSInteger)indexOfSelectedCard {
    NSInteger cardIndex = 0;
    for (JPStoredCardDetails *card in [self.interactor getStoredCardDetails]) {
        if (card.isSelected) {
            return cardIndex;
        }
        cardIndex++;
    }
    return -1;
}

- (JPPaymentMethodsIDEALBankModel *)iDEALBankModelForType:(JPIDEALBankType)type {
    JPIDEALBank *bank = [JPIDEALBank bankWithType:type];
    JPPaymentMethodsIDEALBankModel *bankModel = [JPPaymentMethodsIDEALBankModel new];
    bankModel.bankTitle = bank.title;
    bankModel.bankIconName = bank.iconName;
    return bankModel;
}

#pragma mark - Lazy properties

- (JPPaymentMethodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [JPPaymentMethodsViewModel new];
        _viewModel.items = [NSMutableArray new];
    }
    return _viewModel;
}

- (JPPaymentMethodsHeaderModel *)headerModel {
    if (!_headerModel) {
        _headerModel = [JPPaymentMethodsHeaderModel new];
        _headerModel.amount = [JPAmount amount:@"0.0" currency:@"GBP"];
    }
    return _headerModel;
}

- (JPPaymentMethodsSelectionModel *)paymentSelectionModel {
    if (!_paymentSelectionModel) {
        _paymentSelectionModel = [JPPaymentMethodsSelectionModel new];
        _paymentSelectionModel.identifier = @"JPPaymentMethodsSelectionCell";
        _paymentSelectionModel.selectedPaymentMethod = self.paymentMethods.firstObject.type;
    }
    return _paymentSelectionModel;
}

- (JPPaymentMethodsEmptyListModel *)emptyListModel {
    if (!_emptyListModel) {
        _emptyListModel = [JPPaymentMethodsEmptyListModel new];
        _emptyListModel.identifier = @"JPPaymentMethodsEmptyCardListCell";
        _emptyListModel.title = @"no_connected_cards".localized;
        _emptyListModel.addCardButtonTitle = @"add_card".localized.uppercaseString;
        _emptyListModel.addCardButtonIconName = @"plus-icon";

        __weak typeof(self) weakSelf = self;
        _emptyListModel.onTransactionButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _emptyListModel;
}

- (JPPaymentMethodsCardHeaderModel *)cardHeaderModel {
    if (!_cardHeaderModel) {
        _cardHeaderModel = [JPPaymentMethodsCardHeaderModel new];
        _cardHeaderModel.title = @"connected_cards".localized;
        _cardHeaderModel.editButtonTitle = @"button_edit".localized.uppercaseString;
        _cardHeaderModel.identifier = @"JPPaymentMethodsCardListHeaderCell";
    }
    return _cardHeaderModel;
}

- (JPPaymentMethodsCardFooterModel *)cardFooterModel {
    if (!_cardFooterModel) {
        _cardFooterModel = [JPPaymentMethodsCardFooterModel new];
        _cardFooterModel.addCardButtonTitle = @"add_card".localized.uppercaseString;
        _cardFooterModel.addCardButtonIconName = @"plus-icon";
        _cardFooterModel.identifier = @"JPPaymentMethodsCardListFooterCell";

        __weak typeof(self) weakSelf = self;
        _cardFooterModel.onTransactionButtonTapHandler = ^{
            [weakSelf handleAddCardButtonTap];
        };
    }
    return _cardFooterModel;
}

- (JPPaymentMethodsCardListModel *)cardListModel {
    if (!_cardListModel) {
        _cardListModel = [JPPaymentMethodsCardListModel new];
        _cardListModel.cardModels = [NSMutableArray new];
        _cardListModel.identifier = @"JPPaymentMethodsCardCell";
    }
    return _cardListModel;
}

- (JPPaymentMethodsCardModel *)cardModel {
    JPPaymentMethodsCardModel *cardModel = [JPPaymentMethodsCardModel new];
    return cardModel;
}

- (JPTransactionButtonViewModel *)paymentButtonModel {
    if (!_paymentButtonModel) {
        _paymentButtonModel = [JPTransactionButtonViewModel new];
        _paymentButtonModel.title = @"pay_now".localized.uppercaseString;
        _paymentButtonModel.isEnabled = NO;
    }
    return _paymentButtonModel;
}

- (JPPaymentMethodsIDEALBankListModel *)bankListModel {
    if (!_bankListModel) {
        _bankListModel = [JPPaymentMethodsIDEALBankListModel new];
        _bankListModel.bankModels = [NSMutableArray new];
        _bankListModel.identifier = @"JPPaymentMethodsIDEALBankCell";
    }
    return _bankListModel;
}

- (NSArray<JPPaymentMethod *> *)paymentMethods {
    if (!_paymentMethods) {
        _paymentMethods = [self.interactor getPaymentMethods];
    }
    return _paymentMethods;
}

@end
