# frozen_string_literal: true

class TailwindBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {})
    super(method, text, options.reverse_merge({ class: 'text-brand-900' }))
  end

  %i[email_field password_field number_field].each do |field_type|
    define_method(field_type) do |method, options = {}|
      super(method, options.reverse_merge({ class: 'mt-1.5 block w-full rounded-md border-brand-950' }))
    end
  end

  def check_box(method, options = {})
    super(method, options.reverse_merge({ class: 'rounded border-gray-300 text-secondary' }))
  end

  def submit(method, options = {})
    super(method, options.reverse_merge({
                                          class: 'text-center text-white rounded-lg bg-brand-500 px-8 py-2.5
                                                  lg:transition lg:text-lg lg:hover:-translate-y-1 lg:hover:scale-105
                                                  lg:hover:drop-shadow-lg duration-300'
                                        }))
  end
end
