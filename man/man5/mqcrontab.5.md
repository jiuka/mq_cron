# mqcrontab 5 "August 2015" Durchmesser "User Manuals"

## NAME

mqcrontab - tables for driving mqcron

## DESCRIPTION

A _mqcrontab_ file contains instructions to the _mqcron_(1) daemon. It
instructs the daemon to run the command if a message from the exchange with
a matching routing_key arrived.

Blank lines and lines whose first non-space character is a hash-sign (#) are
ignored as comments. Note that comments are not allowed on the same line as
cron commands or environment variable settings. They will be taken to be part
of the command or environment variable.

Environment variable settings of variables beginning with `RABBITMQ_` are
treated as connection settings and will not be added to the environment.

The _mqcron_ daemon creates its own non persistant queue. This queue is named
`mqcron-<hostname>-<pid>` to avoid naming collisions.

## COMMANDS

Commands are specified as follows.

`exchange.name` `routing.key.#` `/path/to/command`

If the _exchange_ does not exist it will be createt as non persistant and
auto removing exchange.

## ENVIRONMENT

Environment variable settings are specified as follows.

`KEY`=`VALUE`

The value can optionally be enclosed in single (') or double (") quoted.

## CONNECTION SETTINGS

Connection settings are specified as environment variable starting with
`RABBITMQ_`. Known connection settings are:

`RABBITMQ_URL`
  Connection settings encodes as uri. (Ex: amqps://user:pass@host:port/)

`RABBITMQ_HOST`
  Hostname or IP address to connect to.

`RABBITMQ_HOSTS`
  List of hostname or IP addresses to select hostname from when connecting.

`RABBITMQ_POST`
  Port RabbitMQ listens on.

`RABBITMQ_USERNAME`
  Username

`RABBITMQ_PASSWORD`
  Password

`RABBITMQ_VHOST`
  Virtualhost to use. (Default: /)

## AUTHOR

Marius Rieder <marius.rieder@durchmesser.ch>

## SEE ALSO

mqcron(1), [Bunny Connection Settings](http://reference.rubybunny.info/Bunny/Session.html#initialize-instance_method)
