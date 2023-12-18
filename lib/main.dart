import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagination Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginationScreen(),
    );
  }
}

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});

  @override
  _PaginationScreenState createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  List<String> itemList = List.generate(5, (index) => 'Item $index');
  bool isLoading = false;

  Future<void> loadMoreItems() async {
    await Future.delayed(const Duration(seconds: 2));

    List<String> moreItems = List.generate(3, (index) => 'Item ${index + itemList.length}');
    itemList.addAll(moreItems);

    setState(() {
      isLoading = false;
    });
    print("bottom items");
  }

  void _onEndScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
        print("************");
      });
      loadMoreItems();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Example'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onEndScroll(notification);
          return true;
        },
        child: ListView.builder(
          itemCount: itemList.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == itemList.length) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListTile(
                title: Text(itemList[index]),
              );
            }
          },
        ),
      ),
    );
  }
}
