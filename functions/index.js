//This imports firebase functions so that we can use it
const functions = require('firebase-functions');

//This imports a postgres library for JavaScript
const { Client } = require('pg');

//This creates an object we can use to connect to our database

// This is a function without parameters, it's very similar to a parameterized function
// If you want to create a new function you should replace getEmployeesTest with the function name
// The rest should be the same for all our functions
// functions is the name we gave to the firebase functions package
// https is the protocol used
// onCall means that it can be invoked on the client side (i.e. from our dart code)
// async means that it will have parts that are waiting for other parts
// data is an an optional parameter that can be used for passing data
// context is an optional parameter that is used for giving the function other types of information
// data and context are auto assigned by system variables if not given so don't stress about them being here
// also we likely won't use context
exports.getEmployeesTest = functions.https.onCall(async (data, context) => {

     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });
// await makes the rest of the function wait until this line completes
// this connects to our database
    await client.connect()

// this creates a const that will store the result of our query
// it also queries the client with the given string argument
    const res = await client.query('SELECT * FROM employees')

//  this closes our connection to our database
    client.end()

//  this returns a list of dictionaries populated with the values of the request
//  e.g. if only Jonas existed it would return this [{employee_id: 2, employee_name: Jonas, employee_role: Server, passcode: 56, hourly_rate: $14.99}]
    return res.rows
});



// this is a function with a parameter
exports.getOneEmployeeByIdTest = functions.https.onCall(async (data, context) => {

     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

//  this is makes the function have the parameter employee_id
    const {employee_id} = data;

    await client.connect()

//  you can simply add variables to the query
    const res = await client.query('SELECT * FROM employees WHERE employee_id =' + employee_id)

    client.end()

    return res.rows

});


// for getting the user's info after logging in
exports.getEmployeeByUID = functions.https.onCall(async (data, context) => {

    const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

    const {employee_uid} = data;

    await client.connect()

    const res = await client.query("SELECT * FROM employees WHERE employee_uid ='" + employee_uid+"'")

    client.end()

    return res.rows

});



// Gets the largest id from the menu_items table, so that it can be used when adding new menu items
exports.getLastMenuItemID = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const res = await client.query('SELECT menu_item_id FROM menu_items ORDER BY menu_item_id DESC LIMIT 1');

    client.end()

    return res.rows

});

// Gets the largest id from the ingredients_table table, so that it can be used when adding an item's ingredients
exports.getLastIngredientsTableID = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const res = await client.query('SELECT row_id FROM ingredients_table ORDER BY row_id DESC LIMIT 1');

    client.end()

    return res.rows

});

// Adds a menu item to the menu_items table
exports.addMenuItem = functions.https.onCall(async (data, context) => {

    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {values} = data

    const res = await client.query('INSERT INTO menu_items (menu_item_id, menu_item, item_price, amount_in_stock, type, status) VALUES(' + values + ')')

    client.end()

    return "Added menu item to database"
});

exports.editItemPrice = functions.https.onCall(async (data, context) => {

     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

     await client.connect()

     const {menu_item_id} = data
     const {new_price} = data

     const res = await client.query('UPDATE menu_items SET item_price=' + new_price + ' WHERE menu_item_id=' + menu_item_id)

     client.end()

     return "updated menu item price in the database"
 });

exports.deleteMenuItem = functions.https.onCall(async (data, context) => {

     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

     await client.connect()

     const {menu_item} = data

     const res = await client.query('UPDATE menu_items SET status=\'unavailable\' WHERE menu_item LIKE \'%' + menu_item + '%\'')

     client.end()

     return "deleted menu item from database"
 });

// Adds an ingredient row to the ingredients_table table
exports.insertIntoIngredientsTable = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {values} = data

    const res = await client.query('INSERT INTO ingredients_table (row_id, menu_item_name, ingredient_name, ingredient_amount) VALUES(' + values + ')')

    client.end()

    return "Added ingredient to ingredients_table"
});

exports.getIngredientRowId = functions.https.onCall(async (data, context) => {
     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

     await client.connect()

     const {menu_item_name} = data
     const {ingredient_name} = data

     const res = await client.query('SELECT row_id FROM ingredients_table WHERE menu_item_name=\'' + menu_item_name + '\' AND ingredient_name=\'' + ingredient_name + '\'')

     client.end()

     return res.rows
 })

