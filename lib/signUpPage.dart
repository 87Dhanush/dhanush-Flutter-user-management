import 'package:flutter/material.dart';
import 'userService.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController aadharNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController currentAddressController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  String? selectedBloodGroup;

  final TextEditingController serviceExperienceController =
      TextEditingController();
  final TextEditingController uanNumberController = TextEditingController();
  final TextEditingController esaNumberController = TextEditingController();

  final TextEditingController accountNumberController =
      TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  bool showWorkExperience = false;
  bool showAccountDetails = false;

  void toggleWorkExperience() {
    setState(() {
      showWorkExperience = !showWorkExperience;
      if (showWorkExperience) {
        showAccountDetails = false;
      }
    });
  }

  void toggleAccountDetails() {
    setState(() {
      showAccountDetails = !showAccountDetails;
      if (showAccountDetails) {
        showWorkExperience = false;
      }
    });
  }

  Future<void> signUp(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String name = nameController.text;
    final String dob = dobController.text;
    final String aadharNumber = aadharNumberController.text;
    final String panNumber = panNumberController.text;
    final String currentAddress = currentAddressController.text;
    final String permanentAddress = permanentAddressController.text;

    if (username.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        dob.isEmpty ||
        aadharNumber.isEmpty ||
        selectedBloodGroup == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all the required fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Date of Birth validation
    if (!isValidDate(dob)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a valid date of birth (YYYY-MM-DD).'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Aadhar Number validation
    if (!isValidAadharNumber(aadharNumber)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a valid Aadhar number.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final success = await UserService.signUpUser(
      username,
      password,
      name,
      dob,
      selectedBloodGroup!,
      aadharNumber,
      panNumber,
      accountNumberController.text,
      ifscCodeController.text,
      branchController.text,
      serviceExperienceController.text,
      uanNumberController.text,
      esaNumberController.text,
      currentAddress,
      permanentAddress,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('The username already exists.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool isValidDate(String input) {
    final pattern = r'^\d{4}-\d{2}-\d{2}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  bool isValidAadharNumber(String input) {
    final pattern = r'^[2-9]{1}[0-9]{3}\s[0-9]{4}\s[0-9]{4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                onChanged: (value) {
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Blood Group *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                items: bloodGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: aadharNumberController,
                decoration: InputDecoration(
                  labelText: 'Aadhar Number *',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: panNumberController,
                decoration: InputDecoration(labelText: 'Pan Number'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: currentAddressController,
                decoration: InputDecoration(labelText: 'Current Address'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: permanentAddressController,
                decoration: InputDecoration(labelText: 'Permanent Address'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: toggleWorkExperience,
                child: Text('Work Experience'),
              ),
              Visibility(
                visible: showWorkExperience,
                child: WorkExperienceForm(
                  serviceExperienceController: serviceExperienceController,
                  uanNumberController: uanNumberController,
                  esaNumberController: esaNumberController,
                  onRollback: () {
                    setState(() {
                      serviceExperienceController.clear();
                      uanNumberController.clear();
                      esaNumberController.clear();
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: toggleAccountDetails,
                child: Text('Account Details'),
              ),
              Visibility(
                visible: showAccountDetails,
                child: AccountDetailsForm(
                  accountNumberController: accountNumberController,
                  ifscCodeController: ifscCodeController,
                  branchController: branchController,
                  onRollback: () {
                    setState(() {
                      accountNumberController.clear();
                      ifscCodeController.clear();
                      branchController.clear();
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => signUp(context),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkExperienceForm extends StatelessWidget {
  final TextEditingController serviceExperienceController;
  final TextEditingController uanNumberController;
  final TextEditingController esaNumberController;
  final VoidCallback? onRollback;

  const WorkExperienceForm({
    required this.serviceExperienceController,
    required this.uanNumberController,
    required this.esaNumberController,
    this.onRollback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Work Experience',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: serviceExperienceController,
          decoration: InputDecoration(
            labelText: 'Service Experience',
          ),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: uanNumberController,
          decoration: InputDecoration(
            labelText: 'UAN Number',
          ),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: esaNumberController,
          decoration: InputDecoration(
            labelText: 'ESA Number',
          ),
        ),
        // SizedBox(height: 10.0),
        // ElevatedButton(
        //   onPressed: onRollback,
        //   child: Text('Rollback'),
        // ),
      ],
    );
  }
}

class AccountDetailsForm extends StatelessWidget {
  final TextEditingController accountNumberController;
  final TextEditingController ifscCodeController;
  final TextEditingController branchController;
  final VoidCallback? onRollback;

  const AccountDetailsForm({
    required this.accountNumberController,
    required this.ifscCodeController,
    required this.branchController,
    this.onRollback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Account Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: accountNumberController,
          decoration: InputDecoration(
            labelText: 'Account Number',
          ),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: ifscCodeController,
          decoration: InputDecoration(
            labelText: 'IFSC Code',
          ),
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: branchController,
          decoration: InputDecoration(
            labelText: 'Branch',
          ),
        ),
      ],
    );
  }
}

