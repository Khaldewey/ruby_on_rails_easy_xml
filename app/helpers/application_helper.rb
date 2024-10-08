module ApplicationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    def page_number(page)
      unless page == current_page
        link(page, page, :rel => rel_value(page))
      else
        link(page, "#", :class => 'active')
      end
    end
    def gap
      text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
      %(<li class="disabled"><a>#{text}</a></li>)
    end
    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end
    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        link(text, "#", :class => classname + ' disabled')
      end
    end
    def html_container(html)
      tag(:ul, html, container_attributes)
    end
    private
    def link(text, target, attributes = {})
    if target.is_a? Fixnum
      attributes[:rel] = rel_value(target)
      target = url(target)
    end
    unless target == "#"
        attributes[:href] = target
    end
    classname = attributes[:class]
    attributes.delete(:classname)
    tag(:li, tag(:a, text, attributes), :class => classname)
    end
  end
  def title(title = nil)
     if title.present?
       content_for :title, title
     else
       content_for?(:title) ? content_for(:title)+ ' | ' + APP_CONFIG['default_title'] : APP_CONFIG['default_title']
     end
   end

  def meta_description(desc = nil)
     if desc.present?
       content_for :meta_description, desc
     else
       content_for?(:meta_description) ? content_for(:meta_description) : APP_CONFIG['meta_description']
     end
  end   

  def social_shared_title(title = nil)
    content_for :shared_title, title
  end

  def social_shared_description(description = nil)
    content_for :shared_description, description
  end

  def social_shared_image(url_image = nil)
    content_for :shared_image, url_image
  end
end
