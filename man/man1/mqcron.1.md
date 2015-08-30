# mqcron 1 "August 2015" Durchmesser.ch "User Manuals"

## NAME

mqcron - MessageQueue/RabbitmQ cron daemon

## SYNOPSIS

`mqcron` `--crontab` *mqcrontab-file* 

## DESCRIPTION

Connects to the RabbitMQ with the connection settings in the mqcrontab and
binds to the given exchanges. For each message the command who has 
subscribed to the matching exchange and routing_key is executed.

## OPTIONS

`-c`, `--crontab`
  Path to the crontab file.

`-l`, `--logfile`
  Path to the logfile.

`-p`, `--piddir`
  Path to the pidfile.

`-d`, `--debug`
  Run in foreground.

## NOTES

The message payload is availabel to the executed command on STDIN. Informations
about the message can be optained from the environment. Delivery informations
are prefixed with `MESSAGE_` and uppercased. Medatata informations are prefixed
with `METADATA_` and uppercased.

### ENVIRONMENT Examples

`MESSAGE_EXCHANGE`
  Name of the exchange the message was sent to.

`MESSAGE_ROUTING_KEY`
  The routing_key of the message.

`METADATA_CONTENT_TYPE`
  MIME content type of the payload.

## ENVIRONMENT

`RABBITMQ_URL`
  If not-null the `RABBITMQ_URL` replaces the built in default uri.
  Overridden by the connection parameters in the mqcrontab.

## AUTHOR

Marius Rieder <marius.rieder@durchmesser.ch>

# SEE ALSO

mqcrontab(5)
