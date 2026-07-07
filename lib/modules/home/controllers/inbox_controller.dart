import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_dm_service.dart';
import 'package:musaab_adam/data/models/message/conversation_model.dart';

class InboxController extends GetxController {
  final RxList<InboxConversationModel> conversations = <InboxConversationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      conversations.value = await ApiDmService.instance.getConversations();
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }
}
