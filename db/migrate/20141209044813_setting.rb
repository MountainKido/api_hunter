class Setting < ActiveRecord::Migration
  def change
    create_table 'settings' do |t|
      t.string 'name' , :null => false
      t.integer 'kind' , :limit => 1, :default => 0 , :null => false
      t.string 'value' , :null => false
    end
    add_index 'settings' , ['name']
  end
end
