Feature:Modify request on the fly

Background: Initialise stuff
    Given url 'https://jsonplaceholder.typicode.com'
    And def rqst = {userId: '#(userId)', body: '#(body)', title: '#(title)' }

Scenario Outline: Embedded expression 1
    Given path 'posts'
    And request rqst
    And header Content-type = 'application/json; charset=UTF-8'
    When method post
    Then status 201
    And match response contains {"userId": <userId>, "id": '#number', "title": <title>, "body": <body> }

    Examples:
        |userId!|title|body|
        |1|title1|body1|
        |2|title2|body2|
        |3|title3|body3|

