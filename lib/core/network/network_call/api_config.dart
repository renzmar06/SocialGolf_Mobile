//setting this variable from main or mainDevelopment file
import 'dart:ui';
import 'package:translator/translator.dart';

APIEnvironment environment = APIEnvironment.development;

class ApiConfig {
  static APIEnvironment environment = APIEnvironment.development;

  static String get   domain {
    return environment.domain;
  }

  String? get bearerToken {
    // // var user = await SecureStorageService().getCurrentUser();
    // var user = SharedPrefs().getCurrentUser;
    // // if (user == null) {
    // //   return null;
    // // }
    // debugPrint(user.token, wrapWidth: 1024);
    // log("bearerToken====>${user.token}");
    return ("Bearer }");
  }

  // Category
  String get getHomeFeaturedCategories =>
      '$domain/api/getCategoriesListForWeb';
  String get getBestSellerCategories =>
      '$domain/api/getBestSellerCategoriesForWeb';
  String get getChildCategory => '$domain/api/getChildCategoryForWeb';
  String get getPopularProduct => '$domain/api/getPopularProductForWeb';
  String get getTrendingProduct => '$domain/api/getTrandingProductForApp';
  String get getProductList => '$domain/api/getProductListForWeb?';
  // String get getProductListCategory => '$domain/api/getProductListForWeb?';
  String get sendCustomerRegistrationOTP => '$domain/api/sendCustomerRegistrationOTP';
  String get verifyCustomerRegistrationOtp => '$domain/api/verifyCustomerRegistrationOtp';
  String get customerLogin => '$domain/api/customerLogin';
  String get getProductDetail => '$domain/api/getProductDetailForWeb';
  String get addProductWishlist => '$domain/api/addProductWishlist';
  String get removeProductWishlist => '$domain/api/removeProductWishlist';
  String get getCustomerWishlist => '$domain/api/getCustomerWishlist';
  String get customerForgetPasswordSendOtp => '$domain/api/customerForgetPasswordSendOtp';
  String get customerForgetPasswordVerifyOtp => '$domain/api/customerForgetPasswordVerifyOtp';
  String get customerSetNewPassword => '$domain/api/customerSetNewPassword';
  String get editCustomerDetail => '$domain/api/editCustomerDetail';
  String get editCustomerAddress => '$domain/api/editCustomerAddress';
  String get getCustomerAddress => '$domain/api/getLoginCustomer';
  String get getHomePromotionalBanner => '$domain/api/getHomePromotionalBannerForWeb';
  String get logOut => '$domain/api/logout';
  String get getShippingAddress => '$domain/api/getShippingAddress';
  String get getCartUpdate => '$domain/api/getCartUpdate';
  String get placeOrder => '$domain/api/placeOrder';
  String get confirmOrder => '$domain/api/confirm-order';
  String get createPaymentIntent => '$domain/api/create-payment-intent';
  String get getProductFullReview => '$domain/api/getProductFullReview';
  String get getSingleProductReview => '$domain/api/getSingleProductReview';
  String get getWishlistCount => '$domain/api/getWishlistCount';
  String get getCustomerOrders => '$domain/api/getCustomerOrders';
  String get orderTracking => '$domain/api/order-tracking';
  String get getNotification => '$domain/api/getUnreadNotification';
  String get getAppliedCouponForCustomer => '$domain/api/getAppliedCouponForCustomer';
  String get dashboard => '$domain/api/dashboard';
  String get addReview => '$domain/api/addReview';
  String get wallet => '$domain/api/wallet';
  String get walletAddMoney => '$domain/api/walletAddMoney';
  String get completeWalletPayment => '$domain/api/completeWalletPayment';
  String get saveAffiliateLink => '$domain/api/saveAffiliateLink';
  String get getAffiliateLinks => '$domain/api/getAffiliateLinks';
  String get getUserAddresses => '$domain/api/getUserAddresses';
  String get addUserAddress => '$domain/api/addUserAddress';
  String get setDefaultUserAddress => '$domain/api/setDefaultUserAddress/';
  String get updateUserAddress => '$domain/api/updateUserAddress/';
  String get deleteUserAddress => '$domain/api/deleteUserAddress/';
  String get sendReferralEmail => '$domain/api/sendReferralEmail';
  String get tickets => '$domain/api/chat/customer/tickets';
  String get addChatMessage => '$domain/api/AddChatMessage';
  String get createTicket => '$domain/api/chat/ticket/create';
  String get ticketMessage => '$domain/api/chat/message/add';
  String get homeProductSearch => '$domain/api/homeProductSearch';
  String get updateFcmToken => '$domain/api/updateFcmToken';
  String get markReadNotification => '$domain/api/';

}

String commonDeviceID = "";
String currency = "AED";
final translator = GoogleTranslator();
Locale? commonLocal;

enum APIEnvironment {
  development,
  staging,
  production,
}

extension APIEnvironmentDomain on APIEnvironment {
  String get domain {
    switch (this) {
      case APIEnvironment.development:
        // return "http://65.21.185.41:555/api";
        return "https://herafeen.com";
        // return "https://devherafeen.hiredev.org";
      case APIEnvironment.staging:
        return "";
      case APIEnvironment.production:
        return "";
    }
  }
}
