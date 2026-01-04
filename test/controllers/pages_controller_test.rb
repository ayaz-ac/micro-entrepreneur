# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'it should render the show view' do
    get root_url

    assert_response :success

    assert_select 'p', 'Hello World'
  end
end
