Feature: PayPointBFF services

  Background:
    * url 'http://localhost:17001'
    * call read('CommonFunctions.feature')

  Scenario Outline: Verify the scenario where <ScenarioName>
    Given path PayPointBFFBase
    And header x-request-id = "0000007321"
    And request
    """
    {
      "transaction_id":'#(Transaction_ID)',
      "amount":#(Amount),
      "pan":'#(Pan)'
    }
    """
    When method POST
    Then status 200
    And print response
    Then match response == <ExpectedResponse>
    @ServiceTest
    Examples:
      | ScenarioName                                          | Pan                 | Amount | Transaction_ID | ExpectedResponse                                                                                                                                                                                                               |
      | All fields are valid (Pan, Amount and Transaction ID) | 9826003801000139425 | 1000   | PPT19000003    | { "transaction_id": "#(Transaction_ID)", "amount": '#(parseInt(Amount))', "pan": "#(Pan)", "code": "#ignore", "message": "The Payment was successful. The account will be updated in maximum 10 min.", "response_code": "00" } |
      | Pan and Amount are valid with invalid Transaction ID  | 9826003801000139425 | 1000   | null           | { "transaction_id": "#(Transaction_ID)", "amount": '#(parseInt(Amount))', "pan": "#(Pan)", "code": "#ignore", "message": "The Payment was successful. The account will be updated in maximum 10 min.", "response_code": "00" } |
      | Fields/rows are exchanged                             | 9826003801000139425 | 1000   | null           | { "transaction_id": "#(Transaction_ID)", "amount": '#(parseInt(Amount))', "pan": "#(Pan)", "code": "#ignore", "message": "The Payment was successful. The account will be updated in maximum 10 min.", "response_code": "00" } |

  Scenario Outline: Verify the scenario where <ScenarioName>
    Given path PayPointBFFBase
    And header x-request-id = "0000007321"
    And request
    """
    {
      "transaction_id":'#(Transaction_ID)',
      "amount":#(Amount),
      "pan":'#(Pan)'
    }
    """
    When method POST
    Then status 400
    And print response
    Then match response == <ExpectedResponse>
    @ServiceTest
    Examples:
      | ScenarioName                                                     | Pan                 | Amount | Transaction_ID | ExpectedResponse                                                                                   |
      | Pan is valid and both Amount and Transaction ID are invalid/null | 9826003801000139425 | 0      | null           | {"transaction_id":null,"amount":0,"pan":null,"code":null,"message":"#ignore","response_code":"05"} |
      | Amount is valid and both Pan and Transaction ID are invalid/null | null                | 1000   | null           | {"transaction_id":null,"amount":0,"pan":null,"code":null,"message":"#ignore","response_code":"05"} |
      | All fields are invalid (Pan, Amount and Transaction ID)          | null                | 0      | null           | {"transaction_id":null,"amount":0,"pan":null,"code":null,"message":"#ignore","response_code":"05"} |
      | Amount is negative and both Pan and Transaction ID are valid     | 9826003801000139425 | -1000  | PPT19000003    | {"transaction_id":null,"amount":0,"pan":null,"code":null,"message":"#ignore","response_code":"05"} |

  Scenario Outline: Verify <ScenarioName>
    Given path PayPointBFFBase
    And header x-request-id = "0000007321"
    And request
    """
    {
      "transaction_id":'#(Transaction_ID)',
      "amount":#(Amount),
      "pan":'#(Pan)'
    }
    """
    When method POST
    Then status 200
    And print response
    * def lnResourceCode = response.code
    And print lnResourceCode
    * def codelength = call sTotalLength lnResourceCode
    And print 'The total code length is:' ,codelength
    And assert lnResourceCode.length == codelength
    @ServiceTest
    Examples:
      | ScenarioName       | Pan                 | Amount | Transaction_ID |
      | The length of code | 9826003801000139425 | 1000   | PPT19000003    |
