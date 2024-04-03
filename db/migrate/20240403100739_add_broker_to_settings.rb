class AddBrokerToSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :settings, :broker, :string
  end
end
