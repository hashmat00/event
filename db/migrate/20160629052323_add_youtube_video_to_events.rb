class AddYoutubeVideoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :youtube_video, :string
	add_column :events, :vimeo_video, :string
  end
end
