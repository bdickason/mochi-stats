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
      
      console.log query
      
      # console.log query
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
