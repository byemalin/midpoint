class RenameLatitudeTypoColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column(:destinations, :latitute, :latitude)
  end
end
