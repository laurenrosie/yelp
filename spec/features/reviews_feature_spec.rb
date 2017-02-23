feature 'reviewing' do
  before do
    @user = User.create(email: 'test@gmail.com', password: '1234')
    Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1, user: @user
  end

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

end
