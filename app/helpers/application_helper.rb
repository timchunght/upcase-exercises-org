module ApplicationHelper
  def content_tag_with_conditional_classes(tag_name, attributes, &block)
    class_names = attributes[:class_names]
    active_class_names = class_names.select { |_, active| active }.keys
    base_attributes = attributes.except(:class_names)
    class_attribute = { class: active_class_names.join(" ") }
    content_tag(tag_name, base_attributes.merge(class_attribute), &block)
  end
end
