module ApplicationHelper
  def build_category_checkboxes(post_f)
    post_f.collection_check_boxes(:category_ids, Category.all, :id, :name, {}, class: 'checkbox inline') do |b|
      b.label { b.check_box + b.text }
    end
  end
end
