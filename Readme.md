# The Challenge of Accesses

Hello prospective co-worker. Today you stand before the challenge of accesses. We have prepared a bare skeleton app that you can use to complete this challenge using **our** preferred set of tools ie. [activerecord](https://github.com/rails/rails/tree/master/activerecord), [grape](https://github.com/ruby-grape/grape) and [rspec](https://github.com/rspec/rspec). Should you decide for another set of tools, you are free to do so provided you stay within the Ruby world. However be warned that you are responsible for your tools. Their failure is your own.

## Workflow

### Bootstrap

Bootstrap the project like this:

```
docker-compose build
docker-compose run api bin/init.sh
```

You can start the skeleton app by running `docker-compose up` and tests can be run by `docker-compose run api rspec spec`. For a better workflow we recommend doing `docker-compose run api /bin/bash` and then running all the commands from inside docker.

The app contains rake tasks for manipulating ActiveRecord migrations. You can create one like this:

```
docker-compose run api rake db:new_migration[MigrationName]
```

And when you're finished editing the migration file, run the standard

```
docker-compose run api rake db:migrate
docker-compose run api rake db:migrate RACK_ENV=test
```

### Tips

Structuring and naming your commits well might help you succeed! We place great value on re-usability and readability of code. "First make it work, then make it right."

During the development, please adhere to the industry standards to the best of your ability. Do not let your application crash with `500 Internal Server Error` statuses. Instead take care of all the edge cases and return appropriate status codes and response bodies. For example do not let your app crash if I use a non-existing id. Simply return a `404 Not Found` with an error message explaining what happened. All operations must be scoped to the current user of the api (if applicable). Make sure all the common use-cases are covered in specs. Make sure the tests are reasonably fast. Make sure the code is easy to read and speaks for itself.

Note that the description below should give you a set of rules according to which the api should behave but it does not mention some details on purpose. Feel free to improve the concept if you know how and show some initiative. It will be appreciated. Most of all, we appreciate **common sense**.

You will find some pre-filled boilerplate code in the `app` and `spec` directories. There's also some helper methods in `spec/support` which should make writing tests easier.

If you run into problems, do not hesitate to let us know. Teamwork is important for us and relying on the experience of others where your own is lacking from time to time is a part of it.

## The Challenge

Your task is to model 2 types of entities and their relationship. The `user` and the `access`. A user can have multiple accesses at the same time. One access always belongs to a single user. An access has a numeric `level` which is an integer value greater than zero. Additionally it must always have a `starts_at` timestamp attribute and it may have an `ends_at` attribute. A user will have a static token generated at the time he is created. This token must be unique.

You must build a JSON api on top of this model layer.


### Users Api

Let's begin with the users api. Presuming your app runs on localhost:3000 it should behave like this:

```
curl -X POST http://localhost:3000/users
```

This should immediately create a user and return:

```
{
  "user": {
    "id": SOME_ID_HERE,
    "token": "TOKEN_GENERATED_BY_THE_BACKEND",
    "access_level": 0   // 0 indicates the user has no accesses that are currently valid
  }
}
```

Anybody can create a user, this is the only endpoint that requires no security. Next you will need to implement another endpoint which returns the details of a particular user based on his token:

```
curl http://localhost:3000/user -H 'Authentication: Token ACTUAL_TOKEN_HERE'
```

In case the token does not match the api must return a `401 Unauthorized` status. In case the user is found, it must return:

```
{
  "user": {
    "id": SOME_ID_HERE,
    "token": "TOKEN_GENERATED_BY_THE_BACKEND",
    "access_level": THE_COMPUTED_ACCESS_LEVEL_HERE
  }
}
```

If the user has multiple overlapping accesses at the time of the request, then `access_level` is the highest `level` of these accesses.


### Accesses Api

The next step is to create an api for accesses.

```
curl http://localhost:3000/accesses -H 'Authentication: Token ACTUAL_TOKEN_HERE'
```

In the sucecss scenario this should return `200 OK` with:

```
{
  "accesses": [
    {
      "id": FIRST_ACCESS_ID,
      "level": FIRST_ACCESS_LEVEL,
      "starts_at": "FIRST_ACCESS_STARTS_AT",
      "ends_at": "FIRST_ACCESS_ENDS_AT"  // alternatively just null
    },
    {
      "id": SECOND_ACCESS_ID,
      "level": SECOND_ACCESS_LEVEL,
      "starts_at": "SECOND_ACCESS_STARTS_AT",
      "ends_at": "SECOND_ACCESS_ENDS_AT" // alternatively just null
    }
  ]
}
```

Accessees must be sorted by `starts_at` in a descending order so that the most recent accesses will come as first. All accesses must belong to the owner of the token.


```
curl -X POST http://localhost:3000/accesses -H 'Authentication: Token ACTUAL_TOKEN_HERE' -d '{"access" => { "level": NEW_ACCESS_LEVEL, "starts_at": "NEW_ACCESS_STARTS_AT", "ends_at": "NEW_ACCESS_ENDS_AT" }}'
```

The data must be appropriately validated. In case they do not pass validations, the backend must return a `422 Unprocessable Entity` with all the errors explained in the body (still JSON format). In case the data pass validations, the new access model must be immediately created and returned in the same format as above, together with an appropriate success status.

```
curl -X DELETE http://localhost:3000/accesses/:access_id -H 'Authentication: Token ACTUAL_TOKEN_HERE'
```

In case the access_id matches one of the accesses BELONGING TO THE USER WITH THE TOKEN, then the access must be immediately deleted and an appropriate status code and response body returned.


### Testing

**Good tests are a requirement of this challenge, not just a nice to have.** All features must be well covered including security.


Good Luck and May the Source be with you!
