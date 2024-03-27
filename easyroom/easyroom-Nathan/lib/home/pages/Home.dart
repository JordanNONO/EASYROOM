import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget{
  const MainHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MainHomePage();

}

class _MainHomePage extends State<MainHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Francis ALAPHIA", style: TextStyle(fontWeight: FontWeight.w800),),
                  CircleAvatar(backgroundColor: Colors.blue.shade200,child: const Padding(padding:EdgeInsets.all(1),child: Icon(Icons.person,size: 35,),),)
                ],
              ),
              const SizedBox(height: 35,),
              SearchAnchor(builder: (BuildContext context, SearchController controller){
                return SearchBar(
                    hintText: "Dit moi, quelle maison tu veux...",
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                    controller.openView();
                    },
                    onChanged: (_) {
                    controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    );
              }, suggestionsBuilder:  (BuildContext context, SearchController controller){
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              }),
              const SizedBox(height: 20,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Recommander pour vous", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.blue),),
                  Text("Voir plus",style: TextStyle(color: Colors.grey),)
                ],
              ),
              const SizedBox(height: 20,),
              Expanded(child: ListView.builder(itemCount: 5, itemBuilder: (context,index){
                return ListTile(
                  title: Text("Chambre salon + wc douche interne"),
                  leading: Container(child: Image.network("https://images.unsplash.com/photo-1501183638710-841dd1904471?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),),
                  subtitle: Text("Nouvelle construction", style: TextStyle(color: Colors.grey),),
                  trailing: Text("15000 F/mois",style: TextStyle(fontWeight: FontWeight.w700),),
                );
              }))

            ],
          ),
        ),
      ),
    );
  }
}

