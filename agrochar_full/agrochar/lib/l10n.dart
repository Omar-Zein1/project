import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void toggle() {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }

  String t(String key) => (isArabic ? _ar : _en)[key] ?? key;
}

const _ar = {
  'app': 'AgroChar',
  'sell_offers': 'عروض البيع',
  'buy_offers': 'عروض الشراء',
  'sell_requests': 'طلبات البيع',
  'buy_requests': 'طلبات الشراء',
  'add_offer': 'إضافة عرض',
  'all_requests': 'كل الطلبات',
  'logout': 'تسجيل الخروج',
  'login': 'تسجيل الدخول',
  'email': 'البريد الإلكتروني',
  'password': 'كلمة المرور',
  'register': 'تسجيل جديد',
  'phone': 'رقم الهاتف',
  'send_code': 'إرسال الرمز',
  'verify': 'تحقق',
  'quantity': 'الكمية',
  'price': 'السعر',
  'unit': 'الوحدة',
  'type': 'النوع',
  'sell': 'بيع',
  'buy': 'شراء',
  'product': 'المنتج',
  'remaining': 'المتبقي',
  'reserve': 'حجز',
  'reserved_ok': 'تم الحجز بنجاح',
  'add': 'إضافة',
  'offer_added': 'تمت إضافة العرض',
  'language': 'اللغة',
};

const _en = {
  'app': 'AgroChar',
  'sell_offers': 'Sell Offers',
  'buy_offers': 'Buy Offers',
  'sell_requests': 'Sell Requests',
  'buy_requests': 'Buy Requests',
  'add_offer': 'Add Offer',
  'all_requests': 'All Requests',
  'logout': 'Logout',
  'login': 'Login',
  'email': 'Email',
  'password': 'Password',
  'register': 'Register',
  'phone': 'Phone',
  'send_code': 'Send Code',
  'verify': 'Verify',
  'quantity': 'Quantity',
  'price': 'Price',
  'unit': 'Unit',
  'type': 'Type',
  'sell': 'Sell',
  'buy': 'Buy',
  'product': 'Product',
  'remaining': 'Remaining',
  'reserve': 'Reserve',
  'reserved_ok': 'Reserved successfully',
  'add': 'Add',
  'offer_added': 'Offer added',
  'language': 'Language',
};
