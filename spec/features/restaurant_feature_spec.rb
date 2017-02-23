require 'rails_helper'
#save_and_open_page

describe Restaurant do
  it 'belongs to a user' do
    should belong_to(:user)
  end
end

feature 'restaurants' do

  context 'user has not logged in' do

    before do
      @user = User.create(email: 'test@gmail.com', password: 'testtest')
      Restaurant.create(name: 'KFC', user: @user)
    end

    scenario 'user cannot add restaurant' do
      visit '/'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'
    end

    scenario 'user cannot edit a restaurant' do
      visit '/'
      click_link 'Edit KFC'
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'
    end

    scenario 'user cannot delete a restaurant' do
      visit '/'
      click_link 'Delete KFC'
      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'
    end
  end

  context 'user has logged in or just signed up' do

    # before do
    #   visit('/')
    #   click_link('Sign up')
    #   fill_in('Email', with: 'test@gmail.com')
    #   fill_in('Password', with: 'testtest')
    #   fill_in('Password confirmation', with: 'testtest')
    #   click_button('Sign up')
    # end

 context 'no restaurants have been added' do
   scenario 'should display a prompt to add a restaurant' do
     visit '/restaurants'
     expect(page).to have_content 'No restaurants yet'
     expect(page).to have_link 'Add a restaurant'
   end
 end

 context 'restaurants have been added' do
  before do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@gmail.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
    @user = User.create(email: 'test@gmail.com', password: 'testtest')
    Restaurant.create(name: 'KFC', user: @user)
  end

  scenario 'display restaurants' do
    visit '/restaurants'
    expect(page).to have_content('KFC')
    expect(page).not_to have_content('No restaurants yet')
  end
 end

 context 'creating restaurants' do

   before do
     visit('/')
     click_link('Sign up')
     fill_in('Email', with: 'test@gmail.com')
     fill_in('Password', with: 'testtest')
     fill_in('Password confirmation', with: 'testtest')
     click_button('Sign up')
   end
  scenario 'prompts user to fill out a form, then displays the new restaurant' do
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    fill_in 'Description', with: 'Deep fried goodness'
    click_button 'Create Restaurant'
    expect(page).to have_content 'KFC'
    expect(page).to have_content 'Deep fried goodness'
    expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  end

context 'viewing restaurants' do

  let!(:kfc) do
    @user = User.create(email: 'test@gmail.com', password: 'testtest')
    Restaurant.create(name: 'KFC', user: @user)
  end


  scenario 'lets a user view a restaurant' do
    visit '/restaurants'
    click_link 'KFC'
    expect(page).to have_content 'KFC'
    expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

context 'editing restaurants' do

  before do
    @user = User.create(email: 'testing@gmail.com', password: 'testtest')
    puts @user.inspect
    Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1, user: @user
  end

  scenario 'let a user edit a restaurant' do
    visit '/'
    click_link('Sign in')
    fill_in('Email', with: 'testing@gmail.com')
    fill_in('Password', with: 'testtest')
    click_button('Log in')
    click_link 'Edit KFC'
    fill_in 'Name', with: 'Kentucky Fried Chicken'
    fill_in 'Description', with: 'Deep fried goodness'
    click_button 'Update Restaurant'
    click_link 'Kentucky Fried Chicken'
    expect(page).to have_content 'Kentucky Fried Chicken'
    expect(page).to have_content 'Deep fried goodness'
    expect(current_path).to eq '/restaurants/1'
   end
  end

  context 'deleting restaurants for correct user' do

    before do
      @user = User.create(email: 'test@example.com', password: 'testtest')
      Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1, user: @user
    end

  scenario 'removes a restaurant when a user clicks a delete link' do
    visit('/')
    click_link('Sign in')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    click_button('Log in')
    visit '/restaurants'
    click_link 'Delete KFC'
    expect(page).not_to have_content 'KFC'
    expect(page).to have_content 'Restaurant deleted successfully'
  end

end

context 'not deleting restaurants for incorrect user' do

scenario 'removes a restaurant when a user clicks a delete link' do
  @user = User.create(email: 'another_user@gmail.com', password: 'testtest')
  @someone_else = User.create(email: 'someone_else@example.com', password: 'testtest')
  Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1, user: @user
  visit('/')
  click_link('Sign in')
  fill_in('Email', with: 'someone_else@example.com')
  fill_in('Password', with: 'testtest')
  click_button('Log in')
  save_and_open_page
  click_link 'Delete KFC'
  save_and_open_page
  expect(page).to have_content 'KFC'
  expect(page).to have_content 'Access denied as you are not the  owner of this Restaurant'
end

end
end
end
