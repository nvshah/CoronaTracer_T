import 'package:flutter/material.dart';

import '../services/api.dart';

class _EndpointCardData {
  final String title;
  final String image;
  final Color color;

  _EndpointCardData({
    this.title,
    this.color,
    this.image,
  });
}

class EndpointCard extends StatelessWidget {
  final Endpoint endpoint;
  final int value;

  const EndpointCard({
    Key key,
    this.endpoint,
    this.value,
  });

  //Here we make this mapping static because Constructor of this class is const
  //Hold the details about endpoint to be displayed such as title, color, image
  //Color Fomat ->   hex format : 0x[aplha][red][green][blue]
  static Map<Endpoint, _EndpointCardData> _cardDetails = {
    Endpoint.cases: _EndpointCardData(
      title: 'Cases',
      color: Color(0xFFFFF492),
      image: 'assets/count.png',
    ),
    Endpoint.casesConfirmed: _EndpointCardData(
      title: 'Confirmed Cases',
      color: Color(0xFFE99600),
      image: 'assets/fever.png',
    ),
    Endpoint.casesSuspected: _EndpointCardData(
      title: 'Suspected Cases',
      color: Color(0xFFEEDA28),
      image: 'assets/suspect.png',
    ),
    Endpoint.deaths: _EndpointCardData(
      title: 'Deaths',
      color: Color(0xFFE40000),
      image: 'assets/death.png',
    ),
    Endpoint.recovered: _EndpointCardData(
      title: 'Recovered',
      color: Color(0xFF70A901),
      image: 'assets/patient.png',
    ),
  };

  @override
  Widget build(BuildContext context) {
    //As per card there will be 1 endpoint, which will be divulge when card is created
    final cardData = _cardDetails[endpoint];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Title
              Text(
                cardData.title,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: cardData.color),
              ),
              SizedBox(
                height: 5,
              ),
              //Image & numbers
              SizedBox(
                //giving specific height to Row
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Image
                    Image.asset(
                      cardData.image,
                      color: cardData.color,
                    ),
                    //Numbers
                    Text(
                      value != null ? value.toString() : '',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: cardData.color,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
