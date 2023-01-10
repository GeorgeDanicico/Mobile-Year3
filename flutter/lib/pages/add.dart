import 'dart:async';

import 'package:flutter_app/model/Product.dart';
import 'package:flutter_app/service/ProductService.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class AddWidget extends StatelessWidget {
  final Product? editProduct;

  const AddWidget({Key? key, this.editProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(editProduct == null ? "Add Page" : "Edit Page"),
      ),
      body: Center(child: FormWidget(editProduct: editProduct)),
    );
  }
}

class FormWidget extends StatefulWidget {
  final Product? editProduct;

  const FormWidget({Key? key, this.editProduct}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  void showErrorDialog() {
    Timer.run(() {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
            title: Text("Error"), content: Text("Invalid serial number.")),
      );
    });
  }

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
                    initialValue: widget.editProduct?.productName,
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                    name: 'productName',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Product Name is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editProduct?.serialNumber,
                    decoration:
                        const InputDecoration(labelText: "Serial Number"),
                    name: 'serialNumber',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Serial Number is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editProduct?.aisle,
                    decoration: const InputDecoration(labelText: "Aisle"),
                    name: 'aisle',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Aisle is required"),
                      FormBuilderValidators.minLength(2)
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editProduct?.price.toString(),
                    decoration: const InputDecoration(labelText: "Price"),
                    name: 'price',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Price is required"),
                      FormBuilderValidators.numeric(
                          errorText: "Price must be a number.")
                    ]),
                  ),
                  FormBuilderTextField(
                    initialValue: widget.editProduct?.quantity.toString(),
                    decoration: const InputDecoration(labelText: "Quantity"),
                    name: 'quantity',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Quantity is required"),
                      FormBuilderValidators.integer(
                          errorText: "Quantity must be a number"),
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
    String content = widget.editProduct == null
        ? 'You are about to add a new product.\n Do you wish to continue?'
        : 'You are about to edit a product.\n Do you wish to continue?';

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
                bool response = true;
                if (state != null) {
                  Product product = Product(
                    state.value["serialNumber"],
                    state.value["productName"],
                    state.value["aisle"],
                    double.parse(state.value["price"]),
                    int.parse(state.value["quantity"]),
                  );
                  if (widget.editProduct == null) {
                    response = await Provider.of<ProductService>(context,
                            listen: false)
                        .addProduct(product);
                  } else {
                    response = await Provider.of<ProductService>(context,
                            listen: false)
                        .editProduct(product, widget.editProduct);
                  }

                  Navigator.of(context).pop();
                }

                if (response == true) {
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
