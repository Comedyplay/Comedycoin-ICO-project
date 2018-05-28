class AddPhotoToUserProfiles < ActiveRecord::Migration[5.2]
  def change
  	add_attachment :user_profiles, :identity_photo
  	add_attachment :user_profiles, :user_photo
  end
end
