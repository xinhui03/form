import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(MaterialApp(home: FullFormDemo()));

class FullFormDemo extends StatefulWidget {
  @override
  _FullFormDemoState createState() => _FullFormDemoState();
}

class _FullFormDemoState extends State<FullFormDemo> {
  final _formKey = GlobalKey<FormState>();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  String? fullName;
  String? dob;
  String? selectedGender;
  double familyMembers = 5;
  int ratingChip = 0;
  int stepperValue = 10;

  bool knowsEnglish = false;
  bool knowsHindi = false;
  bool knowsOther = false;

  double siteRating = 0;
  bool agreedToTerms = false;
  bool showError = false;

  List<String> genders = ['Male', 'Female', 'Other'];

  void _submitForm() {
    if (_formKey.currentState!.validate() && agreedToTerms) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form submitted successfully")),
      );
    } else {
      setState(() {
        showError = !agreedToTerms;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      selectedGender = null;
      familyMembers = 5;
      ratingChip = 0;
      stepperValue = 10;
      knowsEnglish = false;
      knowsHindi = false;
      knowsOther = false;
      siteRating = 0;
      agreedToTerms = false;
      showError = false;
      _signatureController.clear();
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Form Validation"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              TextFormField(
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "This field cannot be empty." : null,
                onSaved: (value) => fullName = value,
              ),
              SizedBox(height: 16),

              // Date of Birth
              TextFormField(
                decoration: InputDecoration(labelText: "Date of Birth"),
                validator: (value) =>
                    value == null || value.isEmpty ? "This field cannot be empty." : null,
                onSaved: (value) => dob = value,
              ),
              SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Gender"),
                items: genders
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? "This field cannot be empty." : null,
                onChanged: (value) => selectedGender = value,
              ),
              SizedBox(height: 16),

              // Age
              TextFormField(
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                  value == null || value.isEmpty ? "This field cannot be empty." : null,
              ),
              SizedBox(height: 16),

              // Family Members Slider
              Column(
                children: [
                  Text("Number of Family Members"),
                  Slider(
                    value: familyMembers,
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    label: familyMembers.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        familyMembers = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("0.0"),
                      Text("10.0"),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: const Color.fromARGB(255, 160, 160, 160),
                  ),
                  SizedBox(height: 16),
                ],
              ),
              SizedBox(height: 16),

              // Rating Chips
              Text("Rating"),
              Wrap(
                spacing: 10,
                children: List.generate(
                  5,
                  (index) => ChoiceChip(
                    label: Text('${index + 1}'),
                    selected: ratingChip == index + 1,
                    selectedColor: Colors.purple.shade100,
                    onSelected: (_) {
                      setState(() {
                        ratingChip = index + 1;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              Text("Stepper"),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                      if (stepperValue > 0) stepperValue--;
                      });
                    },
              ),
              Text(
                stepperValue.toString(),
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    stepperValue++;
                  });
                },
              ),
            ],
          ),
          Container(
            height: 1,
            color: const Color.fromARGB(255, 160, 160, 160),
          ),
          SizedBox(height: 16),

              // Languages
              Text("Languages you know"),
              CheckboxListTile(
                title: Text("English"),
                value: knowsEnglish,
                onChanged: (val) => setState(() => knowsEnglish = val!),
              ),
              CheckboxListTile(
                title: Text("Hindi"),
                value: knowsHindi,
                onChanged: (val) => setState(() => knowsHindi = val!),
              ),
              CheckboxListTile(
                title: Text("Other"),
                value: knowsOther,
                onChanged: (val) => setState(() => knowsOther = val!),
              ),

              // Signature
              Text("Signature"),
              Container(
                height: 150,
                decoration: BoxDecoration(border: Border.all()),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () => _signatureController.clear(),
                  ),
                  Text("Clear", style: TextStyle(color: Colors.red)),
                ],
              ),
              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
              SizedBox(height: 16),

              // Star Rating
              Text("Rate this site"),
              RatingBar.builder(
                initialRating: siteRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 32,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.purple),
                onRatingUpdate: (rating) =>
                    setState(() => siteRating = rating),
              ),
              SizedBox(height: 18),
              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),

              // Terms and Conditions
              CheckboxListTile(
                title: Text("I have read and agree to the terms and conditions"),
                value: agreedToTerms,
                onChanged: (val) =>
                    setState(() => agreedToTerms = val ?? false),
              ),
              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
              SizedBox(height: 16),

              if (showError)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "You must accept terms and conditions to continue",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 193, 142, 202)),
                    child: Text("Submit"),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}