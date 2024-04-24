Given('the app is up') do
  visit('/up')
  expect(page.status_code).to eq(200)
end

When('I go to the root page') do
  visit('/')
  expect(page).to have_text('Address')
end

When(/I enter a legitimate (address|zipcode): "([^"]*)"/) do |_type, address|
  load_stubs_of_external_calls
  within '#forecast_address' do
    fill_in with: address
  end
  click_on 'Get Forecast!'
end

Then(/I receive the conditions for the (address|zipcode)/) do |_type|
  expect(page.status_code).to eq(200)
  expect(page).to have_text('Current conditions for 95014')
  expect(page).to have_text('Mostly Clear')
end

Then(/I receive the forecast for the (address|zipcode)/) do |_type|
  expect(page).to have_text('Mostly Clear')
  expect(page).to have_text('70°F')
  expect(page).to have_text('0%')
end
