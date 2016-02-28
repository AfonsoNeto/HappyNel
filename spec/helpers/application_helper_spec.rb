require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "formatted poll result" do
    it "returns as string round with 2 algarisms" do
      expect(helper.formatted_final_result(7.214)).to eq("7.21")
    end
  end

  describe "render alert" do
    it "must show bootstrap alert" do
    	flash[:notice] = "Notice"
      expect(helper.render_alert(flash[:notice])).to be
    end
  end

  describe "render attribute errors" do
    it "must show full_message" do
    	user = build :user, name: nil
    	expect(user.valid?).to eq(false)
      expect(helper.render_attribute_error_if_any(user.errors, :name)).to be
    end
  end

  describe "render star" do
    it "must show bootstrap glyphicons stars" do
    	score = rand(1..5)
      expect(helper.render_stars_count(score)).to be
    end
  end
end
