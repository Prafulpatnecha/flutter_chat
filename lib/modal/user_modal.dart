class UserModal {
  late String name,email,phoneNo,token,image;

  UserModal({required this.name,required this.email,required this.phoneNo,required this.token,required this.image});
  factory UserModal.fromUser(Map m1)
  {
    return UserModal(name: m1['name'], email: m1["email"], phoneNo: m1["phoneNo"], token: m1["token"], image: m1["image"]);
  }
  Map toMap(UserModal userModal)
  {
    return {
      'email': userModal.email,
      'name': userModal.name,
      'phoneNo': userModal.phoneNo,
      'token': userModal.token,
      'image': userModal.image,
    };
  }
}