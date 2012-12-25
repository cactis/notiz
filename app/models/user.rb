# encoding: utf-8
class User < ActiveRecord::Base
  extend UserExtend

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :nickname, :blog, :description, :notified, :confirmed_at, :confirmation_token,
    :sign_in_from, :sign_up_from, :blog, :gender, :tags_list

  serialize :options
  custom_options = [
    ['tags_list', 'String', '99999'],
    ['tagnames', 'Hash', nil],
    ['styles', 'Hash', nil]
  ]
  acts_as_custom_options custom_options

  %w(font_size).each do |sty|
    attr_accessible sty.to_sym
    class_eval %(
      def #{sty}
        styles && styles[sty]
      end

      def #{sty}=value
        if self.options
          if self.options[:styles]
            self.options[:styles][:#{sty}] = value
          else
            self.options[:styles] = {:#{sty} => value}
          end
        else
          self.options = {:styles => {:#{sty} => value}}
        end
      end
    )
  end

  def font_size
    options && options[:styles] && options[:styles][:font_size] ? options[:styles][:font_size].gsub('px', '') : 14
  end

  def styles
    if options && options[:styles]
      options[:styles].map{|k, v| "#{k.to_s.gsub('_', '-')}: #{v}"}.join('; ')
    else
      ''
    end
  end

  has_many :posts, :dependent => :destroy
  has_many :trees, :dependent => :destroy
  has_many :assets, :dependent => :destroy

  has_many :attaches

  has_many :pictures
  has_many :notes
  has_many :images
  has_many :wallpapers
  has_many :clips
  has_many :tags

  after_create :signup_admin_notification
  def signup_admin_notification
    UserMailer.signup_admin_notification(self).deliver
  end

  def notifications
    Interaction.where(["email = ? and s_active = ? and (o_active = ? or (objectable_type is null and objectable_id is null))", email, true, false])
  end

  def name
    email.split('@')[0]
  end

  def title
    name #self == User.current ? '我' : name
  end

  def self.init_picture_width_height
    all.each do |u|
      User.current = u
      u.images.each do |pic|
        pic.width = nil
        pic.height = nil
        pic.save_without_timestamping
      end
      u.wallpapers.each do |pic|
        pic.width = nil
        pic.height = nil
        pic.save_without_timestamping
      end
    end
  end

  # 所有個人的主動互動記錄
  has_many :interactions, :dependent => :destroy

  # 所有個人的主動互動記錄
  has_many :subjectables, :class_name => 'Interaction', :as => 'subjectable', :dependent => :destroy
  # 所有個人的主動分享記錄，同上，針對分享
  has_many :subject_sharings, :class_name => 'Sharing', :as => 'subjectable'

  # 所有個人的被動互動記錄
  has_many :objectables, :class_name => 'Interaction', :as => 'objectable', :dependent => :destroy
  # 所有個人的被動分享記錄，同上，針對分享
  has_many :object_sharings, :class_name => 'Sharing', :as => 'objectable'

  # 所有個人作為物件的記錄
  has_many :thingables, :class_name => 'Interaction', :as => 'thingable', :dependent => :destroy

  # has_many :sharings, :as => :objectable
  # has_many :tags, :through => :sharings, :source => :thingable, :source_type => 'Tree'

  # 取得被分享的物件
  # has_many :thingables, :through => :object_sharings

  devise :database_authenticatable, :registerable, :confirmable, :lockable,# :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :oauthable#, :encryptable, :token_authenticatable

  def username; email.split('@')[0]; end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      user = User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
      user.confirm!
    end
    return user
  end

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']# ['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      user = User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
      user.confirm!
    end
    return user
  end

  def self.find_for_twitter_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']# ['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

#  acts_as_configurable do |c|
#    c.string :prev_read, :default => ""
#    c.integer :paper_category_id, :default => nil
#    c.string :paper_location
#    c.integer :paper_quantity
#    c.string :top_tags
#    c.string :blog
#    c.string :top_tags_time
#    c.integer :font_size, :default => 40
#    c.string :sign_up_from, :default => 'Xuelele'
#    c.string :sign_in_from, :default => 'Xuelele'
#    c.string :gender
#    c.string :facebook_id
#    c.boolean :certified
#    c.string :official_title
#    c.string :emails_list, :default => ""
#  end

# def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
#    data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me?'))
#    if user = User.find_by_email(data["email"])
#      user.confirmed_at = Time.now
#      user.confirmation_token = nil
#      user.facebook_id = data['id']
#      user.sign_in_from = 'Facebook'
#      user.blog = data['website'] || data['link'] if !user.blog.present?
#      user.gender = data['gender']
#      user.save_without_timestamping
#      user
#    else # Create an user with a stub password.
#      User.create!( :email => data["email"],
#                    :password => Devise.friendly_token[0,20],
#                    :facebook_id => data['id'],
#                    :nickname => data['name'],
#                    :confirmed_at => Time.now,
#                    :confirmation_token => nil,
#                    :sign_up_from => 'Facebook',
#                    :sign_in_from => 'Facebook',
#                    :blog => data['website'] || data['link'],
#                    :gender => data['gender']
#                  )
#    end
#  end

end
