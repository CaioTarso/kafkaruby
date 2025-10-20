# consumer.rb
require "ruby-kafka"
require "json"
require "time"
require_relative "database"
require_relative "models/transaction"

kafka = Kafka.new(["localhost:9092"], client_id: "fraude-consumer")
topic = "transacoes"

def detectar_fraude(transaction)
  user_id = transaction.user_id
  alerts = []

  if transaction.amount >= 10000
    alerts << "ALTO_VALOR"
  end

  ultimas_transacoes = Transaction.where(user_id: user_id)
                                  .where("created_at >= ?", Time.now - 60)
  if ultimas_transacoes.count >= 4
    alerts << "TEMPO_60s"
  end

  transacoes_geo = Transaction.where(user_id: user_id)
                              .where("created_at >= ?", Time.now - 600)
                              .order(created_at: :desc)
  if transacoes_geo.count >= 2
    cidades = transacoes_geo.pluck(:location).uniq  
    alerts << "GEO_10m" if cidades.size > 1
  end

  alerts
end

kafka.each_message(topic: topic) do |message|
  data = JSON.parse(message.value)

  transaction = Transaction.create!(
    transaction_id: data["transaction_id"],
    user_id: data["user_id"],
    amount: data["amount"],
    location: data["location"],
    fraudulent: false
  )

  alertas = detectar_fraude(transaction)

  if alertas.any?
    transaction.update(fraudulent: true)
    puts "🚨 FRAUDE DETECTADA (#{alertas.join(', ')})"
  else
    puts "✅ Transação normal."
  end

  puts "💳 Detalhes: #{data}\n\n"
end
