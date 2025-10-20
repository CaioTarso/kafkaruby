# producer.rb
require "ruby-kafka"
require "faker"
require "json"

Faker::Config.locale = "pt-BR"

kafka = Kafka.new(["localhost:9092"], client_id: "fraude-producer")

topic = "transacoes"

loop do
  transaction = {
    transaction_id: SecureRandom.uuid,
    user_id: rand(1..1000),
    amount: rand(1.0..10000.0).round(2),
    location: Faker::Address.city,
    created_at: Time.now
  }

  kafka.deliver_message(transaction.to_json, topic: topic)

  puts "💸 Transação enviada: #{transaction}"
  sleep 3
end
