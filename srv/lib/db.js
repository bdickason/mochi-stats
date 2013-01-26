// Generated by CoffeeScript 1.4.0

/* Data models and interface with Mysql
*/


(function() {
  var Db, Mysql, cfg;

  Mysql = require('mysql');

  cfg = require('../../cfg/config.js');

  exports.Db = Db = (function() {

    function Db(cfg) {
      this.mysql = Mysql.createConnection({
        host: "" + cfg.DB_HOSTNAME,
        port: "" + cfg.DB_PORT,
        user: "" + cfg.DB_USERNAME,
        password: "" + cfg.DB_PASSWORD,
        database: "" + cfg.DB_DATABASE
      });
      this.mysql.connect(function(err) {
        if (err) {
          return console.log("Error: " + err);
        }
      });
    }

    Db.prototype.getCustomers = function(startDate, endDate, callback) {
      if (!startDate && !endDate) {
        return this.mysql.query("SELECT * FROM users as u INNER JOIN transactions as t ON t.transaction_uid = u.uid WHERE u.date_added between date_sub(now(),INTERVAL 1 WEEK) and now() AND t.transaction_created_date between date_sub(now(),INTERVAL 1 WEEK) and now()", function(err, rows) {
          if (err) {
            console.log(err);
          }
          return callback(err, rows);
        });
      } else {
        return this.mysql.query("SELECT * FROM users as u INNER JOIN transactions as t ON t.transaction_uid = u.uid WHERE t.transaction_created_date > WHERE t.transaction_created_date >= " + startDate + " AND t.transaction_created_date < " + endDate, function(err, rows) {
          if (err) {
            console.log(err);
          }
          return callback(err, rows);
        });
      }
    };

    Db.prototype.getTransaction = function(id, callback) {
      var err;
      if (id) {
        return this.mysql.query("Select * FROM transactions WHERE transaction_id = " + id, function(err, rows) {
          if (err) {
            console.log("Error: " + err);
          }
          return callback(err, rows);
        });
      } else {
        err = "Error: No id defined";
        return callback(err, null);
      }
    };

    Db.prototype.getTaxByQuarter = function(startDate, endDate, giftCards, voided, callback) {
      var err, query;
      if (startDate && endDate) {
        query = "      SELECT te.transaction_entry_type as type, SUM( te.transaction_entry_price_added ) as total       FROM `transactions_entries` as te      INNER JOIN transactions as t      ON t.transaction_id = te.transaction_id      WHERE te.transaction_entry_date_added >= '" + startDate + " 00:00:01'      AND te.transaction_entry_date_added < '" + endDate + " 00:00:01' ";
        if (voided) {
          query += " AND t.transaction_void != 1 ";
        }
        if (giftCards) {
          query += "AND ! ( te.transaction_entry_type =  'service'        AND (        te.transaction_entry_service_id =  '11'        OR te.transaction_entry_service_id =  '9'        )        AND te.transaction_entry_uid =  '3704' ) ";
        }
        query += "GROUP BY te.transaction_entry_type";
        return this.mysql.query(query, function(err, rows) {
          if (err) {
            console.log('Error: ' + err);
          }
          return callback(err, rows);
        });
      } else {
        if (!startDate) {
          err = "Error: No start date defined";
        } else if (!endDate) {
          err = "Error: No end date defined";
        }
        return callback(err, null);
      }
    };

    Db.prototype.test = function(callback) {
      return this.mysql.query("SELECT 1", function(err, rows) {
        if (err) {
          console.log("Error: " + err);
        }
        return callback(err, rows);
      });
    };

    return Db;

  })();

}).call(this);
