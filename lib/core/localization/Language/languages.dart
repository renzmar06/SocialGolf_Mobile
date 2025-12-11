import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages)!;
  }

  String get onBoardingTitle1;

  String get onBoardingTitle2;

  String get onBoardingTitle3;

  String get onBoardingSubTitle1;

  String get onBoardingSubTitle2;

  String get onBoardingSubTitle3;

  String get ratingReviews;

  String get productDetails;

  String get overallRating;

  String get firstName;

  String get lastName;

  String get mobileNo;

  String get email;

  String get enterEmail;

  String get enterPassword;

  String get password;

  String get newPassword;

  String get confirmPassword;

  String get forgotPassword;

  String get registerNow;

  String get loginNow;

  String get alreadyHaveAnAccount;

  String get dontHaveAnAccount;

  String get loginHeader;

  String get registerHeader;

  String get forgotPasswordMsg;

  String get rememberPassword;

  String get verification;

  String get continueText;

  String get sentResetCodeIn;

  String get resendCode;

  String get verificationCode;

  String get sendCode;

  String get login;

  String get register;

  String get areYouSureYouWantToLogout;

  String get logout;

  String get cancel;

  String get yesLogout;

  String get saved;

  String get addToCart;

  String get goToCheckOut;

  String get removeFromCart;

  String get yesRemove;

  String get placeOrder;

  String get congratulations;

  String get savedCards;

  String get yourProfile;

  String get myOrder;

  String get paymentMethod;

  String get notifications;

  String get privacyPolicy;

  String get helpCenter;

  String get inviteFried;

  String get fullName;

  String get emailAddress;

  String get dateOfBirth;

  String get gender;

  String get phoneNumber;

  String get add;

  String get accountDetails;

  String get myAddress;

  String get myOrders;

  String get trackYourOrder;

  String get dashboard;

  String get subTotal;

  String get redeemPoints;

  String get deliveryFee;

  String get discount;

  String get total;

  String get location;

  String get categories;

  String get viewAll;

  String get hotDeals;

  String get trendingProducts;

  String get seeAll;

  String get findYourFavoriteItems;

  String get purchaseHistory;

  String get myWishlist;

  String get recentOrder;

  String get productInCart;

  String get trackOrdersMsg;

  String get orderId;

  String get track;

  String get deliveryAddress;

  String get orderSummary;

  String get change;

  String get home;

  String get card;

  String get cash;

  String get pay;

  String get enterPromoCode;

  String get yourOrderHasBeenPlaced;

  String get addNewCard;

  String get apply;

  String get remove;

  String get defaultTxt;

  String get clearAll;

  String get popularSearches;

  String get skip;

  String get yourCartIsEmpty;

  String get outOfStock;

  String get gotToCart;

  String get resetPassword;

  String get submit;

  String get addressSaved;

  String get addressRequired;

  String get cityRequired;

  String get zipRequired;

  String get billingAddress;

  String get shippingAddress;

  String get edit;

  String get no;

  String get yes;

  String get address;

  String get city;

  String get country;

  String get zip;

  String get noReviewsYet;

  String get rating;

  String get ratings;

  String get review;

  String get reviews;

  String get trackingInfo;

  String get orderNumberLabel;

  String get trackingNumberLabel;

  String get statusLabel;

  String get detailsLabel;

  String get lastUpdatedLabel;

  String get createdAtLabel;

  String get continueShopping;

  String get close;

  String get orderDetails;

  String get shipmentProgress;

  String get courier;

  String get anErrorOccurred;

  String get youHaveTo;

  String get toAddAReview;

  String get unitedArabEmirates;

  String get rememberMe;

  String get addReferral;

  String get addReferralMsg;

  String get referralCode;

  String get submitReview;

  String get wallet;

  String get addFundsToYourWallet;

  String get amountAED;

  String get affiliation;

  String get generateAffiliateLink;

  String get generate;

  String get redeem;

  String get tickets;

  String get viewMessages;

  String get enterYourRedeemAmount;

  String get enterEmailAddress;

  String get sendEmail;

  String get enterEmailsSeparatedByCommas;

  String get noSearchResultFound;

  String get goToHerafeen;

  String get or;

  String get myAccount;

  String get visitWebVersionText;

  String get invalidFormatMessage;

  String get emailNotFound;

  String get loginFailed;

  String get registrationFailed;

  String get failedToResetPassword;

  String get verificationFailed;

  String get myCart;

  String get category;

  String get herafeenChatbot;

  String get botMsgWhenNotLoggedIn;

  String get maybeLater;

  String get botMsgWhenLoggedIn;

  String get orderIssues;

  String get productIssues;

  String get refundIssues;

  String get deliveryIssues;

  String get ticketCheck;

  String get wouldYouLikeToContinueOrClose;

  String get writeAComment;

  String get checkout;
}
