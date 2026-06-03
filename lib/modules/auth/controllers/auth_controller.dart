import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController{

  final storage = GetStorage();
  RxBool isSeller = false.obs;
  final String sellerKey = "seller_key";

  @override
  void onInit() {
    isSeller.value = storage.read(sellerKey) ?? false;
    super.onInit();
  }
}