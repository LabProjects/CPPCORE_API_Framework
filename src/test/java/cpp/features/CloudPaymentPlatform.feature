Feature: Cloud Payment Platform services

  Background:
    * url 'http://localhost:12000'

  Scenario Outline: Verify the scenario where <ScenarioName>
    Given path GloudPaymentsPlatformBase
    And header x-request-id = "0000007321"
    And request
    """
  {
    "clientDetails": {
        "type": "PayPoint",
        "version": "v1.0.0",
        "clientDefinedData": {
            "x-request-id": "6446345352354354363",
            "operatingSystem": "Mac"
        }
    },
    "orderDetails": {
        "reference": "ORD-REF-001",
        "items": [
            {
                "pan": '#(Pan)',
                "amount": #(Amount),
                "generateUniqueReference": true,
                "takePayment": true,
                "sendConfirmation": true
            }
        ]
    },
    "paymentDetails": {
        "clientReference": "PAY-REF-001",
        "token": "some-payment-token",
        "billing": {
            "firstName": null,
            "lastName": null,
            "address1": null,
            "address2": null,
            "district": null,
            "city": null,
            "county": null,
            "postalCode": null,
            "country": null
        }
    },
    "confirmationDetails": {
        "emailAddress": "test@somemockdomain.co.uk",
        "smsNumber": "07654 654321"
    }
}
    """
    When method POST
    Then status 200
    And print response
    Then match response == <ExpectedResponse>
    @ServiceTest
    Examples:
      | ScenarioName                          | Pan                 | Amount | Transaction_ID | ExpectedResponse                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | All fields are valid (Pan and Amount) | 9826003801000139425 | 1000   | PPT19000003    | {"clientDetails":{"type":"PayPoint","version":"v1.0.0","clientDefinedData":{"xRequestId":null,"operatingSystem":"Mac"}},"orderDetails":{"reference":"ORD-REF-001","orderStatus":"SuccessfulVend","items":[{"pan":"#(Pan)","panType":"Smets1","amount":'#(parseInt(Amount))',"uniqueReference":"#ignore","uniqueReferenceFormatted":"#ignore","errors":null}]},"paymentDetails":{"clientPaymentReference":"PAY-REF-001","paymentProviderReference":"#ignore","authorisationAmount":'#(parseInt(Amount))',"captureAmount":'#(parseInt(Amount))',"paymentStatus":"Captured"},"confirmationDetails":{"emailSent":null,"smsSent":null},"errors":null,"responseCode":"Success"} |
      | Amount is valid and Pan is invalid    | 9826003801000139420 | 1000   | PPT19000003    | {"clientDetails":{"type":"PayPoint","version":"v1.0.0","clientDefinedData":{"xRequestId":null,"operatingSystem":"Mac"}},"orderDetails":{"reference":"ORD-REF-001","orderStatus":"FailedVend","items":[{"pan":"#(Pan)","panType":"Smets1","amount":"#(parseInt(Amount))","uniqueReference":null,"uniqueReferenceFormatted":null,"errors":["#ignore"]}]},"paymentDetails":{"clientPaymentReference":"PAY-REF-001","paymentProviderReference":null,"authorisationAmount":"#(parseInt(Amount))","captureAmount":0,"paymentStatus":"Reversed"},"confirmationDetails":{"emailSent":null,"smsSent":null},"errors":["#ignore"],"responseCode":"DeclinedCouldNotVend"}             |

  Scenario Outline: Verify the scenario where Amount is null or set to Zero
    Given path GloudPaymentsPlatformBase
    And header x-request-id = "0000007321"
    And request
    """
  {
    "clientDetails": {
        "type": "PayPoint",
        "version": "v1.0.0",
        "clientDefinedData": {
            "x-request-id": "6446345352354354363",
            "operatingSystem": "Mac"
        }
    },
    "orderDetails": {
        "reference": "ORD-REF-001",
        "items": [
            {
                "pan": '#(Pan)',
                "amount": #(Amount),
                "generateUniqueReference": true,
                "takePayment": true,
                "sendConfirmation": true
            }
        ]
    },
    "paymentDetails": {
        "clientReference": "PAY-REF-001",
        "token": "some-payment-token",
        "billing": {
            "firstName": null,
            "lastName": null,
            "address1": null,
            "address2": null,
            "district": null,
            "city": null,
            "county": null,
            "postalCode": null,
            "country": null
        }
    },
    "confirmationDetails": {
        "emailAddress": "test@somemockdomain.co.uk",
        "smsNumber": "07654 654321"
    }
}
    """
    When method POST
    Then status 400
    And print response
    * def ExpectedResponse =
    """
    {
        "reason": "InvalidData",
        "message": "Order item amount of £0.00 must be positive."
      }
    """
    Then match response == ExpectedResponse
    @ServiceTest
    Examples:
      | Pan                 | Amount |
      | 9826003801000139425 | 0      |
