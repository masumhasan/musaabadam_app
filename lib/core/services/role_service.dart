import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/app_constants.dart';

class RoleService extends GetxService{

  Future<RoleService> init() async {
    return this;
  }

  final storage = GetStorage();
  late Role role;

  @override
  void onInit() {

    role = getRole();

    super.onInit();
  }


  Role getUpdatedRole(){
    return getRole();
  }

  Role getRole() {

    final roleString = storage.read(roleKey);

    if (roleString == null) {
      return Role.buyer;
    }

    return Role.values.firstWhere(
          (e){
        return e.name == roleString;
      },
      orElse: () => Role.buyer,
    );
  }

  void updateRole(Role newRole) {
    role = newRole;
    storage.write(roleKey, newRole.name);
  }

}