import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnam autem asperiores occaecati labore reprehenderit unde. Quod deleniti possimus illum ipsam est. Possimus veritatis et id nesciunt. Recusandae assumenda veniam deleniti ut reiciendis. Iusto fugit fugiat et aspernatur voluptas dolorum dolore. Sit voluptas quaerat asperiores et autem suscipit doloremque reiciendis. Est quis et provident sunt voluptatem voluptatem porro esse. Sunt ut ipsam sunt quo explicabo eius voluptas eveniet. Neque nostrum architecto sit fuga impedit. Dolore voluptatem harum libero quod sunt possimus. Adipisci numquam adipisci et. Architecto sunt corrupti nihil sequi similique et nisi. Est dolores facere tempore similique itaque provident.'),
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
