import 'package:flutter/material.dart';
import 'user.dart';
import 'userService.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = UserService.getAllUsers();
  }

  void reloadUserData() {
    setState(() {
      _futureUsers = UserService.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: _futureUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                            columns: [
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('DOB')),
                              DataColumn(label: Text('Blood Group')),
                              DataColumn(label: Text('Aadhar Number')),
                              DataColumn(label: Text('PAN Number')),
                              DataColumn(label: Text('Account Number')),
                              DataColumn(label: Text('IFSC Code')),
                              DataColumn(label: Text('Branch')),
                              DataColumn(label: Text('Service Experience')),
                              DataColumn(label: Text('UAN Number')),
                              DataColumn(label: Text('ESA Number')),
                              DataColumn(label: Text('Current Address')),
                              DataColumn(label: Text('Permanent Address')),
                            ],
                            rows: snapshot.data!.asMap().entries.map((entry) {
                              final user = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text(user.username)),
                                  DataCell(Text(user.name)),
                                  DataCell(Text(user.dob?.substring(0, 10) ?? '')),
                                  DataCell(Text(user.bloodGroup ?? '')),
                                  DataCell(Text(user.aadharNumber ?? '')),
                                  DataCell(Text(user.panNumber ?? '')),
                                  DataCell(Text(user.accountNumber ?? '')),
                                  DataCell(Text(user.ifscCode ?? '')),
                                  DataCell(Text(user.branch ?? '')),
                                  DataCell(Text(user.serviceExperience ?? '')),
                                  DataCell(Text(user.uanNumber ?? '')),
                                  DataCell(Text(user.esaNumber ?? '')),
                                  DataCell(Text(user.currentAddress ?? '')),
                                  DataCell(Text(user.permanentAddress ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Add New User', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AddUserDialog(),
                );
              },
              tileColor: const Color.fromARGB(255, 196, 212, 224),
              hoverColor: Colors.blue[200],
              leading: Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        label: Text('Logout'),
        icon: Icon(Icons.logout),
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? selectedBloodGroup;
  final TextEditingController aadharNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController serviceExperienceController = TextEditingController();
  final TextEditingController uanNumberController = TextEditingController();
  final TextEditingController esaNumberController = TextEditingController();
  final TextEditingController currentAddressController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();
  bool showWorkExperience = false;
  bool showAccountDetails = false;

  void addUser() async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String name = nameController.text;
    final String dob = dobController.text;
    final String aadharNumber = aadharNumberController.text;
    final String panNumber = panNumberController.text;
    final String accountNumber = accountNumberController.text;
    final String ifscCode = ifscCodeController.text;
    final String branch = branchController.text;
    final String serviceExperience = serviceExperienceController.text;
    final String uanNumber = uanNumberController.text;
    final String esaNumber = esaNumberController.text;
    final String currentAddress = currentAddressController.text;
    final String permanentAddress = permanentAddressController.text;

    if (username.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        dob.isEmpty ||
        aadharNumber.isEmpty ||
        selectedBloodGroup == null
    ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all required fields.'),
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

    try {
      final success = await UserService.signUpUser(
        username,
        password,
        name,
        dob,
        selectedBloodGroup!,
        aadharNumber,
        panNumber,
        accountNumber,
        ifscCode,
        branch,
        serviceExperience,
        uanNumber,
        esaNumber,
        currentAddress,
        permanentAddress,
      );
      if (success) {
        Navigator.of(context).pop();
        final adminPageState = context.findAncestorStateOfType<_AdminDashboardPageState>();
        adminPageState?.reloadUserData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User added successfully!'),
          duration: Duration(seconds: 2),
        ));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('This username already exists.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add user. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              onChanged: (value) {
                setState(() {
                  selectedBloodGroup = value;
                });
              },
              decoration: InputDecoration(labelText: 'Blood Group'),
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: aadharNumberController,
              decoration: InputDecoration(labelText: 'Aadhar Number'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: panNumberController,
              decoration: InputDecoration(labelText: 'PAN Number'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: currentAddressController,
              decoration: InputDecoration(labelText: 'Current Address'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: permanentAddressController,
              decoration: InputDecoration(labelText: 'Permanent Address'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showWorkExperience = !showWorkExperience;
                });
              },
              child: Text('Work Experience'),
            ),
            if (showWorkExperience) ...[
              WorkExperienceForm(
                serviceExperienceController: serviceExperienceController,
                uanNumberController: uanNumberController,
                esaNumberController: esaNumberController,
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAccountDetails = !showAccountDetails;
                });
              },
              child: Text('Account Details'),
            ),
            if (showAccountDetails) ...[
              AccountDetailsForm(
                accountNumberController: accountNumberController,
                ifscCodeController: ifscCodeController,
                branchController: branchController,
              ),
            ],
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkExperienceForm extends StatefulWidget {
  final TextEditingController serviceExperienceController;
  final TextEditingController uanNumberController;
  final TextEditingController esaNumberController;

  WorkExperienceForm({
    required this.serviceExperienceController,
    required this.uanNumberController,
    required this.esaNumberController,
  });

  @override
  _WorkExperienceFormState createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.serviceExperienceController,
          decoration: InputDecoration(labelText: 'Service Experience'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: widget.uanNumberController,
          decoration: InputDecoration(labelText: 'UAN Number'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: widget.esaNumberController,
          decoration: InputDecoration(labelText: 'ESA Number'),
        ),
      ],
    );
  }
}

class AccountDetailsForm extends StatelessWidget {
  final TextEditingController accountNumberController;
  final TextEditingController ifscCodeController;
  final TextEditingController branchController;

  AccountDetailsForm({
    required this.accountNumberController,
    required this.ifscCodeController,
    required this.branchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: accountNumberController,
          decoration: InputDecoration(labelText: 'Account Number'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: ifscCodeController,
          decoration: InputDecoration(labelText: 'IFSC Code'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: branchController,
          decoration: InputDecoration(labelText: 'Branch'),
        ),
      ],
    );
  }
}
