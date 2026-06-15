import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/start_auction_controller.dart';

class StartAuctionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartAuctionController>(() => StartAuctionController());
  }
}
