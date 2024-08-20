import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

final List<Channel> _channel=<Channel>[];
final ChannelDataSource _channelDataSource=ChannelDataSource(); 

class RealTime16Channel extends StatefulWidget {
  const RealTime16Channel({super.key});

  @override
  State<RealTime16Channel> createState() => _RealTime16ChannelState();
}

class _RealTime16ChannelState extends State<RealTime16Channel> {

  @override
  void initState(){
    super.initState();
    createData();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(source: _channelDataSource, 
    columnWidthMode: ColumnWidthMode.fill,
    columns: <GridColumn>[
      GridColumn(columnName: 'name', label: const Text('Channel')),
      GridColumn(columnName: 'value', label: const Text('Value'))
    ]);
  }
}

void createData(){
  _channel.add(Channel("1", 99));
  _channel.add(Channel("2", 99));
  _channel.add(Channel("3", 99));
  _channel.add(Channel("4", 99));
  _channel.add(Channel("5", 99));
  _channel.add(Channel("6", 99));
  _channel.add(Channel("7", 99));
  _channel.add(Channel("8", 99));
  _channel.add(Channel("9", 99));
  _channel.add(Channel("10", 99));

}

class Channel{
  Channel(this.name,this.value);
  final String name;
  final int value;
}

class ChannelDataSource extends DataGridSource {
  @override
  List<DataGridRow> get rows => _channel
      .map<DataGridRow>((dataRow) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'name', value: dataRow.name),
            DataGridCell<int>(columnName: 'value', value: dataRow.value),
           
          ]))
      .toList();
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
          return Text(dataCell.value.toString());
        }).toList());
  }
}