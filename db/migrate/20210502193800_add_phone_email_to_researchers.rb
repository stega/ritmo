class AddPhoneEmailToResearchers < ActiveRecord::Migration[6.1]
  def change
    add_column :researchers, :phone, :string
    add_column :researchers, :email, :string
  end
end
