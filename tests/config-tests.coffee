### Tests for Config /cfg ###

cfg = require '../cfg/config.js'
should = require 'should'

    
describe 'Server Config', ->
  it 'Should have a hostname', ->
    tmp = cfg.HOSTNAME
    tmp.should.not.eql ''
    
  it 'Should have a port number', ->
    tmp = cfg.PORT
    tmp.should.not.eql ''
    

describe 'DB Config', ->
  it 'Should have a DB Hostname', ->
    tmp = cfg.DB_HOSTNAME
    tmp.should.not.eql ''
  
  it 'Should have a DB Port number', ->
    tmp = cfg.DB_PORT
    tmp.should.not.eql ''
    
  it 'Should have a DB Username', ->
    tmp = cfg.DB_USERNAME
    tmp.should.not.eql ''
    
  it 'Should have a DB Password', ->
    tmp = cfg.DB_PASSWORD
    tmp.should.not.eql ''
  
  it 'Should have a DB Database', ->
    tmp = cfg.DB_DATABASE
    tmp.should.not.eql ''
