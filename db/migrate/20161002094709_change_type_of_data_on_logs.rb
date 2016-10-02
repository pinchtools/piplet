class ChangeTypeOfDataOnLogs < ActiveRecord::Migration
  def up
    change_column :logs, :data, 'jsonb USING data::jsonb'
  end

  def down
    change_column :logs, :data, 'text USING data::text'
  end
end
