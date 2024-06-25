import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.controller, required this.userName, required this.changeName});
  
  final TextEditingController controller;
  final String userName;
  final Function(String) changeName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          ),
          const ListTile(
            title: Text("User Name", style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: userName,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    changeName(controller.text);
                    controller.clear();
                  },
                  child: const Text(
                    "Change",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const ListTile(
            title: Text("About", style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            title: Text("Developers", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