// Takes a row_id and a new_amount, updates the ingredients_table at row_id and changes the quantity to new_amount
exports.updateIngredientsTableRow = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {row_id} = data
    const {new_amount} = data

    const res = await client.query('UPDATE ingredients_table SET ingredient_amount=' + new_amount + ' WHERE row_id=' + row_id)

    client.end()

    return "Successfully updated ingredients_table row"
});

// Deletes an individual row from the ingredients_table
exports.deleteIngredientsTableRow = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {row_id} = data

    const res = await client.query('DELETE FROM ingredients_table WHERE row_id=' + row_id)

    client.end()

    return "Successfully deleted ingredients_table row"
});

exports.getMenuItemName = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {menu_item_id} = data

    const res = await client.query('SELECT menu_item FROM menu_items WHERE menu_item_id=' + menu_item_id)

    client.end()

    return res.rows
});

exports.getMenuItemType = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {menu_item_id} = data

    const res = await client.query('SELECT type FROM menu_items WHERE menu_item_id=' + menu_item_id)

    client.end()

    return res.rows
});


exports.getItemPrice = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {menu_item_name} = data

    const res = await client.query('SELECT item_price FROM menu_items WHERE menu_item=\'' + menu_item_name + '\'')

    client.end()

    return res.rows
});

exports.getItemID = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {menu_item_name} = data

    const res = await client.query('SELECT menu_item_id FROM menu_items WHERE menu_item=\'' + menu_item_name + '\'')

    client.end()

    return res.rows
});



exports.getMenuItemIngredients = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {menu_item_name} = data

    const res = await client.query('SELECT ingredient_name, ingredient_amount FROM ingredients_table WHERE menu_item_name=\'' + menu_item_name + '\'')

    client.end()

    return res.rows
});

exports.getAmountInvStock = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {ingredient} = data

    const res = await client.query('SELECT inv_order_id, amount_inv_stock FROM inventory WHERE ingredient=\'' + ingredient + '\' ORDER BY expiration_date DESC, date_ordered');

    client.end()

    return res.rows
});

exports.updateInventoryRow = functions.https.onCall(async (data, context) => {
    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const {inv_order_id} = data
    const {new_amount} = data

    const res = await client.query('UPDATE inventory SET amount_inv_stock=' + new_amount + 'WHERE inv_order_id=' + inv_order_id)

    client.end()

    return "Successfully updated inventory row"

});

exports.insertIntoOrderHistory = functions.https.onCall(async (data, context) => {
     const client = new Client({
           host: 'csce-315-db.engr.tamu.edu',
           user: 'csce315331_team_13_master',
           password: 'Lucky_13',
           database: 'csce315331_team_13',
           port: 5432,
     });

     await client.connect()

     const {values} = data

     const res = await client.query('INSERT INTO order_history (transaction_id, order_taker_id, item_ids_in_order, total_price, customer_name, date_of_order, status) VALUES(' + values + ')')

     client.end()

     return "Successfully added order to the order history"
});

exports.getSmoothieNames = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT menu_item FROM menu_items WHERE type='smoothie'");

    client.end()

    return res.rows
});

exports.getSnackNames = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT menu_item FROM menu_items WHERE type='snack'");

    client.end()

    return res.rows
});

exports.getAddonNames = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT menu_item FROM menu_items WHERE type='addon'");

    client.end()

    return res.rows
});

exports.getIngredientNames = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT DISTINCT ingredient_name FROM ingredients_table ORDER BY ingredient_name");

    client.end()

    return res.rows
});

exports.makeZReport = functions.https.onCall(async (data, context) => {
   const client = new Client({
       host: 'csce-315-db.engr.tamu.edu',
       user: 'csce315331_team_13_master',
       password: 'Lucky_13',
       database: 'csce315331_team_13',
       port: 5432,
   });

   await client.connect()

   const {date} = data
   const {amount} = data

   const res = await client.query("INSERT INTO z_reports VALUES('" + date + "', '" + amount + "')");

   client.end()

   return "Successfully initialized X/Z report"
});

exports.getZReport = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const {date} = data

    const res = await client.query("SELECT sales FROM z_reports WHERE date=CAST(\'" + date + "\' as date)");

    client.end()

    return res.rows
});

exports.getAllZReports = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT to_char(date, 'DD-MM-YYYY') AS date_field_string, sales FROM z_reports ORDER BY date ASC");

    client.end()

    return res.rows
});



exports.updateXReport = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const {date} = data
    const {amount} = data

    const res = await client.query("UPDATE z_reports SET sales=" + amount + " WHERE date=CAST(\'" + date + "\' as date)");

    client.end()

    return "Successfully updated today's X report"
});

