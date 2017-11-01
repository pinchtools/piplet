class RenameTargetUserIdToConcernedUserIdOnUserHistory < ActiveRecord::Migration[5.1]
  def change
    rename_column :user_histories, :target_user_id, :concerned_user_id
  end
end
