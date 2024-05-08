Before('@initial or @cached or @refreshed') do
  load_stubs_of_external_calls
end

Around('@initial') do |_scenario, block|
  Timecop.freeze initial_observation_time
  block.call
  Timecop.return
end

After('@cached or @refreshed') do |_scenario|
  Timecop.return
end

Given('the app is up') do
  visit('/up')
  expect(page.status_code).to eq(200)
end

Given('a cached forecast exists for my zipcode') do
  Forecast.build(zipcode: 95014, data: initial_forecast_data, observed_at: initial_observation_time).save!
end

Given(/the time is now a time when I would expect a (cached|refreshed) observation/) do |time|
  freeze_at = time == 'cached' ? cached_observation_time : refreshed_observation_time
  Timecop.freeze freeze_at
end

When('I go to the root page') do
  visit('/')
  expect(page).to have_text('Address')
end

When(/I enter a legitimate (address|zipcode): "([^"]*)"/) do |_type, address|
  within '#forecast_address' do
    fill_in with: address
  end
  click_on 'Get Forecast!'
end

Then(/I receive the (initial|cached|refreshed) observations for the (address|zipcode)/) do |observation, _location|
  expect(page.status_code).to eq(200)
  within '#current_conditions' do
    case observation
    when 'initial'
      initial_observations
    when 'cached'
      cached_observations
    when 'refreshed'
      refreshed_observations
    else
      raise 'no such observation'
    end
  end
end

Then(/I receive the (initial|cached|refreshed) forecast for the (address|zipcode)/) do |observation, _type|
  case observation
  when 'initial'
    initial_forecast_expectations
  when 'cached'
    cached_forecast_expectations
  when 'refreshed'
    refreshed_forecast_expectations
  else
    raise 'no such observation'
  end
end
