class AddUserPasswordDigest < ActiveRecord::Migration
  def change
    add_column :member, :password_digest, :string
  end
end
