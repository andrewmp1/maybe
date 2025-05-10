require "application_system_test_case"

class JankiesTest < ApplicationSystemTestCase
  setup do
    sign_in @user = users(:family_admin)

    Family.any_instance.stubs(:get_link_token).returns("test-link-token")

    visit root_url
    open_new_account_modal
  end

  test "can create janky account" do
    assert_account_created("Janky")
  end

  private

    def assert_account_created(accountable_type, &block)
      click_link Accountable.from_type(accountable_type).display_name.singularize
      click_link "Enter account balance" if accountable_type.in?(%w[Depository Investment Crypto Loan CreditCard Janky])

      account_name = "[system test] #{accountable_type} Account"

      fill_in "Account name*", with: account_name
      fill_in "account[balance]", with: 100.99

      yield if block_given?

      click_button "Create Account"

      within_testid("account-sidebar-tabs") do
        click_on "All"
        find("details", text: Accountable.from_type(accountable_type).display_name).click
        assert_text account_name
      end

      visit accounts_url
      assert_text account_name

      created_account = Account.order(:created_at).last

      visit account_url(created_account)

      within_testid("account-menu") do
        find("button").click
        click_on "Edit"
      end

      fill_in "Account name", with: "Updated account name"
      click_button "Update Account"
      assert_selector "h2", text: "Updated account name"
    end

    def open_new_account_modal
      within "[data-controller='tabs']" do
        click_button "All"
        click_link "New account"
      end
    end
end
