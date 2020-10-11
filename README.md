# EventPlatform

To start Application server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`



# Event Manager


Following are the two roles in the platform
- Admin
- Member

## Admin
An Admin has following authorization
- To view all the events on the platform
- To create an event
    - Need to provide title, description, start time, end time, location in order to create an event.
- To update an event
- To delete an event
- Admin can send invites to the Users.

## Member
A Member has following authorization
- Can see all the events for which he has the invitation.
- Member can send confirmation for the event.
- Member can reject the invitation.
- Member can see the events for which he has accepted the invitation.




## Database Tables
- users 
- topics_of_interests
- users_topics_of_interests
- events
- invites
   
   <a href="./UML.png">UML</a>

## Code Structure

```shell
lib
├── event_platform
│   ├── event_management
│   └── user_management
│
└── event_platform_web

``` 



## Endpoints    

### Authentication and Authorization
The application use Guardian for authentication using JWT token. Client needs to send the header that looks like below:

```shell
authorization: Bearer <jwt_token_here>
``` 
Application will send 401 in case of invalid token. In case of a user with a role tries to access endpoint ment for other role will get 403 response code. 
This is done using two plugs, 
```shell 
VerifyUser
VerifyRole
 ```


### Controllers
Following controllers are there in application

- user_controller
  - Signup new user with member role
  - list all users
  - show user
  - add topic of interest to the user
  - remove topic of interest from the user
- login_controller
  - Authenticate a user for login
- topic_of_interest_controller
  - list all topic of interests
  - list topic of interests of user
- event_controller
  - Admin endpoints
    - index events in the platform for admin
    - create new event
    - show an event with detatils
    - update an event
    - delete an event
  - Member endpoints
    - index events for which member has invitation
    - list user's upcoming calender events 
- invite_controller
  - Admin endpoints
    - list invitees for an event
    - list invitees of a status for an event 
    - add member to the invited list
  - Member endpoints
    - update invitation for an event with RSVP.




Updated list of enpoints avaliable in <a href="https://www.getpostman.com/collections/8121a02e8b809a194c28">Postman collection</a>

## Seed

Seed file loads the basic test data for all the data base tables.