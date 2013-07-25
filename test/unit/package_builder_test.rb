require 'test_helper'

class PackageBuilderTest < ActiveSupport::TestCase

  fixtures :smoke_tests

  test "create" do
    builder = PackageBuilder.create(
        :url => "lp:nova",
        :merge_trunk => true,
        :smoke_test_id => smoke_tests(:trunk).id
    )
    assert_equal "lp:nova", builder.url
    assert_equal true, builder.merge_trunk
  end

  test "create fails without url" do
    builder = PackageBuilder.create(
        :merge_trunk => true,
        :smoke_test_id => smoke_tests(:trunk).id
    )
    assert_equal false, builder.valid?
  end

end
