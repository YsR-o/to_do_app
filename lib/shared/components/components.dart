import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/cubit/cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  String? Function(String?)? validate,
  VoidCallback? onTap,
  Function? onChange,
  bool isPassword = false,
  IconData? suffix,
  VoidCallback? suffixPressed,
}) {
  return TextFormField(
    validator: validate,
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onTap: () {
      onTap!();
      print('Taped');
    },
    onChanged: (String s) => onChange!(s),
    decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        ),
        label: Text('$label'),
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder()),
  );
}

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.blue,
          child: Text(
            '${model['time']}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        title: Text('${model['title']}'),
        subtitle: Text('${model['date']}'),
        trailing: Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(Icons.check_box, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(Icons.archive, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
