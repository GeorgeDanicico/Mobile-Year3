import 'dart:async';

import 'package:flutter_app/model/Entity.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class AddWidget extends StatelessWidget {
  final Entity? editEntity;

  const AddWidget({Key? key, this.editEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(editEntity == null ? "Add Page" : "Edit Page"),
      ),
      body: Center(child: FormWidget(editEntity: editEntity)),
    );
  }
}

class FormWidget extends StatefulWidget {
  final Entity? editEntity;

  const FormWidget({Key? key, this.editEntity}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    initialValue: widget.editEntity?.description,
                    decoration: const InputDecoration(labelText: "Name"),
                    name: 'name',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Name is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editEntity?.description,
                    decoration: const InputDecoration(labelText: "Description"),
                    name: 'description',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Description is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editEntity?.genre,
                    decoration: const InputDecoration(labelText: "Genre"),
                    name: 'genre',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Genre is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editEntity?.director,
                    decoration: const InputDecoration(labelText: "Director"),
                    name: 'director',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Director is required"),
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editEntity?.year.toString(),
                    decoration: const InputDecoration(labelText: "Year"),
                    name: 'year',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Year is required"),
                      FormBuilderValidators.integer(
                          errorText: "Year must be a number"),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              _dialogBuilder(context, _formKey.currentState);
                            }
                          },
                          child: const Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                          },
                          style: ElevatedButton.styleFrom(),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context, FormBuilderState? state) {
    String content = widget.editEntity == null
        ? 'You are about to add a new movie.\n Do you wish to continue?'
        : 'You are about to edit a movie.\n Do you wish to continue?';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                bool response = false;
                if (state != null) {
                  Entity entity = Entity(
                      state.value["name"],
                      state.value["description"],
                      state.value["genre"],
                      state.value["director"],
                      int.parse(state.value["year"]));
                  response =
                      await Provider.of<EntityService>(context, listen: false)
                          .addEntity(entity);
                  Navigator.of(context).pop();

                  if (response == true) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
