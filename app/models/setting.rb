class Setting < ActiveRecord::Base
  def self.get(name)
    Setting.where(name:name).first.value rescue nil
  end
  def self.set(name , value)
    setting = Setting.where(name:name).first
    if setting
      setting.update_attribute('name' , value)
    else
      Setting.create(name:name , value:value)
    end
  end
  def self.del(name)
    Setting.where(name:name).delete_all
  end
end
