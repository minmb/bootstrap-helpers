# Author::    Maurizio Casimirri (mailto:maurizio.cas@gmail.com)
# Copyright:: Copyright (c) 2012 Maurizio Casimirri
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module BootstrapHelpers

  # ============
  # = Scaffold =
  # ============

  def bootstrap_container_class
    bootstrap_fluid? ? "container-fluid" : "container"
  end
    
  def bootstrap_row_class
    bootstrap_fluid? ? "row-fluid" : "row"
  end

  def bootstrap_fluid!
    @bootstrap_float_style = true
  end

  def bootstrap_fluid?
    !!@bootstrap_float_style
  end
    
  def container(opts = {}, &block)
    if opts.delete(:fluid)
      bootstrap_fluid!
    end
      
    opts[:class] = ("#{opts[:class]}".split(" ") + [bootstrap_container_class]).join(" ")   
    content_tag("div", opts, &block)
  end

  def row(opts = {}, &block)

    opts[:class] = ("#{opts[:class]}".split(" ") + [bootstrap_row_class]).join(" ")
    content_tag("div", opts, &block)      
  end
        
  def span(size, opts = {}, &block)
    offset = opts.delete(:offset)
    class_arr =  ("#{opts[:class]}".split(" ") + ["span#{size}"])
    if offset
      class_arr << "offset#{offset}"
    end
      
    opts[:class] = class_arr.join(" ")
    content_tag("div", opts, &block)
      
  end
    
  def icon(icon_id, opts={})
    opts[:class] ||= ""
    opts[:class] << " icon icon-#{icon_id}"
    opts[:class].strip!
    tag :i, opts
  end
  
  # ============
  # = Base CSS =
  # ============
  
  
  def button(*args, &block)
    if !block_given?
      opts = args.extract_options!
      is_link = (!!args.second) || (args.any? && block_given?)

      icon = opts.delete(:icon)
      type_opt =  opts.delete(:type)
      kind = type_opt ? "btn-#{type_opt}" : nil
      size_opt = opts.delete(:size)
      size = size_opt ? "btn-#{size_opt}" : nil
      klasses = ("#{opts[:class]}".split(/\s+/) + ["btn", kind, size]).compact.uniq
      opts[:class] = klasses.join(" ")
      if icon
        icon_color = opts.delete(:icon_color)
        classes = [icon, icon_color].compact.map {|c| "icon-#{c}"}.join(" ")
        args.unshift "<i class=\"#{classes}\"></i> #{args.shift}".html_safe
      end

      args << opts
    end

    if is_link
      link_to(*args, &block)
    else
      content_tag('button', *args, &block)
    end

  end

  alias :btn :button
  
  
  def form_actions(&block)
    content_tag :div, :class => "form-actions", &block
  end

  def alert(message)
    "<div class='alert'>#{h(message)}</div>".html_safe
  end
  
  
  # ==============
  # = Navigation =
  # ==============
    
  def navbar(*args, &block)
    opts = args.extract_options!
    fluid = opts.delete(:fluid)
    html = <<-STR
    <div class="navbar#{opts[:fixed].present? ? ' navbar-fixed-' + opts[:fixed].to_s : ''}">
      <div class="navbar-inner">
        <div class="#{fluid ? 'container-fluid' : 'container'}">
          #{capture(&block)}
        </div>
      </div>
    </div>
    STR

    html.html_safe
  end


  def nav(options = {}, &block)
    "<ul class=\"nav #{options[:class]}\">#{capture(&block)}</ul>".html_safe
  end
      
  def pills(options = {}, &block)
    "<ul class=\"nav nav-pills #{options[:class]}\">#{capture(&block)}</ul>".html_safe
  end
    
  def nav_header(txt)
    "<li class=\"nav-header\">#{txt}</li>".html_safe
  end

  def nav_list(options = {}, &block)
    "<ul class=\"nav nav-list #{options[:class]}\">#{capture(&block)}</ul>".html_safe
  end

  def dropdown_nav_item(label, opts = {}, &block)
    icon = opts.delete(:icon)
    if icon
      icon_color = opts.delete(:icon_color)
      classes = [icon, icon_color].compact.map {|c| "icon-#{c}"}.join(" ")
      label =  "<i class=\"#{classes}\"></i> #{label}".html_safe
    end

    html = <<-STR
      <li class="dropdown">
      <a class="dropdown-toggle"
       data-toggle="dropdown"
       href="#">
        #{label}
        <b class="caret"></b>
      </a>
      <ul class="dropdown-menu">#{capture(&block)}</ul></li>
    STR
    html.html_safe
  end


  def nav_item(*args, &block)
    if !block_given?
      opts = args.extract_options!
      icon = opts.delete(:icon)
      float = opts.delete(:float)
      if icon
        icon_color = opts.delete(:icon_color)
        classes = [icon, icon_color].compact.map {|c| "icon-#{c}"}.join(" ")
        args.unshift "<i class=\"#{classes}\"></i> #{h(args.shift)}".html_safe
      end
      args << opts
    end

    url = block_given? ? args.first : args[1]

    classes = []
    if current_page?(url)
      classes <<  "active"
    end

    if  float
      classes += ["float", "#{float}"]
    end

    with_class = classes.any? ? " class='#{classes.join(' ')}'" : ""
    "<li#{with_class}>#{link_to(*args, &block)}</li>".html_safe
  end


  def brand(*args, &block)

    if !args.last.is_a?(Hash)
      args << {}
    end
    args.last[:class] = "brand"

    link_to(*args, &block)
  end

    
  # ========
  # = Tabs =
  # ========
    
  class TabsBuilder

    attr_reader :parent, :pane_contents, :pane_handles
    delegate :capture, :content_tag, :to => :parent

    def initialize parent
      @first = true
      @parent = parent
      @pane_handles = []
      @pane_contents = []
    end

    def pane(title, pane_id = nil, &block)
      pane_id ||= "#{title.parameterize}_tab"
      css_class, @first = 'active', false if @first
      link = content_tag(:a, title, :'data-toggle' => 'tab', :href => "##{pane_id}")
      @pane_handles << content_tag(:li, link, :class => css_class)
      @pane_contents << (content_tag :div, :class => "tab-pane #{css_class}", :id => "#{pane_id}" do
        capture(&block)
      end)
      nil
    end
      
  end  # ~ TabsBuilder


  def tabs(opts = {})
    opts[:direction] ||= 'above'
    opts[:style] ||= 'tabs'
    builder = TabsBuilder.new self
    yield builder
    tabs = content_tag(:ul, builder.pane_handles.join("\n").html_safe, :class => "nav nav-#{opts[:style]}")
    contents = content_tag(:div, builder.pane_contents.join("\n").html_safe, :class => 'tab-content')
    css_direction = "tabs-#{opts[:direction]}" unless opts[:direction] == 'above'
    content_tag :div, :class => "tabbable #{css_direction}" do
      if opts[:direction] == 'below'
        contents + tabs
      else
        tabs + contents
      end
    end
  end


  # =============
  # = Accordion =
  # =============
    
  class AccordionBuilder

    attr_reader :parent
    delegate :capture, :content_tag, :link_to, :to => :parent

    def initialize(opts, parent)
      @first = true
      @parent = parent
      @opts = opts
    end

    def pane(title, pane_id = nil, &block)
      css_class =  (@first && @opts[:open]) ? 'in' : ''
      pane_id ||= "#{title.parameterize}_pane" 
      
      @first = false
      content_tag :div, :class => 'accordion-group' do
        heading = content_tag :div, :class => 'accordion-heading' do
          link_to title, "##{pane_id}", :class => 'accordion-toggle', :'data-toggle' => 'collapse',
          :'data-parent' => "##{@opts[:accordion_id]}"
        end
        body = content_tag :div, :class => "accordion-body collapse #{css_class}", :id => "#{pane_id}" do
          content_tag :div, :class => 'accordion-inner' do
            capture(&block)
          end
        end
        heading + body
      end
    end
  
  end # ~ AccordionBuilder
  
  def accordion(opts = {})
    opts[:accordion_id] ||= 'accordion'
    builder = AccordionBuilder.new opts, self
    content_tag :div, :class => 'accordion', :id => opts[:accordion_id] do
      yield builder
    end
  end
    
end

ActionView::Base.send :include, BootstrapHelpers 

















    


