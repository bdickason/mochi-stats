### Data models and interface with Mysql ###
Mysql = require 'mysql'
cfg = require '../cfg/config.js'

exports.Db = class Db
  constructor: (cfg) ->
    # Start up Mysql
    @mysql = Mysql.createConnection {
      host: "#{cfg.DB_HOSTNAME}",
      port: "#{cfg.DB_PORT}"
      user: "#{cfg.DB_USERNAME}",
      password: "#{cfg.DB_PASSWORD}",
      database: "#{cfg.DB_DATABASE}"
    }
    
    @mysql.connect (err) ->
      if err
        console.log "Error: " + err

  getCustomers: (startDate, endDate, callback) ->
    if !startDate and !endDate
      # No date set - Default to last 7 days
  
      @mysql.query "SELECT * FROM users as u INNER JOIN transactions as t ON t.transaction_uid = u.uid WHERE u.date_added between date_sub(now(),INTERVAL 1 WEEK) and now() AND t.transaction_created_date between date_sub(now(),INTERVAL 1 WEEK) and now()", (err, rows) ->
        console.log err
        console.log rows

        callback err, rows        
    else
      @mysql.query "SELECT * FROM users as u INNER JOIN transactions as t ON t.transaction_uid = u.uid WHERE t.transaction_created_date > WHERE t.transaction_created_date >= #{startDate} AND t.transaction_created_date < #{endDate}", (err, rows) ->
      
        console.log err
        console.log rows
  
        callback err, rows
    
  getTransaction: (id, callback) ->
    if id
      @mysql.query "Select * FROM transactions WHERE transaction_id = #{id}", (err, rows) ->
        if err
          console.log "Error: " + err
      
        callback err, rows
    else
      err = "Error: No id defined"
      callback err, null

  getTaxByQuarter: (startDate, endDate, giftCards, voided, callback) ->
    if startDate and endDate
      query = "
      SELECT te.transaction_entry_type as type, SUM( te.transaction_entry_price_added ) as total 
      FROM `transactions_entries` as te
      INNER JOIN transactions as t
      ON t.transaction_id = te.transaction_id
      WHERE te.transaction_entry_date_added >= '#{startDate} 00:00:01'
      AND te.transaction_entry_date_added < '#{endDate} 00:00:01' "
      
      if voided
        query += " AND t.transaction_void != 1 "

      if giftCards
        query += "AND ! ( te.transaction_entry_type =  'service'
        AND (
        te.transaction_entry_service_id =  '11'
        OR te.transaction_entry_service_id =  '9'
        )
        AND te.transaction_entry_uid =  '3704' ) "
        
      query += "GROUP BY te.transaction_entry_type"
    
      @mysql.query query, (err, rows) ->
        if err
          console.log 'Error: ' + err
      
        callback err, rows
    else
      if !startDate
        err = "Error: No start date defined"
      else if !endDate
        err = "Error: No end date defined"

      callback err, null


      
  test: (callback) ->
    @mysql.query "SELECT 1", (err, rows) ->
      if err
        console.log "Error: " + err
        
      callback err, rows
