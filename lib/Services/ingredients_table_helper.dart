import '../Models/models_library.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// A helper class for interacting with the ingredients_table in the database.
class ingredients_table_helper
{
  // Simply takes in an ingredient_obj which mirrors a row from the ingredients_table table
  //    and adds it to the database
  /// Adds a new ingredient row to the ingredients_table.
  ///
  /// Takes in an ingredient_obj which mirrors a row from the ingredients_table table
  /// and adds it to the database.
  Future<void> add_ingredient_row(ingredient_obj ingr_obj) async
  {
    HttpsCallable addIngredient = FirebaseFunctions.instance.httpsCallable('insertIntoIngredientsTable');
    await addIngredient.call({'values': ingr_obj.get_values()});
  }

  /// Edits a row in the ingredients_table.
  ///
  /// Takes in the row_id of the row to be edited and the new_amount to be set.
  /// Edits the corresponding row in the database.
  Future<void> edit_ingredient_row(int row_id, int new_amount) async
  {
    HttpsCallable editIngredient = FirebaseFunctions.instance.httpsCallable('updateIngredientsTableRow');
    await editIngredient.call({
      'row_id': row_id,
      'new_amount': new_amount
    });
  }

  // Deletes a single row from the ingredients_table table specified by row_id
  /// Deletes a row in the ingredients_table.
  ///
  /// Takes in the row_id of the row to be deleted.
  /// Deletes the corresponding row in the database.
  Future<void> delete_ingredient_row(int row_id) async
  {
    HttpsCallable deleteIngredient = FirebaseFunctions.instance.httpsCallable('deleteIngredientsTableRow');
    await deleteIngredient.call({'row_id': row_id});
  }

  /// Gets a list of all the ingredient names in the ingredients_table.
  ///
  /// Returns a list of strings representing the names of all the ingredients in the ingredients_table.
  Future<List<String>> get_all_ingredient_names() async {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getIngredientNames');
    final ingredient_name_query = await callable();
    List result = ingredient_name_query.data;
    List<String> names = [];

    for (int i = 0; i < result.length; i++) {
      names.add(result[i]['ingredient_name']);
    }

    return names;
  }
}