import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeavesPage extends StatefulWidget {
  @override
  _LeavesPageState createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedLeaveType;

  final List<String> leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Casual Leave',
    'Maternity Leave',
    'Paternity Leave',
    'Unpaid Leave',
  ];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedLeaveType,
            hint: Text('Select Leave Type'),
            items: leaveTypes.map((String leaveType) {
              return DropdownMenuItem<String>(
                value: leaveType,
                child: Text(leaveType),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLeaveType = newValue;
              });
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context, true),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Start Date",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              isEmpty: this._startDate == null,
              child: Text(
                _startDate == null
                    ? ""
                    : DateFormat('yyyy-MM-dd').format(_startDate!),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(context, false),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "End Date",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              isEmpty: this._endDate == null,
              child: Text(
                _endDate == null
                    ? ""
                    : DateFormat('yyyy-MM-dd').format(_endDate!),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_startDate != null &&
                  _endDate != null &&
                  _selectedLeaveType != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Leave Requested: $_selectedLeaveType from ${DateFormat('yyyy-MM-dd').format(_startDate!.toLocal())} to ${DateFormat('yyyy-MM-dd').format(_endDate!.toLocal())}',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select dates and leave type.'),
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.grey[800]!, // Set button color here
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 20, // Change font size to 20
                ),
              ),
            ),
            child: Text('Request Leave',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        20)), // Ensure button text is white and font size is 20
          ),
          SizedBox(height: 20),

          // Display Leave Request Cards
          Expanded(
            child: ListView.builder(
              itemCount: leaveTypes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(
                            0xFF062F3E), // First color of the gradient (light blue)
                        Colors.white, // Second color of the gradient (white)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      leaveTypes[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Requested for ${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Status: Pending',
                          style: TextStyle(color: Colors.orange),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Duration: 5 days',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
