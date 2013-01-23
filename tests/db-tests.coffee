### Tests for Database /lib/db.coffee ###

cfg = require '../cfg/config.js'
should = require 'should'
Db = (require '../lib/db.js').Db

### Initialize DB ###
db = new Db cfg
    
describe 'Connect to MySQL server', ->
  it 'Should return a basic query', (done) ->
    db.test (err, callback) ->
      # Stub data
      sampleRow = JSON.stringify {'1': 1}

      row = callback[0]
      should.not.exist err      
      JSON.stringify(row).should.equal sampleRow      
      done()

describe 'Get a single transaction', ->
  it 'Should return a known transaction', (done) ->
    # Stub Data
    sampleTransactionID = 1
    sampleRow = { 
      transaction_id: 1,
      transaction_payment_type: "visa",
      transaction_void: 0,
      transaction_total: 4.90
    }
    
    db.getTransaction sampleTransactionID, (err, callback) ->
      should.not.exist err

      row = callback[0]
      row.transaction_id.should.equal sampleRow.transaction_id
      row.transaction_payment_type.should.equal sampleRow.transaction_payment_type
      row.transaction_void.should.equal sampleRow.transaction_void
      row.transaction_total.should.equal sampleRow.transaction_total
      
      done()

  it 'Should error out if no id is provided', (done) ->
    sampleTransactionID = null
    
    db.getTransaction sampleTransactionID, (err, callback) ->
      should.exist.err
      err.should.equal "Error: No id defined"
      should.not.exist callback
      done()

describe 'Get a group of transaction entries by date', ->
      
  it 'Should return a set of transaction entries given a start and end date', (done) ->
    # Stub Data
    sampleStartDate = "2012-06-01 00:00:01"
    sampleEndDate = "2012-09-01 00:00:01"
    sampleGiftCards = false
    sampleVoided = true
    
    sampleRow = { 
      transaction_id: 1,
      transaction_payment_type: "visa",
      transaction_void: 0,
      transaction_total: 4.90
    }
    
    db.getTaxByQuarter sampleStartDate, sampleEndDate, sampleGiftCards, sampleVoided, (err, callback) ->
      should.not.exist err
      rows = callback
      rows[0].type.should.equal 'service'
      rows[0].total.should.equal 154196
      rows[1].type.should.equal 'product'
      rows[1].total.should.equal 18249.45

      done()

  
  it 'Should error out if no start date is provided', (done) ->
    sampleStartDate = null
    sampleEndDate = "blah"
    sampleGiftCards = false
    sampleVoided = false

    db.getTaxByQuarter sampleStartDate, sampleEndDate, sampleGiftCards, sampleVoided, (err, callback) ->
      should.exist.err
      err.should.equal "Error: No start date defined"
      should.not.exist callback
      done()

  it 'Should error out if no end date is provided', (done) ->
    sampleStartDate = "blah"
    sampleEndDate = null
    sampleGiftCards = false
    sampleVoided = false

    db.getTaxByQuarter sampleStartDate, sampleEndDate, sampleGiftCards, sampleVoided, (err, callback) ->
      should.exist.err
      err.should.equal "Error: No end date defined"
      should.not.exist callback
      done()