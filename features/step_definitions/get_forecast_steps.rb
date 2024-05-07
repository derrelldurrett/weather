Given('the app is up') do
  visit('/up')
  expect(page.status_code).to eq(200)
end

Given(/the time is (less|more) than thirty minutes after my most recent call/) do |less_or_more|
  less_or_more == 'less' ? Timecop.freeze(cached_observation_time) :
    Timecop.freeze(refreshed_observation_time)
end

Given('a cached forecast exists for my zipcode') do
  Forecast.build(zipcode: 95014, data: initial_forecast_data).save!
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

Then(/I receive the observations for the (address|zipcode)/) do |_type|
  expect(page.status_code).to eq(200)
  expect(page).to have_text('Current conditions for 95014')
  expect(page).to have_text('Mostly Clear')
end

Then(/I receive the (cached|refreshed) observations for the zipcode/) do |cached_or_refreshed|
  cached_or_refreshed == 'cached' ? cached_forecast_expectations :
    refreshed_forecast_expectations
end

Then(/I receive the forecast for the (address|zipcode)/) do |_type|
  cached_forecast_expectations
end
