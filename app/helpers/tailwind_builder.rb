# frozen_string_literal: true

class TailwindBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {})
    super(method, text, options.reverse_merge({ class: 'text-gray-700' }))
  end

  %i[email_field password_field].each do |field_type|
    define_method(field_type) do |method, options = {}|
      super(method, options.reverse_merge({ class: 'mt-1 block w-full rounded-md border-gray-300' }))
    end
  end

  def check_box(method, options = {})
    super(method, options.reverse_merge({ class: 'rounded border-gray-300 text-secondary' }))
  end

  def submit(method, options = {})
    super(method, options.reverse_merge({
                                          class: 'text-white text-center font-medium rounded-full bg-primary w-fit px-6
                                             py-3.5'
                                        }))
  end
end
