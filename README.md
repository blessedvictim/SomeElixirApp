# Run app 'Testapp'

 # There are two ways to start this app:

  * ## Start app with docker-compose
    #### requirements:
      ```docker, docker-compose supports 3.x docker-compose format ``` 
      ___
      #### Run that commands
      1. ```git clone https://github.com/blessedvictim/SomeElixirApp && cd SomeElixirApp``` 
      2. ```docker-compose up```

  * ## Manually start app with mix
    #### requirements:
      ```Elixir 1.9+ ,Redis 5+```
    ___
    #### Run that commands
      1. ```git clone https://github.com/blessedvictim/SomeElixirApp && cd SomeElixirApp``` 
      2. ```mix local.hex --force && mix local.rebar --force```
      3. ```mix archive.install hex phx_new 1.4.11 --force```
      4. ```REDIS_URL='place here your REDIS url' PORT=4005 MIX_ENV=prod mix phx.server```
___
# Testing application


  * ## Testing app with docker-compose
    Same as steps in
    >Manually start app with mix

    but replace step 2 cmd with ```docker-compose -f docker-compose-test.yml up ```
  * ## Manually testing
    Same as steps in
    >Start app with docker-compose

    but replace step 4 cmd with ```REDIS_URL='place here your REDIS url' PORT=4000 MIX_ENV=prod mix test```