import 'package:flutter/material.dart';
import 'package:safecampus/constants/themeconstants.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/user.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/widgets/dialog.dart';

class CovidForm extends StatefulWidget {
  const CovidForm({Key? key}) : super(key: key);
  @override
  State<CovidForm> createState() => _CovidFormState();
}

class _CovidFormState extends State<CovidForm> {
  @override
  void initState() {
    super.initState();
    _date = _vaccinatedOn = DateTime.now();
  }

  bool? _result;
  bool? _vaccinated;
  String? _method;

  late DateTime _vaccinatedOn;
  late DateTime _date;

  final format = DateFormat.yMMMMd('en_US');

  CovidInfo get covidInfo => CovidInfo(
        result: _result!,
        method: _method,
        vaccinated: _vaccinated ?? false,
        vaccinatedOn: _vaccinatedOn,
        date: _date,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Update your Covid Report",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Select Test Method"),
            subtitle: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        onChanged: (String? v) {
                          setState(() {
                            _method = v!;
                          });
                        },
                        value: _method,
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'PCR',
                            child: Text('PCR'),
                          ),
                          DropdownMenuItem(
                            value: 'RTX',
                            child: Text('RTX'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Select your test Result"),
            subtitle: Table(
              children: [
                TableRow(children: [
                  RadioListTile<bool>(
                      title: const Text('Positive'),
                      value: true,
                      groupValue: _result,
                      onChanged: (val) {
                        setState(() {
                          _result = val!;
                        });
                      }),
                  RadioListTile<bool>(
                      title: const Text('Negative'),
                      value: false,
                      groupValue: _result,
                      onChanged: (val) {
                        setState(() {
                          _result = val!;
                        });
                      }),
                ])
              ],
            ),
          ),
          ListTile(
            title: const Text("Test Date"),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(format.format(_date), style: getText(context).bodyText2),
                  TextButton(
                      onPressed: () async {
                        _date = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate:
                                    _date.subtract(const Duration(days: 365)),
                                lastDate: DateTime.now()) ??
                            _date;
                        setState(() {});
                      },
                      child: Text(
                        "Change Date",
                        style: getText(context).bodyText1,
                      ))
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("Have you vaccinated ?? "),
            subtitle: Table(
              children: [
                TableRow(children: [
                  RadioListTile<bool>(
                      title: const Text('Yes'),
                      value: true,
                      groupValue: _vaccinated,
                      onChanged: (val) {
                        setState(() {
                          _vaccinated = val!;
                        });
                      }),
                  RadioListTile<bool>(
                      title: const Text('No'),
                      value: false,
                      groupValue: _vaccinated,
                      onChanged: (val) {
                        setState(() {
                          _vaccinated = val!;
                        });
                      }),
                ])
              ],
            ),
          ),
          _vaccinated == true
              ? ListTile(
                  title: const Text("Vaccination Date"),
                  subtitle: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(format.format(_vaccinatedOn),
                            style: getText(context).bodyText2),
                        _vaccinated == true
                            ? TextButton(
                                onPressed: () async {
                                  _vaccinatedOn = await showDatePicker(
                                          context: context,
                                          initialDate: _vaccinatedOn,
                                          firstDate: _vaccinatedOn.subtract(
                                              const Duration(days: 365)),
                                          lastDate: DateTime.now()) ??
                                      _date;
                                  setState(() {});
                                },
                                child: Text(
                                  "Change Date",
                                  style: getText(context).bodyText1,
                                ))
                            : const Text(""),
                      ],
                    ),
                  ),
                )
              : Text(''),
          ElevatedButton(
              onPressed: () {
                if (_method != null && _vaccinated != null && _result != null) {
                  showFutureDialog(
                      context: context,
                      future: userController.addCovidInfo(covidInfo),
                      onSuccess: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      onFailure: () {
                        Navigator.of(context).pop();
                      });
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      // title: const Text('AlertDialog Title'),
                      content: const Text('Please fill all the fields'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
              },
              child: const Text("Submit")),
        ],
      ),
    );
  }
}
