Feature: PayPointBFF services

  Background:
    * url 'http://localhost:17002/'
    * call read('CommonFunctions.feature')

  Scenario Outline: Verify the scenario where <ScenarioName>
    Given path 'api/IvrPrePay/VendTopUp'
    And header x-request-id = "0000007321"
    And request
    """
    {
      "cardId": '#(CardID)',
      "creditRequested": #(Credit),
      "paymentToken": '#(paymentToken)'
    }
    """
    When method POST
    Then status 200
    And print response
    Then match response == <ExpectedResponse>
    @ServiceTest
    Examples:
      | ScenarioName                                           | CardID              | Credit | paymentToken  | ExpectedResponse                                                                                                                                |
      | All fields are valid (CardID, Credit and paymentToken) | 9826003801000139425 | 244    | payment-token | { "error": null, "paymentExpected": '#(parseInt(Credit))', "paymentTaken": '#(parseInt(Credit))', "utrn": "#ignore", "requestSucceeded": true } |
      | CardID and Credit are valid with invalid paymentToken  | 9826003801000139425 | 1000   | 232Run        | { "error": null, "paymentExpected": '#(parseInt(Credit))', "paymentTaken": '#(parseInt(Credit))', "utrn": "#ignore", "requestSucceeded": true } |
      | Fields/rows are exchanged                              | 9826003801000139425 | 5000   | payment-token | { "error": null, "paymentExpected": '#(parseInt(Credit))', "paymentTaken": '#(parseInt(Credit))', "utrn": "#ignore", "requestSucceeded": true } |

  Scenario Outline: Verify the scenario where <ScenarioName>
    Given path 'api/IvrPrePay/VendTopUp'
    And header x-request-id = "0000007321"
    And request
    """
    {
      "cardId": '#(CardID)',
      "creditRequested": #(Credit),
      "paymentToken": '#(paymentToken)'
    }
    """
    When method POST
    Then status 400
    And print response
    Then match response == <ExpectedResponse>
    @ServiceTest
    Examples:
      | ScenarioName                                                      | CardID              | Credit | paymentToken  | ExpectedResponse                                                                                                                                 |
      | CardID is valid, and credit is set to 0 and invalid paymentToken  | 9826003801000139425 | 0      | 232Run        | {"paymentExpected":0,"requestSucceeded":false,"error":"#ignore","paymentTaken":0,"utrn":null}                                                    |
      | Credit is valid and both CardID and paymentToken are invalid      | 0000000000000000000 | 1000   | 232Run        | {"paymentExpected":0,"requestSucceeded":false,"error":"#ignore","paymentTaken":0,"utrn":null}                                                    |
      | All fields are invalid (CardID, Credit and paymentToken)          | 0000000000000000000 | 0      | 232Run        | {"paymentExpected":0,"requestSucceeded":false,"error":"#ignore","paymentTaken":0,"utrn":null}                                                    |
      | Credit is negative and both CardID and paymentToken are valid     | 9826003801000139425 | -1000  | payment-token | {"paymentExpected":0,"requestSucceeded":false,"error":"#ignore","paymentTaken":0,"utrn":null}                                                    |
      | Credit is alphanumeric and both CardID and paymentToken are valid | 9826003801000139425 | 345t4  | payment-token | {"traceId":"#ignore","type":"#ignore","title":"One or more validation errors occurred.","errors":{"$.creditRequested":["#ignore"]},"status":400} |


  Scenario Outline: Verify <ScenarioName>
    Given path 'api/IvrPrePay/VendTopUp'
    And header x-request-id = "0000007321"
    And request
    """
    {
      "cardId": '#(CardID)',
      "creditRequested": #(Credit),
      "paymentToken": '#(paymentToken)'
    }
    """
    When method POST
    Then status 200
    And print response
    * def lnutrn = response.utrn
    And print lnutrn
    * def utrnlength = call sTotalLength lnutrn
    And print 'The total code length is:' ,utrnlength
    And assert lnutrn.length == utrnlength
    @ServiceTest
    Examples:
      | ScenarioName       | CardID              | Credit | paymentToken  |
      | The length of utrn | 9826003801000139425 | 1000   | payment-token |
