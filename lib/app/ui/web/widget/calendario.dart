import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


Future<String?> Calendario(context ,function, dataInicio, dataFim){
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 16,
        child: SizedBox(
          height: 500,
          width: 500,
          child: SfDateRangePicker(
            onSelectionChanged: function,
            selectionMode: DateRangePickerSelectionMode.range,
            enablePastDates: false,
            showActionButtons: true,
            onCancel: (){Navigator.pop(context);},
            onSubmit: (Object? value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Data Selecionada',
                ),
                duration: Duration(milliseconds: 400),
              ));
              Navigator.pop(context);
            },
            initialSelectedRange: dataInicio != null ? PickerDateRange(
                dataInicio,
                dataFim) : null,
          ),
        ),
      );
    },
  );
}