class Dummy{

  Dummy._();

  //static const user1 = "https://i.imgur.com/FUKrFeD.jpeg";
  static const user1 = "https://plus.unsplash.com/premium_photo-1756147641535-6232626a4cb8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIyfHRvd0paRnNrcEdnfHxlbnwwfHx8fHw%3D";
  static const user2 = "https://images.unsplash.com/flagged/photo-1573740144655-bbb6e88fb18a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHVzZXJ8ZW58MHx8MHx8fDA%3D";

  static const product1 = "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8d2F0Y2h8ZW58MHx8MHx8fDA%3D";

  static const cover1 = "https://images.unsplash.com/photo-1487088678257-3a541e6e3922?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGNvdmVyfGVufDB8fDB8fHww";
  static const live1 = "https://plus.unsplash.com/premium_photo-1684107940034-a860aae8cb20?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bGl2ZXxlbnwwfHwwfHx8MA%3D%3D";
}

const String roleKey = "roleKey";

//ROLES
enum Role {
  buyer,
  seller;

  static Role fromString(String role) {
    return Role.values.firstWhere(
          (e) => e.name == role.toLowerCase(),
      orElse: () => Role.buyer,
    );
  }

  String toJson() => name;
}