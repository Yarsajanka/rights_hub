import 'package:flutter/material.dart';

class PrisonerManagementScreen extends StatefulWidget {
  @override
  _PrisonerManagementScreenState createState() => _PrisonerManagementScreenState();
}

class _PrisonerManagementScreenState extends State<PrisonerManagementScreen> {
  final List<Map<String, String>> samplePrisoners = [
    {
      'name': 'John Doe',
      'caseHistory': 'Case #12345 - Theft',
      'familyDetails': 'Wife: Jane Doe, Children: 2',
      'legalAidProgress': 'Consultation scheduled',
      'nextHearing': '2024-07-15',
      'bailStatus': 'Pending',
      'prisonCondition': 'Good',
    },
    {
      'name': 'Alice Smith',
      'caseHistory': 'Case #67890 - Assault',
      'familyDetails': 'Husband: Bob Smith',
      'legalAidProgress': 'Documents submitted',
      'nextHearing': '2024-08-01',
      'bailStatus': 'Denied',
      'prisonCondition': 'Fair',
    },
    {
      'name': 'Michael Johnson',
      'caseHistory': 'Case #54321 - Fraud',
      'familyDetails': 'Single',
      'legalAidProgress': 'Awaiting lawyer assignment',
      'nextHearing': '2024-07-20',
      'bailStatus': 'Granted',
      'prisonCondition': 'Good',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prisoner Welfare Management"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: samplePrisoners.length,
        itemBuilder: (context, index) {
          final prisoner = samplePrisoners[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prisoner['name'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Case History: ${prisoner['caseHistory']}'),
                  Text('Family Details: ${prisoner['familyDetails']}'),
                  Text('Legal Aid Progress: ${prisoner['legalAidProgress']}'),
                  SizedBox(height: 8),
                  Text('Next Hearing: ${prisoner['nextHearing']}'),
                  Text('Bail Status: ${prisoner['bailStatus']}'),
                  SizedBox(height: 8),
                  Text('Prison Condition: ${prisoner['prisonCondition']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
