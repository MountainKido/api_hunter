class Setting < ActiveRecord::Base
  def self.get(key)
    Setting.where(key:key).first.value rescue nil
  end
  def self.set(key , value)
    setting = Setting.where(key:key).first
    if setting
      setting.update_attribute('key' , value)
    else
      Setting.create(key:key , value:value)
    end
  end
  def self.del(key)
    Setting.where(key:key).delete_all
  end
end
