Feature: Verify post api for mysocial

Background: Initialise stuff
Given url 'https://jsonplaceholder.typicode.com'


Scenario: Verify /post works
    Given path 'posts'
    When method get
    Then status 200
    And assert response.length == 100
    And assert responseTime < 1000
    * match responseHeaders['Content-Type'][0] == 'application/json; charset=utf-8'


Scenario: Verify /post works with query parameter
    Given path 'posts'
    And param userId = 1
    When method get
    Then status 200
    And assert response.length == 10
    And match response == '#array'
    And match response[0] == {"userId": '#number', "id": '#number', "title": '#string', "body": '#string' }
    And match response[*] contains {"userId": 1, "id": 1, "title": '#string', "body": '#string' }
    And match each response == {"userId": '#number', "id": '#number', "title": '#string', "body": '#string' }

Scenario: Verify /post/{uid} works
    Given def uid = 1
    And path 'posts'
    And path uid
    When method get
    Then status 200
    And match response ==
    """
    {
        "userId": '#number',
        "id": '#(uid)',
        "title": '#string',
        "body": '#string'
    }

    """
    
Scenario: Verify new post request is created
    Given path 'posts'
    And header Content-type = 'application/json; charset=UTF-8'
    And request 
    """
        {
            title: 'foo',
            body: 'bar',
            userId: 1,
        }

    """
    When method post
    Then status 201
    And match response contains {"userId": '#number', "id": '#number', "title": '#string', "body": '#string' }

Scenario: Verify update of /post/{uid} works
    Given def uid = 1
    And path 'posts'
    And path uid
    And request 
    """
        {
            title: 'foo1',
            body: 'bar1',
            userId: 11,
        }

    """
    When method put
    Then status 200
    And match response ==
    """
    {
        "userId": 11,
        "id": '#number',
        "title": 'foo1',
        "body": 'bar1'
    }

    """

Scenario: Verify Delete of /post/{uid} works
    Given def uid = 1
    And path 'posts'
    And path uid
    When method delete
    Then status 200
    