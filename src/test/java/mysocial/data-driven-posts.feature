
Feature: Verify post api for mysocial with data driven approach

Background: Initialise stuff
    Given url 'https://jsonplaceholder.typicode.com'


Scenario Outline: Verify /post/<postID> works
    Given path 'posts'
    And path <postID>
    When method get
    Then status 200
    And match response ==
    """
    {
        "userId": '#number',
        "id": <postID>,
        "title": '#string',
        "body": '#string'
    }

    """
    Examples:
        |postID|
        |1     |
        |2     |
        |3     |

    Scenario Outline: Verify new post request is created for userid <userId>
        Given path 'posts'
        And header Content-type = 'application/json; charset=UTF-8'
        And request 
        """
            {
                title: <title>,
                body: <body>,
                userId: <userId>,
            }
    
        """
        When method post
        Then status 201
        And match response contains {"userId": <userId>, "id": '#number', "title": <title>, "body": <body> }

        Examples:
            |userId|title|body|
            |1|title1|body1|
            |2|title2|body2|
            |3|title3|body3|

        Scenario Outline: Verify new post request is created for userid <userId> using json file
            Given path 'posts'
            And header Content-type = 'application/json; charset=UTF-8'
            And request 
            """
                {
                    title: <title>,
                    body: <body>,
                    userId: <userId>,
                }
        
            """
            When method post
            Then status 201
            And match response contains {"userId": <userId>, "id": '#number', "title": <title>, "body": <body> }
    
            Examples:
                |read ('post-data.json')|