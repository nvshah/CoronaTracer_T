import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/data_repository.dart';
import '../services/api.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _cases;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  //Get latest data
  Future<void> _updateData() async {
    final dataRepo = Provider.of<DataRepository>(context, listen: false);
    final cases = await dataRepo.getEndpointData(Endpoint.cases);

    setState(() {
      _cases = cases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}