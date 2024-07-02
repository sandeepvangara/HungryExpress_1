import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(SwiggyApp());

class SwiggyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Swiggy Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WelcomeScreen(username: _usernameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  } else if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])').hasMatch(value)) {
                    return 'Password must contain at least one special symbol and one number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String username;
  WelcomeScreen({required this.username});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: widget.username),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo.jpeg', height: 100),
            SizedBox(height: 20),
            Text('Welcome ${widget.username}!',
                style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;
  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Restaurants in Vijayawada',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/user.jpeg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    username,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(username: username),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: RestaurantList()),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;
  ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo.jpeg', height: 100),
            SizedBox(height: 20),
            Text('Welcome $username!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(username: username)),
                );
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants = [
      Restaurant(
        'Le Story',
        'Italian',
        4.5,
        [
          MenuItem('Tiramisu', 'Delicious tiramisu with cheese and toppings',
              10.99, 'images/tiramisu.jpeg'),
          MenuItem('Pasta', 'Spaghetti with marinara sauce', 8.99,
              'images/pasta.jpeg'),
          MenuItem('Pizza', 'Delicious pizza with cheese', 4.27,
              'images/pizza.jpeg'),
          MenuItem('Risotto',
              'Prepared with rice pasta simmered in broth', 24.99,
              'images/risotto.jpeg')
        ],
      ),
      Restaurant(
        'Bawarchi',
        'Indian',
        4.2,
        [
          MenuItem('Chicken Curry', 'Spicy chicken curry with rice', 12.99,
              'images/chicken curry.jpeg'),
          MenuItem('Naan', 'Buttery Indian bread', 2.99, 'images/naan.jpeg'),
          MenuItem('Hyderabadi Biryani', 'Loaded with Double Masala', 3.99,
              'images/biryani.jpeg'),
          MenuItem('Apricot Delight', 'Delicious with badam', 1.49,
              'images/apricot delight.jpeg')
        ],
      ),
      Restaurant(
        'Nanking Fusion',
        'Chinese',
        4.0,
        [
          MenuItem('Spring Rolls', 'Crispy spring rolls with dipping sauce',
              6.99, 'images/spring roll.jpeg'),
          MenuItem('Fried Rice', 'Vegetable fried rice', 7.99,
              'images/fried rice.jpeg'),
          MenuItem('Chicken Drumsticks (10 Pcs)', 'dry & crunchy', 3.99,
              'images/chicken drumstick.jpeg'),
          MenuItem('Special Chopsuey', 'Served with rice and soya sauce', 4.79,
              'images/chopsuey.jpeg')
        ],
      ),
      Restaurant(
        'KBN Ruchulu',
        'Telugu',
        2.0,
        [
          MenuItem('Punugu', 'Served with chutney and sambar', 0.30,
              'images/punugu.jpg'),
          MenuItem('Mysore Bajji', 'Served with chutney and sambar', 0.30,
              'images/bonda.jpg'),
          MenuItem('Puri', 'Served with chutney and curry', 0.50,
              'images/poori.jpeg'),
          MenuItem('Tea', 'Served hot and strong', 0.50, 'images/tea.jpg')
        ],
      ),
      Restaurant(
        'Starbucks',
        'Cafe',
        3.5,
        [
          MenuItem('Masala Chai', 'Traditional Indian spiced tea', 3.99,
              'images/chai.jpg'),
          MenuItem('Mocha', 'Chocolate-flavored coffee', 4.99, 'images/mocha.jpeg'),
          MenuItem('Croissant', 'Flaky buttery pastry', 2.99,
              'images/crossiant.jpeg'),
          MenuItem('Caramel Macchiato', 'Espresso with caramel and steamed milk', 5.99,
              'images/caramel.jpeg')
        ],
      ),
      Restaurant(
        'CreamStone',
        'Ice Creams',
        4.0,
        [
          MenuItem('Dry Fruit Delight', 'loaded with dry fruits', 1.90, 'images/dry.jpeg'),
          MenuItem('Nuts overloaded', 'nuts loaded', 1.95, 'images/nuts.jpeg'),
          MenuItem('Oreo Shot', 'Oreo flavoured', 1.50, 'images/oreo.jpg'),
          MenuItem('Sizziling Browine', 'Served sizziling', 2.00, 'images/browine.jpg'),
        ],
      ),
    ];

    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Card(
          child: ListTile(
            title: Text(restaurant.name),
            subtitle: Text('${restaurant.cuisine} • ${restaurant.rating} ⭐'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuScreen(restaurant: restaurant),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;
  MenuScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView.builder(
        itemCount: restaurant.menu.length,
        itemBuilder: (context, index) {
          final menuItem = restaurant.menu[index];
          return Card(
            child: ListTile(
              leading: Image.asset(menuItem.image, width: 50, height: 50),
              title: Text(menuItem.name),
              subtitle: Text(menuItem.description),
              trailing: Text('\$${menuItem.price.toStringAsFixed(2)}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(menuItem.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(menuItem.image),
                        SizedBox(height: 10),
                        Text(menuItem.description),
                        SizedBox(height: 10),
                        Text('Price: \$${menuItem.price.toStringAsFixed(2)}'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false)
                              .addItem(menuItem);
                          Navigator.pop(context);
                        },
                        child: Text('Add to Cart'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Cart')
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final menuItem = cart.items[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(menuItem.image, width: 50, height: 50),
                  title: Text(menuItem.name),
                  subtitle: Text('\$${menuItem.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => cart.removeItem(menuItem),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total: \$${Provider.of<CartModel>(context).totalPrice.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                // Show a dialog with the "Thank You, order placed" message
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Thank You'),
                    content: Text('order placed'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<MenuItem> _items = [];

  List<MenuItem> get items => _items;

  void addItem(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, current) => total + current.price);
  }
}

class Restaurant {
  final String name;
  final String cuisine;
  final double rating;
  final List<MenuItem> menu;

  Restaurant(this.name, this.cuisine, this.rating, this.menu);
}

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String image;

  MenuItem(this.name, this.description, this.price, this.image);
}
