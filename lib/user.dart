
class User {
  final String username;
  final String password;
  final String name;
  final String? dob;
  final String? bloodGroup;
  final String? aadharNumber;
  final String? panNumber;
  final String? accountNumber;
  final String? ifscCode;
  final String? branch;
  final String? qualification;
  final String? serviceExperience;
  final String? uanNumber;
  final String? esaNumber;
  final String? currentAddress;
  final String? permanentAddress;

  User({
    required this.username,
    required this.password,
    required this.name,
    this.dob,
    this.bloodGroup,
    this.aadharNumber,
    this.panNumber,
    this.accountNumber,
    this.ifscCode,
    this.branch,
    this.qualification,
    this.serviceExperience,
    this.uanNumber,
    this.esaNumber,
    this.currentAddress,
    this.permanentAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      aadharNumber: json['aadhar_number'],
      panNumber: json['pan_number'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      branch: json['branch'],
      qualification: json['qualification'],
      serviceExperience: json['service_experience'],
      uanNumber: json['uan_number'],
      esaNumber: json['esa_number'],
      currentAddress: json['current_address'],
      permanentAddress: json['permanent_address'],
    );
  }
}
