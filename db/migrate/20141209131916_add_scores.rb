class AddScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :level , :limit => 1 , :default => 0 , :null => false , :unsigned => true
      t.integer :user_id , :null => false , :unsigned => true
      t.boolean :is_success , :default => false , :null => false
      t.boolean :is_callback , :default => false , :null => false
      t.text    :source
      t.text    :result
    end
    add_index :scores , [:level , :user_id] , :unique => true
  end
end
