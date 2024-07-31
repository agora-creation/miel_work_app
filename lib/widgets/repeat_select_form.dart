import 'package:flutter/material.dart';

class RepeatSelectForm extends StatelessWidget {
  final bool repeat;
  final Function(bool?) repeatOnChanged;
  final String interval;
  final Function(String) intervalOnChanged;
  final TextEditingController everyController;
  final List<String> weeks;
  final Function(String) weeksOnChanged;

  const RepeatSelectForm({
    required this.repeat,
    required this.repeatOnChanged,
    required this.interval,
    required this.intervalOnChanged,
    required this.everyController,
    required this.weeks,
    required this.weeksOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<bool>(
          underline: Container(),
          isExpanded: true,
          value: repeat,
          items: const [
            DropdownMenuItem(
              value: false,
              child: Text('繰り返さない'),
            ),
            DropdownMenuItem(
              value: true,
              child: Text('繰り返す'),
            ),
          ],
          onChanged: repeatOnChanged,
        ),
        const SizedBox(height: 4),
        // repeat
        //     ? Container(
        //         decoration: BoxDecoration(
        //           border: Border.all(color: kGrey600Color),
        //         ),
        //         padding: const EdgeInsets.all(8),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             ToggleButtons(
        //               isSelected: kRepeatIntervals.map((e) {
        //                 return e == interval;
        //               }).toList(),
        //               children: kRepeatIntervals.map((e) {
        //                 return Text(e);
        //               }).toList(),
        //               onPressed: (value) {
        //                 intervalOnChanged(kRepeatIntervals[value]);
        //               },
        //             ),
        //             const SizedBox(height: 4),
        //             interval == kRepeatIntervals[0]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextField(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       decoration: const InputDecoration(
        //                         suffix: Text('日ごと'),
        //                       ),
        //                     ),
        //                   )
        //                 : Container(),
        //             interval == kRepeatIntervals[1]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextField(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       decoration: const InputDecoration(
        //                         suffix: Text('週間ごと'),
        //                       ),
        //                     ),
        //                   )
        //                 : Container(),
        //             interval == kRepeatIntervals[2]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextField(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       decoration: const InputDecoration(
        //                         suffix: Text('ヶ月ごと'),
        //                       ),
        //                     ),
        //                   )
        //                 : Container(),
        //             const SizedBox(height: 4),
        //             interval == kRepeatIntervals[1]
        //                 ? Column(
        //                     children: kWeeks.map((e) {
        //                       return Container(
        //                         decoration: const BoxDecoration(
        //                           border: Border(
        //                             bottom: BorderSide(
        //                               color: kGrey300Color,
        //                             ),
        //                           ),
        //                         ),
        //                         child: CheckboxListTile(
        //                           value: weeks.contains(e),
        //                           title: Text(e),
        //                           onChanged: (value) {
        //                             weeksOnChanged(e);
        //                           },
        //                           controlAffinity:
        //                               ListTileControlAffinity.leading,
        //                         ),
        //                       );
        //                     }).toList(),
        //                   )
        //                 : Container(),
        //           ],
        //         ),
        //       )
        //     : Container(),
      ],
    );
  }
}
