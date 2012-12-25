class Wallpaper < Picture

  before_create :destroy_wallpapers
  def destroy_wallpapers
    asseted.wallpapers.destroy_all
  end

  after_create :save_asseted_background
  def save_asseted_background
    asseted.background = "/wallpapers/original/#{filename}"
    asseted.save
    ap asseted.background
  end

  before_destroy :nillify_asseted_background
  def nillify_asseted_background
    asseted.background = nil
    asseted.save
  end
end

