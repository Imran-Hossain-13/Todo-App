import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_project/view/login_screen.dart';
import 'package:tutorial_project/view_model/home_model/home_controller.dart';
import '../components/input_text_field.dart';
import '../components/rounded_button.dart';
import '../utils/Utils.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final updateTitleController = TextEditingController();
  final updateDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ChangeNotifierProvider(
        create: (_)=>HomeController(),
        child: Consumer<HomeController>(
          builder: (context,provider,child){
            return Container(
              color: Colors.orange.shade300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async{
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            preferences.clear();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                          },
                          child: const CircleAvatar(backgroundColor: Colors.white,radius: 30.0,child: Icon(Icons.logout,size: 30.0,),)
                        ),
                        const SizedBox(height: 10.0),
                        const Text('ToDo with NodeJS + Mongodb',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700),),
                        const SizedBox(height: 8.0),
                        Text('${provider.responseData.length} Task',style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: provider.getTodoData(widget.token['_id']),
                      builder: (context,AsyncSnapshot<List<dynamic>> snapshot){
                        if(snapshot.hasData){
                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: provider.responseData.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context,int index){
                                    return Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dismissible: DismissiblePane(onDismissed: () {}),
                                        children: [
                                          SlidableAction(
                                            backgroundColor: const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                            onPressed: (BuildContext context) {
                                              provider.deleteTodoData(context, provider.responseData[index]['_id'],index);
                                            },
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        borderOnForeground: false,
                                        child: ListTile(
                                          onTap: (){
                                            updateAlertBox(provider, index);
                                          },
                                          leading: const Icon(Icons.task),
                                          title: Text('${provider.responseData[index]['title']}'),
                                          subtitle: Text('${provider.responseData[index]['description']}',maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          trailing: const Icon(Icons.arrow_back),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          );
                        }else{
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                            )
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          insertAlertBox();
        },
        backgroundColor: Colors.orange.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Center(child: Icon(Icons.add,color: Colors.white,size: 32,),),
      ),
    );
  }


  void updateAlertBox(provider,index){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text("Update data"),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputTextField(
                  inputController: updateTitleController,
                  hintText: provider.responseData[index]['title'],
                ),
                InputTextField(
                  inputController: updateDescriptionController,
                  hintText: provider.responseData[index]['description'],
                ),
                RoundedButton(
                    title: "Update",
                    loading: provider.loading,
                    onTap: () {
                      provider.setController(provider.responseData[index]['title'], provider.responseData[index]['description']);
                      provider.setController(updateTitleController.text, updateDescriptionController.text);

                      provider.updateTodoData(context,provider.responseData[index]['_id'],provider.updateTitleController,provider.updateDescController);
                      updateTitleController.clear();
                      updateDescriptionController.clear();
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  void insertAlertBox(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text("Enter data"),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputTextField(
                  inputController: titleController,
                  hintText: "Enter title",
                ),
                InputTextField(
                  inputController: descriptionController,
                  hintText: "Enter description",
                ),
                ChangeNotifierProvider(
                  create: (_)=>HomeController(),
                  child: Consumer<HomeController>(
                    builder: (context,provider,child){
                      return RoundedButton(
                          title: "Submit",
                          loading: provider.loading,
                          onTap: () {
                            if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                              provider.storeData(context,widget.token['_id'],titleController.text,descriptionController.text);
                              titleController.clear();
                              descriptionController.clear();
                            } else {
                              Utils.showSnackMessage(context, "Enter title and description");
                            }
                          }
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