exports.getIngredientNames = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });


    await client.connect()

    const res = await client.query("SELECT DISTINCT ingredient_name FROM ingredients_table ORDER BY ingredient_name");

    client.end()

    return res.rows
});

exports.getItemsInOrder = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const {date1} = data
    const {date2} = data

    var cast1 = "CAST('" + date1 + "' as date)";
    var cast2 = "CAST('" + date2 + "' as date)";

    const res = await client.query("SELECT item_ids_in_order FROM order_history WHERE date_of_order>=" + cast1 + " AND date_of_order<=" + cast2);

    client.end()

    return res.rows
});

exports.getAllSmoothieInfo = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()


    const res = await client.query("SELECT menu_item_id, menu_item, item_price FROM menu_items WHERE (type='smoothie' AND status= 'available') ORDER BY menu_item");

    client.end()

    return res.rows
});

exports.getAllSnacksInfo = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT menu_item_id, menu_item, item_price FROM menu_items WHERE (type='snack' AND status= 'available') ORDER BY menu_item");

    client.end()

    return res.rows
});

exports.getAllAddonInfo = functions.https.onCall(async (data, context) => {
    const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT menu_item_id, menu_item, item_price FROM menu_items WHERE (type='addon' AND status= 'available') ORDER BY menu_item");

    client.end()

    return res.rows
});

exports.getInventoryItems = functions.https.onCall(async (data, context) =>
{
      const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
      });

      await client.connect();

      const res = await client.query("SELECT * FROM inventory WHERE expiration_date > CURRENT_TIMESTAMP ORDER BY inv_order_id ASC");

      client.end();

      return res.rows;
});

exports.addInventoryRow = functions.https.onCall(async (data, context) =>
{

    const client = new Client({
          host: 'csce-315-db.engr.tamu.edu',
          user: 'csce315331_team_13_master',
          password: 'Lucky_13',
          database: 'csce315331_team_13',
          port: 5432,
    });

    await client.connect()

    const values = data.values;
    const maxIdResult = await client.query('SELECT MAX(inv_order_id) AS max_id FROM inventory');
    const maxId = maxIdResult.rows[0].max_id;

    const valuesWithId =
    {
        ...values,
        inv_order_id: maxId + 1
    };

    const query =
    {
        text: 'INSERT INTO inventory(inv_order_id, status, ingredient, amount_inv_stock, amount_ordered, unit, date_ordered, expiration_date, conversion) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)',
        values: Object.values(valuesWithId)
    };

    const res = await client.query(query);

    client.end()

    return maxId + 1;
});

exports.deleteInventoryItem = functions.https.onCall(async (data, context) => {
  const client = new Client({
    host: 'csce-315-db.engr.tamu.edu',
    user: 'csce315331_team_13_master',
    password: 'Lucky_13',
    database: 'csce315331_team_13',
    port: 5432,
  });

  await client.connect();

  const itemName = data.itemName;

  const query =
  {
    text: 'UPDATE inventory SET status = $1 WHERE ingredient = $2',
    values: ['unavailable', itemName],
  };

  const res = await client.query(query);

  client.end();
});

exports.editInventoryEntry = functions.https.onCall(async (data, context) => {
  const itemName = data.itemName;
  const changeAmount = data.changeAmount;

  const client = new Client({
    host: 'csce-315-db.engr.tamu.edu',
    user: 'csce315331_team_13_master',
    password: 'Lucky_13',
    database: 'csce315331_team_13',
    port: 5432,
  });

  await client.connect();

  try {
    let query = {
      text: 'SELECT * FROM inventory WHERE ingredient = $1 AND status = \'available\' ORDER BY expiration_date ASC, date_ordered ASC',
      values: [itemName],
    };

    let result = await client.query(query);

    let remainingChangeAmount = changeAmount;

    for (let row of result.rows)
    {
      const currentAmount = row.amount_inv_stock;
      const currentId = row.inv_order_id;

      if (remainingChangeAmount > 0)
      {
        // Increase the freshest entry
        const query = {
          text: 'UPDATE inventory SET amount_inv_stock = $1 WHERE inv_order_id = $2',
          values: [currentAmount + remainingChangeAmount, currentId],
        };

        await client.query(query);

        remainingChangeAmount = 0;
        break;
      }
      else
      {
        // Decrease the oldest entry
        if (currentAmount >= -remainingChangeAmount) {
          // Sufficient amount in the current entry to satisfy the change
          const query = {
            text: 'UPDATE inventory SET amount_inv_stock = $1 WHERE inv_order_id = $2',
            values: [currentAmount + remainingChangeAmount, currentId],
          };

          await client.query(query);

          remainingChangeAmount = 0;
          break;
        }
        else
        {
          // Not enough amount in the current entry to satisfy the change
          const query = {
            text: 'UPDATE inventory SET amount_inv_stock = 0 WHERE inv_order_id = $1',
            values: [currentId],
          };

          await client.query(query);

          remainingChangeAmount += currentAmount;
        }
      }
    }

    if (remainingChangeAmount != 0) {
      // Not enough inventory to satisfy the requested change
      return false;
    } else {
      return true;
    }
  } catch (error) {
    throw new functions.https.HttpsError('internal', error);
  } finally {
    client.end();
  }
});

