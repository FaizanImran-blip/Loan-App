import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const LoanApp());
}

class LoanApp extends StatefulWidget {
  const LoanApp({super.key});

  @override
  State<LoanApp> createState() => _LoanAppState();
}

class _LoanAppState extends State<LoanApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    _globalToggleTheme = _toggleTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Application',
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: SplashScreenWrapper(),
    );
  }
}

// Light Theme (GitHub Light Style)
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF6F8FA),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0969DA),
    brightness: Brightness.light,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFD0D7DE)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFF0969DA)),
    ),
    labelStyle: const TextStyle(color: Colors.black87),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  useMaterial3: true,
);

// Dark Theme (GitHub Dark Style)
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D1117),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF58A6FF),
    brightness: Brightness.dark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF161B22),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFF30363D)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFF58A6FF)),
    ),
     errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.orange), 
  ),
    labelStyle: const TextStyle(color: Color(0xFFC9D1D9)),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFC9D1D9)),
  ),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const MyApp({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Loan Application',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: const [LoanApplicationPage()],
          ),
        ),
      ),
    );
  }
}

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateField(String field, dynamic value) {
    setState(() {
      _formData[field] = value;
    });
  }

  void _submitApplication() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Submitting loan application: $_formData');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully!')),
      );
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Divider(
              thickness: 1,
              color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
            ),

            _buildNumberField(
              label: 'Number of Dependents',
              field: 'no_of_dependents',
              min: 0,
              max: 10,
            ),

            _buildDropdownField(
              label: 'Education',
              field: 'education',
              items: const ['Graduate', 'Not Graduate'],
            ),

            _buildToggleField(
              label: 'Self Employed',
              field: 'self_employed',
            ),

            _buildCurrencyField(
              label: 'Annual Income (₹)',
              field: 'income_annum',
              min: 0,
            ),

            _buildCurrencyField(
              label: 'Loan Amount (₹)',
              field: 'loan_amount',
              min: 10000,
            ),

            _buildNumberField(
              label: 'Loan Term (years)',
              field: 'loan_term',
              min: 1,
              max: 30,
            ),

            _buildNumberField(
              label: 'CIBIL Score',
              field: 'cibil_score',
              min: 300,
              max: 900,
            ),

            const SizedBox(height: 20),
            Text(
              'Asset Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Divider(
              thickness: 1,
              color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
            ),

            _buildCurrencyField(
              label: 'Residential Assets Value (₹)',
              field: 'residential_assets_value',
              min: 0,
            ),

            _buildCurrencyField(
              label: 'Commercial Assets Value (₹)',
              field: 'commercial_assets_value',
              min: 0,
            ),

            _buildCurrencyField(
              label: 'Luxury Assets Value (₹)',
              field: 'luxury_assets_value',
              min: 0,
            ),

            _buildCurrencyField(
              label: 'Bank Asset Value (₹)',
              field: 'bank_asset_value',
              min: 0,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF238636), // GitHub green
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: _submitApplication,
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required String field,
    required int min,
    int? max,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.numbers),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          final numValue = int.tryParse(value);
          if (numValue == null) return 'Please enter a valid number';
          if (numValue < min) return 'Value must be at least $min';
          if (max != null && numValue > max) return 'Value must be at most $max';
          return null;
        },
        onChanged: (value) => _updateField(field, int.tryParse(value)),
      ),
    );
  }

  Widget _buildCurrencyField({
    required String label,
    required String field,
    required num min,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixText: '₹ ',
          suffixIcon: const Icon(Icons.currency_rupee),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          final numValue = num.tryParse(value);
          if (numValue == null) return 'Please enter a valid amount';
          if (numValue < min) return 'Amount must be at least ₹$min';
          return null;
        },
        onChanged: (value) => _updateField(field, num.tryParse(value)),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String field,
    required List<String> items,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
        value: _formData[field],
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) => _updateField(field, value),
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildToggleField({
    required String label,
    required String field,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFFC9D1D9) : Colors.black87,
            ),
          ),
          Switch(
            activeColor: const Color(0xFF238636),
            value: _formData[field] ?? false,
            onChanged: (value) => _updateField(field, value),
          ),
        ],
      ),
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
//handle login intro transition
class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool showIntro = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showIntro = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showIntro ? _Intro() : LoginPage();
  }
}
//login
const Color bgColor = Color(0xFF0D1117);
const Color cardColor = Color(0xFF161B22);
const Color textColor = Colors.white;
const Color inputColor = Color(0xFF21262D);
const Color accentColor = Color.fromRGBO(9, 105, 218, 1);

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "SafeCredit",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField("Email", emailController),
                const SizedBox(height: 20),
                buildTextField("Password", passwordController, isPassword: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => MyApp(onToggleTheme: _globalToggleTheme)),
);
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: bgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
//intro

Widget _Intro() {
  return Scaffold(
    backgroundColor: Color(0xFF161B22),
    appBar:null,
    body:Column(
    children: [
      SizedBox(height: 50),

      // 🔹 ZigZag Lines
      _ZigZagLine(),
      SizedBox(height: 10),
      _ZigZagLine(),
      SizedBox(height: 10),
      _ZigZagLine(),

      SizedBox(height: 50),

      Center(
        child: Text(
          "SafeCredit",
          style: TextStyle(
            color: Color.fromRGBO(9, 105, 218, 1),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      SizedBox(height: 10),

      Center(
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
            "https://png.pngtree.com/png-vector/20220615/ourmid/pngtree-coin-in-hand-loan-logo-vector-png-image_5089557.png",
          ),
        ),
      ),
      SizedBox(height: 50),

      // 🔹 ZigZag Lines
      _ZigZagLine(),
      SizedBox(height: 10),
      _ZigZagLine(),
      SizedBox(height: 10),
      _ZigZagLine(),
    ],
  ),
  );
}

//function to lines
Widget _ZigZagLine() {
  return CustomPaint(
    size: Size(double.infinity, 20),
    painter: ZigZagPainter(color: Color.fromRGBO(9, 105, 218, 1)),
  );
}

//animate to lines
class ZigZagPainter extends CustomPainter {
  final Color color;
  ZigZagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    double waveWidth = 10;
    double waveHeight = 10;

    path.moveTo(0, waveHeight);

    for (double i = 0; i <= size.width; i += waveWidth) {
      path.lineTo(i + waveWidth / 2, 0);
      path.lineTo(i + waveWidth, waveHeight);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
late void Function() _globalToggleTheme;