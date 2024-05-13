import 'package:flutter/material.dart';
import 'userService.dart';
import 'user.dart';
import 'loginPage.dart'; 

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBankDetails = false;
  bool showOtherDetails = true;
  bool showWorkExperience = false;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false, 
      ),
      body: Row(
        children: [
          Container(
            width: 200, 
            color: Colors.grey[200],
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showBankDetails = false;
                        showOtherDetails = true;
                        showWorkExperience = false;
                      });
                    },
                    child: Text('Profile'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showBankDetails = true;
                        showOtherDetails = false;
                        showWorkExperience = false;
                      });
                    },
                    child: Text('Bank Details'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showBankDetails = false;
                        showOtherDetails = false;
                        showWorkExperience = true;
                      });
                    },
                    child: Text('Work Experience'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _logout, 
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 218, 171, 187), 
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8), 
              child: Center(
                child: FutureBuilder<List<User>>(
                  future: UserService.getUsersByUsername(widget.username), 
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<User>? users = snapshot.data;
                      if (users == null || users.isEmpty) {
                        return Text('No users found');
                      }
                      return SingleChildScrollView(
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Field', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            if (showBankDetails)
                              ...users.map((user) {
                                return [
                                  DataRow(cells: [
                                    DataCell(Text('Account Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.accountNumber ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('IFSC Code', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.ifscCode ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Branch', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.branch ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                ];
                              }).expand((element) => element).toList(),
                            if (showOtherDetails)
                              ...users.map((user) {
                                return [
                                  DataRow(cells: [
                                    DataCell(Text('Username', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.username, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Password', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.password, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.name, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.dob?.substring(0, 10) ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Blood Group', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.bloodGroup ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Aadhar Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.aadharNumber ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Pan Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.panNumber ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Current Address', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.currentAddress ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Permanent Address', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.permanentAddress ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                ];
                              }).expand((element) => element).toList(),
                            if (showWorkExperience)
                              ...users.map((user) {
                                return [
                                  DataRow(cells: [
                                    DataCell(Text('Service Experience', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.serviceExperience ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('UAN Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.uanNumber ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('ESA Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(user.esaNumber ?? 'NULL', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ]),
                                ];
                              }).expand((element) => element).toList(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
