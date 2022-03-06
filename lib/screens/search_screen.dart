import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        title: appBarSearch(),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('username',
                      isEqualTo: _searchTextEditingController.text)
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    var user = snapshot.data.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen(
                              uid: snapshot.data.docs[index]['uid'],
                            );
                          },
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(user['photoUrl'])),
                          title: Text(user['username']),
                        ),
                      ),
                    );
                  },
                );
              })
          : const Center(child: Text("Search Screen")),
    );
  }

  Container appBarSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 32, 32),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: _searchTextEditingController,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _searchTextEditingController.clear();
                    isShowUser = false;
                  });
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            hintText: 'Ara',
            contentPadding: const EdgeInsets.all(20.0),
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            _searchTextEditingController.text.trim().isNotEmpty
                ? isShowUser = true
                : false;
          });
        },
      ),
    );
  }
}
