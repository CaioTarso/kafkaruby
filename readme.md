# Sistema de Detecção de Fraude com Ruby e Kafka

Este projeto é uma simulação de um **sistema de detecção de fraude** em transações financeiras. Ele utiliza **Ruby**, **ActiveRecord** e **Apache Kafka**, com persistência em **SQLite**. O sistema envia, consome e avalia transações simuladas, aplicando regras de fraude.

---

## 🔹 Funcionalidades

- Geração de transações simuladas a cada 3 segundos pelo **Producer**.
- Envio das transações para um **tópico Kafka**.
- **Consumer** que consome as transações, aplica regras de fraude e salva no banco.
- Detecção de fraude baseada em três regras:
  1. **ALTO_VALOR**: transações com `amount >= 10.000`.
  2. **TEMPO_60s**: 4 ou mais transações do mesmo usuário em menos de 60 segundos.
  3. **GEO_10m**: transações do mesmo usuário em cidades diferentes no período de 10 minutos.
- Registro de transações no **SQLite** (`fraudes.db`).
- Alertas de fraude exibidos no console.

---

## 🔹 Tecnologias

- Ruby 3.x
- [ruby-kafka](https://github.com/zendesk/ruby-kafka)
- ActiveRecord 7.x
- SQLite3
- Faker (configurado para cidades brasileiras)
- Docker (para rodar Kafka e Zookeeper)

---

## 🔹 Estrutura do projeto
```bash
kafkaruby/
├── database.rb # Configuração do banco e criação de tabelas
├── models/
│ └── transaction.rb # Modelo de transações
├── producer.rb # Gera e envia transações para Kafka
├── consumer.rb # Consome transações, detecta fraude e persiste no banco
├── Gemfile
├── Gemfile.loc
└── README.md
```

---

## 🔹 Configuração

### 1. Instalar dependências

```bash
bundle install
```
###### Se houver problemas de permissão, use:

```bash
sudo bundle install
```
### 2. Rodar Kafka e Zookeeper

```bash
docker run -d --name zookeeper -p 2181:2181 zookeeper
docker run -d --name kafka -p 9092:9092 --link zookeeper wurstmeister/kafka \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_ADVERTISED_HOST_NAME=localhost
```
### 3. Criando banco de dados
```bash
ruby database.rb
```
---

## 🔹 Rodando o sistema

### Producer 
#### Gera as transações aleatórias e as envia para o kafka
```bash
ruby producer.rb
```

### Consumer 
#### Consome as transações, aplica regras de fraude e persiste no banco:
```bash
ruby consumer.rb
```


