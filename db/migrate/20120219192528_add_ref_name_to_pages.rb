class AddRefNameToPages < ActiveRecord::Migration
  def change
		add_column :pages, :ref_name, :string
  end
end
