import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_employee_controller.dart';

class CreateEmployeeView extends GetView<CreateEmployeeController> {
  const CreateEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: controller.nameEditingController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return controller.validateName(value!);
                  },
                ),
                const SizedBox(height: 16),

                // Department
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller.departmentEditingController,
                  validator: (value) {
                    return controller.validateDepartment(value!);
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Obx(
                      () => !controller.isEdit.value
                          ? (controller.imagePath.value == ''
                              ? const Text(
                                  'Select image from Gallery',
                                  style: TextStyle(fontSize: 20),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: FileImage(
                                    File(controller.imagePath.value),
                                  ),
                                ))
                          : (controller.imagePath.value != ''
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: FileImage(
                                    File(controller.imagePath.value),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: controller.imageUrl.value,
                                  width: 100,
                                  height: 100,
                                )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => controller.selectImage(),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Button
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: context.width),
                  child: ElevatedButton(
                    onPressed: () => controller.validateAndSave(
                        name: controller.nameEditingController.text,
                        department: controller.departmentEditingController.text,
                        isEdit: controller.isEdit.value),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(14)),
                    ),
                    child: const Text(
                      'Create Employee',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
