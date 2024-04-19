Given('the app is up') do
  visit('/up')
  expect(page.status_code).to eq(200)
end

When('I go to the root page') do
  visit('/')
  expect(page).to have_text('Address')
end

When('I enter a legitimate address') do
  within '#forecast_address' do
    fill_in with: '1 Apple Park Way, Cupertino, California'
  end
  click_on 'Create Forecast'
end

Then('I receive the conditions for the address') do
  expect(page.status_code).to eq(200)
end


