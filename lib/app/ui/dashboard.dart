import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/data_repository.dart';
import '../services/api.dart';
import '../repositories/endpoints_data.dart';
import './endpoint_card.dart';
import './last_updated_status.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  //Get latest data
  Future<void> _updateData() async {
    final dataRepo = Provider.of<DataRepository>(context, listen: false);
    final cases = await dataRepo.getAllEndpointData();

    setState(() {
      _endpointsData = cases;
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
          children: <Widget>[
            //Last Updated Status(according to server)
            LastUpdatedStatus(
              date: _endpointsData?.values[Endpoint.cases].date,
            ),
            //Collection for loop to add multiple member
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData?.values[endpoint].numbers,
              ),
          ],
        ),
      ),
    );
  }
}
