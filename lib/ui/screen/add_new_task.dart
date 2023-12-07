import 'package:flutter/material.dart';
import 'package:task_manager/data/network_caller.dart';
import 'package:task_manager/data/network_response.dart';
import 'package:task_manager/data/utility.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary.dart';
import 'package:task_manager/ui/widget/snackbar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, required this.onSave});
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
  final VoidCallback onSave;
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
           const ProfileSummary(),
           Expanded(
               child: BodyBackground(
                 child: Padding(
                   padding: const EdgeInsets.all(24),
                   child: SingleChildScrollView(
                     reverse: true,
                     child: Form(
                       key: _formKey,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                          const SizedBox(height: 48,),
                           Text('Add New Task',style: Theme.of(context).textTheme.titleLarge,),
                           const SizedBox(height: 16,),
                           TextFormField(
                             controller: _titleController,
                             decoration:const InputDecoration(
                               labelText: "Title",
                               hintText: "Title",
                             ),
                             validator: (value){
                               if (value?.trim().isEmpty ?? true) {
                                 return "Enter Value";
                               }
                             },
                           ),
                           const SizedBox(height: 8,),
                           TextFormField(
                             controller: _descriptionController,
                             maxLines:8,
                             decoration:const  InputDecoration(
                               labelText: "Description",
                             ),
                             validator: (value){
                               if (value?.trim().isEmpty ?? true) {
                                 return "Enter Value";
                               }
                             },
                           ),
                           const SizedBox(height: 16,),
                           SizedBox(
                             width: double.infinity,
                             child: Visibility(
                               visible:_inProgress == false,
                               replacement: const Center(child: CircularProgressIndicator(),),
                               child: ElevatedButton(
                                 onPressed: createTask,
                                 child: const Text("Save",style: TextStyle(fontSize: 16),),
                               ),
                             ),
                           )

                         ],
                       ),
                     ),
                   ),
                 ),
               )

           ),

          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      _inProgress = true;
      if(mounted){
        setState(() {});
      }
      final NetworkResponse response = await NetworkCaller()
          .postRequest(Urls.createNewTask,body: {
        "title":_titleController.text.trim(),
        "description":_descriptionController.text.trim(),
        "status":"New"
      });
      _inProgress = false;
      if(mounted){
        setState(() {});
      }

      if(response.isSuccess){
        _titleController.clear();
    _descriptionController.clear();
    widget.onSave();
        if(mounted){
          showSnackbar(context, 'New Task add Successfully!');
        }
      }else{
        if(mounted){
          showSnackbar(context, 'Task create failed! please try again',true);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
