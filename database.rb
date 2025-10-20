require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "fraudes.db"
)

unless ActiveRecord::Base.connection.table_exists?(:transactions)
  ActiveRecord::Schema.define do
    create_table :transactions do |t|
      t.string :transaction_id
      t.string :user_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :location
      t.boolean :fraudulent
      t.timestamps
    end
  end
end