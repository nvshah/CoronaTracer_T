import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/data_repository.dart';
import '../services/api.dart';
import '../repositories/endpoints_data.dart';
import './endpoint_card.dart';
import './last_updated_status.dart';
import './show_alert_dialog.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  // Not sure if context is available under initState(), so for an alternative 
  // we can get DataRepo instance inside didChangeDependencies()
  @override
  void initState() {
    super.initState();
    // get the data from cache prior to fetching data from server
    // so we will see data 2 times in our screen when we open app i.e 1st from cache & 2nd data updated from server
    final dataRepo = Provider.of<DataRepository>(context, listen: false);
    //OFFLINE mode
    _endpointsData = dataRepo.getAllEndPointCachedData();
    _updateData();
  }  

  //Get latest data from server
  Future<void> _updateData() async {
    try {
      final dataRepo = Provider.of<DataRepository>(context, listen: false);
      final cases = await dataRepo.getAllEndpointData();

      setState(() {
        _endpointsData = cases;
      });
    } on SocketException catch (_) {
      //await showAlertDialog   // --> Since we are not doing anythin after this so we can skip using await
      showAlertDialog(
        context: context,
        title: 'Connection Error !',
        content:
            'Could not fetch the data. Please check data connection & try again later.',
        defaultActionText: 'OK',
      );
    } catch (_){
       //Incase we get 4xx or 5xx from server | parsing error
       showAlertDialog(
        context: context,
        title: 'Unknown Error !',
        content:
            'Please contact support or try in a while.',
        defaultActionText: 'OK',
      );
    }
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
              date: _endpointsData?.cases?.date,
            ),
            //Collection for loop to add multiple member
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                //value: _endpointsData?.values[endpoint]?.numbers,
                value: _endpointsData != null
                    ? _endpointsData.values[endpoint]?.numbers
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
