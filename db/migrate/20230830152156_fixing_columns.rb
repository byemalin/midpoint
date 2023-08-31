class FixingColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column(:destinations, "midpoint?", "is_midpoint")
    rename_column(:destinations, "recommended?", "is_recommended")
    remove_column "destinations", "country"
  end
end
