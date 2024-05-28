import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void userSignout() {
    FirebaseAuth.instance.signOut();
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>?> fetchUserDetails() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data();
      } else {
        showErrorMessage('No user details found');
        return null;
      }
    } catch (e) {
      showErrorMessage('$e');
      return null;
    }
  }

  Future<void> deleteUserdata() async {
    try {
      final users = FirebaseAuth.instance.currentUser;

      if (users != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .delete();

        // Optionally, delete the user's authentication account
        await user.delete();

        showErrorMessage("User data deleted successfully");
      } else {
        showErrorMessage("No user is currently signed in");
      }
    } catch (e) {
      showErrorMessage("Failed to delete user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Color.fromARGB(255, 41, 40, 39)),
        ),
        actions: [
          IconButton(onPressed: userSignout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Container(
          height: 250,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: fetchUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Error fetching user details');
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No user details found');
                }
                final userDetails = snapshot.data!;
                final firstName = userDetails['firstName'] ?? 'N/A';
                final lastName = userDetails['lastName'] ?? 'N/A';
                final age = userDetails['age'] ?? 'N/A';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email : ${user.email!}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Name : $firstName  $lastName",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Age : $age",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const SizedBox(width: 100),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Alert"),
                                  content: const Text(
                                      'Are sure you want to delete your data?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Add your delete logic here if necessary
                                        deleteUserdata();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
