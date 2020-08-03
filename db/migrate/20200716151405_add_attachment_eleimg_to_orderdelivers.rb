class AddAttachmentEleimgToOrderdelivers < ActiveRecord::Migration[6.0]
  def self.up
    change_table :orderdelivers do |t|
      t.attachment :eleimg
    end
  end

  def self.down
    remove_attachment :orderdelivers, :eleimg
  end
end
