require "kafka"

brokers = ENV.fetch('KAFKA_BROKERS', '0.0.0.0:9092').split(',')
client_id = ENV['CLIENT_ID']
kafka_partitions = ENV.fetch('KAFKA_PARTITIONS', 1).to_i
$topics = ENV.fetch('TOPICS', 'any').split(',')

# The first argument is a list of "seed brokers" that will be queried for the full
# cluster topology. At least one of these *must* be available. `client_id` is
# used to identify this client in logs and metrics. It's optional but recommended.
$kafka = Kafka.new(brokers, client_id: client_id, logger: Rails.logger)

# Some cool stuff to manage kafka broker
# $kafka.create_topic(topic, num_partitions: kafka_partitions, replication_factor: 1, timeout: 30)
# $kafka.describe_topic(topic)
# $kafka.partitions_for(topic)
# $kafka.last_offsets_for(topic)
# $kafka.topics
# $kafka.groups

# Consumer first
$consumer = $kafka.consumer(group_id: "#{client_id}_group")
$consumer_messages = []

# Subscribe to all Kafka topics on env:
$topics.each do |topic|
  $consumer.subscribe(topic)
end

Thread.new {
  # This will loop indefinitely, consuming each message in turn.
  $consumer.each_message do |message|
    ReceivedMessage.create!(JSON.parse(message.value))
  end
}

# Producer last
$producer = $kafka.async_producer(
  # Trigger a delivery once 3 messages have been buffered.
  delivery_threshold: 3,
  # Trigger a delivery every 1 seconds.
  delivery_interval: 1,
  # The number of retries when attempting to deliver messages. The default is
  # 2, so 3 attempts in total, but you can configure a higher or lower number:
  max_retries: 5,
  # The number of seconds to wait between retries. In order to handle longer
  # periods of Kafka being unavailable, increase this number. The default is
  # 1 second.
  retry_backoff: 2
)

# Make sure to shut down everything when exiting.
at_exit {
  $producer.shutdown
  $consumer.stop
}
