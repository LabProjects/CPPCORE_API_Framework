@ignore
  Feature: This list all possible reusable functions
    Scenario:
      * def uuid = function(){ return java.util.UUID.randomUUID() + '' }
      * def now = function(){ return java.lang.System.currentTimeMillis() }
      * def sTotalLength = function(args){return args.length}