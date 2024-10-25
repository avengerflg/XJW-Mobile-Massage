import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> bookings = [
    {
      "id": "1",
      "service": "Deep Tissue Massage",
      "bdate": "2024-11-01",
      "timeslot": "10:00 AM",
      "status": "Booked",
      "total": "120",
    },
    {
      "id": "2",
      "service": "Swedish Massage",
      "bdate": "2024-11-03",
      "timeslot": "1:00 PM",
      "status": "Completed",
      "total": "150",
    },
  ];

  void _cancelBooking(String id) {
    setState(() {
      bookings = bookings.where((booking) => booking['id'] != id).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(bookings[index]);
              },
            ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor = booking['status'] == 'Booked'
        ? Colors.orange
        : booking['status'] == 'Completed'
            ? Colors.green
            : Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: ListTile(
          leading: const Icon(Icons.spa, color: Colors.green),
          title: Text(
            booking['service'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: ${booking['bdate']}"),
              Text("Time: ${booking['timeslot']}"),
              Text("Total: \$${booking['total']}"),
            ],
          ),
          trailing: Text(
            booking['status'],
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            if (booking['status'] == 'Booked') {
              _cancelBooking(booking['id']);
            }
          },
        ),
      ),
    );
  }
}
