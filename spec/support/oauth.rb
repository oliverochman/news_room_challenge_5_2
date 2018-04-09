OmniAuth.config.test_mode = true

user = {provider: 'facebook',
        uid: '123545',
        info: {
            first_name: 'Thomas',
            last_name: 'Ochman',
            email: 'thomas@craft.com'
        },
        credentials: {
            token: '1234567890',
            expires_at: Time.now + 1.week
        }}

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(user)
