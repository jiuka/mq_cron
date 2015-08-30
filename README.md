# mq_cron

mqcron a MessageQueue/RabbitmMQ cron daemon.

Connects to the RabbitMQ with the connection settings in the mqcrontab and
binds to the given exchanges. For each message the command who has 
subscribed to the matching exchange and routing_key is executed.

## Installation

Install it yourself as:

    $ gem install mq_cron

## Usage

Create a mqcrontab file and start the mqcron with atleast the crontab parameter.

crontab --debug --crontab /path/to/mqcrontab


### Example mqcrontab
```
RABBITMQ_URL=amqp://guest:guest@localhost:5672

mqcron.exchange message.# /path/to/command
```

## Contributing

1. Fork it ( https://github.com/jiuka/mq_cron/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
