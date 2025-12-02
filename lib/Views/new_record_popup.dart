import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';

// ignore: must_be_immutable
class NewRecordPopup extends StatelessWidget {
  NewRecordPopUpViewModel viewModel;
  NewRecordPopup(this.viewModel, {super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.black38, borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  child: CupertinoButton(
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              Column( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: viewModel.records.entries
                        .map((e) => buildRecordRow(e.key))
                        .toList(),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(onPressed: () {
                    if (!viewModel.isAllZeroValue()) {
                      viewModel.callback(viewModel.records);
                      Navigator.of(context).pop();
                    }
                  }, child: const Text('Save'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecordRow(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0),
      child: Obx(
        () => GestureDetector(
          onTap: () => viewModel.setWinner(name),
          child: Container(
            decoration: BoxDecoration(
                color: viewModel.records[name]!.isWinner
                    ? Colors.yellow[100]
                    : Colors.grey[200],
                border: viewModel.records[name]!.isWinner
                    ? Border.all(
                        color: Colors.red,
                        width: 2.0,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignCenter)
                    : null,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(name.toUpperCase()),
                      const SizedBox(width: 6,),
                      viewModel.records[name]!.isWinner ? Image.asset('assets/winner.png', height: 50, width: 30,) : Container()
                    ],
                  ),
                ),
                const Spacer(),
                Obx(() => viewModel.records[name]!.isWinner
                    ? Container(
                        height: 56,
                      )
                    : Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: viewModel.records[name]!.isNegative
                                ? Colors.redAccent
                                : Colors.grey[300],
                            border: viewModel.records[name]!.isNegative
                                ? Border.all(
                                    color: Colors.red,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    strokeAlign: BorderSide.strokeAlignInside)
                                : null,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          onPressed: () {
                            viewModel.records[name]!.isNegative =
                                !viewModel.records[name]!.isNegative;
                            viewModel.records[name] =
                                viewModel.records[name]!;
                            viewModel.calculateWinnerPoint();
                          },
                          icon: const Icon(
                            Icons.remove,
                            size: 30,
                          ),
                          color: Colors.white,
                        ))),
                const SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 70,
                  height: 48,
                  child:  CupertinoTextField(
                        enabled: !viewModel.records[name]!.isWinner,
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            viewModel.records[name]!.isNegative
                                ? Icons.remove
                                : Icons.add,
                            size: 25,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignCenter),
                            borderRadius: BorderRadius.circular(4)),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: viewModel.textViewControllers[name]!,
                      ),
                ),
                const SizedBox(
                  width: 6,
                ),
                viewModel.records[name]!.isWinner
                    ? const SizedBox(
                  height: 56,
                  width: 56,
                )
                    : Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: IconButton(
                      onPressed: () {
                        viewModel.resetPointFor(name);
                      },
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                        size: 30,
                      ),
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
