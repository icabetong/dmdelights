class Profile {
  String lastname;
  String firstname;
  String email;
  String? phone;
  Address? address;

  Profile({
    required this.lastname,
    required this.firstname,
    required this.email,
    this.phone,
    this.address,
  });

  static Map<String, dynamic> toMap(Profile profile) {
    return <String, dynamic>{
      'lastname': profile.lastname,
      'firstname': profile.firstname,
      'email': profile.email,
      'phone': profile.phone,
      'address':
          profile.address != null ? Address.toMap(profile.address!) : null
    };
  }

  static Profile fromMap(Map<String, dynamic> doc) {
    final _address = doc['address'];

    return Profile(
        lastname: doc['lastname'],
        firstname: doc['firstname'],
        email: doc['email'],
        phone: doc['phone'],
        address: _address == null ? null : Address.fromMap(_address));
  }
}

class Address {
  String number;
  String street;
  String? village;
  String city;
  String province;
  int zipcode;

  Address({
    required this.number,
    required this.street,
    this.village,
    required this.city,
    required this.province,
    required this.zipcode,
  });

  static Map<String, dynamic> toMap(Address address) {
    return <String, dynamic>{
      'number': address.number,
      'street': address.street,
      'village': address.village,
      'city': address.city,
      'province': address.province,
      'zipcode': address.zipcode,
    };
  }

  static fromMap(Map<String, dynamic> doc) {
    return Address(
      number: doc['number'],
      street: doc['street'],
      village: doc['village'],
      city: doc['city'],
      province: doc['province'],
      zipcode: int.parse(doc['zipcode']),
    );
  }
}
