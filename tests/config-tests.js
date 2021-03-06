// Generated by CoffeeScript 1.4.0

/* Tests for Config /cfg
*/


(function() {
  var cfg, should;

  cfg = require('../cfg/config.js');

  should = require('should');

  describe('Server Config', function() {
    it('Should have a hostname', function() {
      var tmp;
      tmp = cfg.HOSTNAME;
      return tmp.should.not.eql('');
    });
    return it('Should have a port number', function() {
      var tmp;
      tmp = cfg.PORT;
      return tmp.should.not.eql('');
    });
  });

  describe('DB Config', function() {
    it('Should have a DB Hostname', function() {
      var tmp;
      tmp = cfg.DB_HOSTNAME;
      return tmp.should.not.eql('');
    });
    it('Should have a DB Port number', function() {
      var tmp;
      tmp = cfg.DB_PORT;
      return tmp.should.not.eql('');
    });
    it('Should have a DB Username', function() {
      var tmp;
      tmp = cfg.DB_USERNAME;
      return tmp.should.not.eql('');
    });
    it('Should have a DB Password', function() {
      var tmp;
      tmp = cfg.DB_PASSWORD;
      return tmp.should.not.eql('');
    });
    return it('Should have a DB Database', function() {
      var tmp;
      tmp = cfg.DB_DATABASE;
      return tmp.should.not.eql('');
    });
  });

}).call(this);
