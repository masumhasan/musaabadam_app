import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_offer_service.dart';
import 'package:musaab_adam/data/models/offer/offer_model.dart';

class OffersController extends GetxController {
  final RxList<OfferModel> offers = <OfferModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  Future<void> loadOffers() async {
    isLoading.value = true;
    try {
      offers.value = await ApiOfferService.instance.getSellerOffers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load offers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOfferStatus(String offerId, String status) async {
    try {
      await ApiOfferService.instance.updateStatus(offerId, status);
      offers.removeWhere((o) => o.id == offerId);
      Get.snackbar('Success', 'Offer $status successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update offer');
    }
  }
}
