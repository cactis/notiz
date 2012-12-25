# encoding: utf-8
class Note < Post
  has_paper_trail :only => [:body], :on => [:update, :destroy]

  def subject
    self[:subject] || "(標題)"
  end

  before_create :init
  def init
    # random_color =  %w(#ccc #000 #fff #e7eb7f #eb8181 #ebbb81 #ebeb81 #abeb81 #81eba3 #81ebd6 #81cfeb #819feb #9181eb #c881eb #eb81eb #eb81bd #eb8181).sort_by{rand()}.first
    color = hsv2rgb
    h = rand(360)
    self.subject_background = hsv2rgb(h, 25, 96) #random_color
    self.body_background = hsv2rgb(h, 25, 96) # random_color
  end

  #h => 0~360 , s => 0~100 , v => 0~100
  def hsv2rgb(h = rand(360),s = 50 + rand(25) ,v = 90 + rand(10))
    # s = 23.0
    # v = 96.0
    h /= 360.0
    s /= 100.0
    v /= 100.0

    i = (h * 6.0).floor;
    f = h * 6.0 - i;
    p = v * (1.0 - s);
    q = v * (1.0 - f * s);
    t = v * (1.0 - (1.0 - f) * s);

    case(i % 6)
    when 0
      i = [v,t,p]
    when 1
      i = [q,v,p]
    when 2
      i = [p,v,t]
    when 3
      i = [p,q,v]
    when 4
      i = [t,p,v]
    when 5
      i = [v,p,q]
    end
    return '#' + i.map{|c|(c*255).to_i.to_s(16).rjust(2,"0")}.join#.to_s
  end

  def subject_background
    nnote ? nil : (options && options[:subject_background] ? options[:subject_background] : '#f0f4b7')
  end

  def body_background
    nnote ? nil : (options && options[:body_background] ? options[:body_background] : '#f0f4b7')
  end
  #  def rand_color(h=rand,s=rand*0.25+0.5,v=rand/10.0+0.9)
  #    @rand_seed = (@rand_seed||rand(6))+1
  #    p = v*(1-s);
  #    q = v*(1-h*s);
  #    t = v*(1-(1-h)*s);
  #    '#' + case(@rand_seed % 6)
  #    when 0;[v,t,p];when 1;[q,v,p]
  #    when 2;[p,v,t];when 3;[p,q,v]
  #    when 4;[t,p,v];when 5;[v,p,q]
  #    #end.map{|c|(c*255).to_i.to_s(16).rjust(2,"0")}.to_s
  #    end.map{|c|(c*255).to_i.to_s(16).rjust(2,"0")}.join
  #  end


  #  def self.migrate_to_options!
  #    self.each do |note|
  #      custome_options.each do |k, v|
  #        unless options && options[k]
  #          if options = {k
  #        end
  #    end
  #  end

  #  has_dynamic_attributes
  #  $dynamic_attrs = [
  #    ['width', 'integer', 300],
  #    ['height', 'integer', 200],
  #    ['x', 'integer', 0],
  #    ['y', 'integer', 0]
  #  ]
  # acts_as_dynamic_attributes($dynamic_attrs)
end

