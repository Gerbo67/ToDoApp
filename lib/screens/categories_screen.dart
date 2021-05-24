import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>.empty(growable: true);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var _editCategoryName = TextEditingController();
  var _editCategoryDescription = TextEditingController();
  var category;

  getAllCategories() async {
    _categoryList.clear();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.id = category['id'];
        model.name = category['name'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  _showSnackBar(message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Text("Categories"),
        leading: ElevatedButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editCategory(context, _categoryList[index].id);
                },
              ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_categoryList[index].name),
                      IconButton(icon: Icon(Icons.delete), onPressed: (){
                        _deleteCategoryDialog(context, _categoryList[index].id);
                      })
                    ],
                  ),
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormInDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    _category.name = _categoryName.text;
                    _category.description = _categoryDescription.text;
                    var result = await _categoryService.saveCategory(_category);
                    if (result > 0) {
                      Navigator.pop(context);
                      _showSnackBar("Saved succesful");
                      getAllCategories();
                    }
                  },
                  child: Text("Save")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
            title: Text("Category Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                        labelText: "Category name",
                        hintText: "Write category name"),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: InputDecoration(
                        labelText: "Category description",
                        hintText: "Write category description"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    _category.id = category[0]['id'];
                    _category.name = _categoryName.text;
                    _category.description = _categoryDescription.text;
                    var result =
                        await _categoryService.updateCategory(_category);
                    if (result > 0) {
                      Navigator.pop(context);
                      _showSnackBar("Updated succesful");
                      getAllCategories();
                    }
                  },
                  child: Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, "Operation Canceled");
                  },
                  child: Text("Cancel")),
            ],
            title: Text("Category Edit Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryName,
                    decoration: InputDecoration(
                        labelText: "Category name",
                        hintText: "Write category name"),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
                    decoration: InputDecoration(
                        labelText: "Category description",
                        hintText: "Write category description"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, onPrimary: Colors.white),
                  onPressed: () async {
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      _showSnackBar("Deleted!");
                    }
                  },
                  child: Text("Delete"))
            ],
            title: Text("Are you sure want to delete?"),
          );
        });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editCategoryName.text = category[0]['name'] ?? 'No name';
      _editCategoryDescription.text =
          category[0]['description'] ?? 'No description';
    });
    _editCategoryDialog(context);
  }
}
