require "test_helper"

module ReactParticles
  class ComponentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    test "should get root" do
      get root_path
      assert_response :success
    end

    test "should get index" do
      get components_index_url
      assert_response :success
    end
  end
end