exports.getSmoothie = functions.https.onCall(async (data, context) =>
{
      const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
      });

      await client.connect();

      const res = await client.query("SELECT menu_item_id FROM menu_items WHERE type IN ('smoothie')");

      client.end();

      return res.rows;
});

exports.getInventoryMin = functions.https.onCall(async (data, context) =>
{
      const client = new Client({
        host: 'csce-315-db.engr.tamu.edu',
        user: 'csce315331_team_13_master',
        password: 'Lucky_13',
        database: 'csce315331_team_13',
        port: 5432,
      });

      await client.connect();

      const res = await client.query("SELECT ingredient, minimum FROM inventory_minimums");

      client.end();

      return res.rows;
});


exports.generateWeekOrders = functions.https.onCall(async (data, context) => {
  const client = new Client({
    host: 'csce-315-db.engr.tamu.edu',
    user: 'csce315331_team_13_master',
    password: 'Lucky_13',
    database: 'csce315331_team_13',
    port: 5432,
  });

  await client.connect();

  const res = await client.query("SELECT item_ids_in_order FROM order_history WHERE date_of_order >= '2022-12-1'::date - interval '7 days' AND date_of_order < '2022-12-1'::date");

  client.end();
  return res.rows;
});


exports.generateRestockReport = functions.https.onCall(async (data, context) => {
  const client = new Client({
    host: 'csce-315-db.engr.tamu.edu',
    user: 'csce315331_team_13_master',
    password: 'Lucky_13',
    database: 'csce315331_team_13',
    port: 5432,
  });

  await client.connect();

  try {
    const minAmount = new Map();
    const invMin = data.invMin;

    for (var entry in invMin.entries) {
      var ingredient = entry.key;
      var minimum = entry.value;
      minAmount[ingredient] = minimum;
    }


    const query = {
      text: 'SELECT ingredient, amount_inv_stock FROM inventory',
    };

    const result = await client.query(query);
    const result2 = await client.query("UPDATE inventory SET amount_inv_stock = 0 WHERE status = 'unavailable'");

    const mapToReturn = new Map();

    for (let row of result.rows) {
      const ingredient = row.ingredient;
      const amountInvStock = row.amount_inv_stock;

      if (minAmount.has(ingredient) && amountInvStock < minAmount.get(ingredient)) {
        const newAmount = Math.round(minAmount.get(ingredient) * 1.1);
        mapToReturn.set(ingredient, newAmount);
      }
    }

    const objToReturn = Object.fromEntries(mapToReturn);

    return objToReturn;
  } catch (error) {
    throw new functions.https.HttpsError('internal', error);
  } finally {
    client.end();
  }
});

exports.getAllSmoothieIngredients = functions.https.onCall(async (data, context) =>
 {
       const client = new Client({
         host: 'csce-315-db.engr.tamu.edu',
         user: 'csce315331_team_13_master',
         password: 'Lucky_13',
         database: 'csce315331_team_13',
         port: 5432,
       });

       await client.connect();

       const res = await client.query("select menu_item_id, ingredient_name, ingredient_amount from ingredients_table join menu_items on menu_item=menu_item_name where type='smoothie'");

       client.end();

       return res.rows;
 });

exports.getMenuItemsInfo = functions.https.onCall(async (data, context) => {
    const client = new Client({
      host: 'csce-315-db.engr.tamu.edu',
      user: 'csce315331_team_13_master',
      password: 'Lucky_13',
      database: 'csce315331_team_13',
      port: 5432,
    });

    await client.connect()

    const res = await client.query("SELECT * FROM menu_items");

    client.end();

    return res.rows

});



