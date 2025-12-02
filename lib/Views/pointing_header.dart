import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/pointing_header_vm.dart';

class PointingHeaderView extends StatelessWidget {
  final PointingHeaderViewModel viewModel;
  const PointingHeaderView(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: viewModel.userPoints.map((item) {
            var textController = TextEditingController();
            textController.addListener(() {

              for (var element in viewModel.records) {
                if (textController.text == item.name) { break; }
                element[textController.text] = element[item.name] ?? 0;
                element.remove(item.name);
              }
              item.name = textController.text;
            });
            textController.text = item.name;
            final double itemWidth = (MediaQuery.of(context).size.width -
                    (viewModel.userPoints.length - 1) * 5.0) /
                viewModel.userPoints.length;
            return GestureDetector(
              child: Container(
                width: itemWidth,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: item.color,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ), style: const TextStyle(color: Colors.white, fontSize: 18 ),),
                    Text(item.point.toString(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            );
          }).toList())); // Create a function here to adapt to the parent widget's constraints
  }
}
